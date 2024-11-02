import 'package:airview_tech/Auth/login.dart';
import 'package:airview_tech/Home/offer_detail.dart';
import 'package:airview_tech/Home/offer_item.dart';
import 'package:airview_tech/Home/profile/profile_edit.dart';
import 'package:airview_tech/models/app_user.dart';
import 'package:airview_tech/models/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Network/repository.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile>
    with AutomaticKeepAliveClientMixin<Profile> {
  final repository = Repository();
  AppUser? _user;
  String? icon;
  Color? color;
  bool saving = false;
  Future<List<DocumentSnapshot>>? future;
  String id = "";
  List<String> languages = ['English', 'French'];
  final df = DateFormat('dd-MM-yyyy HH:mm');
  String? selectedLanguage;
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }

  retrieveUserDetails() async {
    User? currentUser = repository.getCurrentUser();
    if (currentUser != null) {
      AppUser? user = await repository.retrieveUserDetails(currentUser);
      setState(() {
        _user = user;
      });
      id = currentUser.uid;
      future = repository.retrieveTickets(currentUser.uid);
    } else {
      future = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        elevation: 1,
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF73AEF5),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings_power),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              repository.signOut().then((v) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("isLoggedIn", false);

                if (mounted) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const Login();
                  }));
                }
              });
            },
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: saving,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: _user != null ? _buildProfileView() : Container(),
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(children: <Widget>[
      _buildUserInfo(),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Row(
      //     children: [
      //       const Text(
      //         "Language: ",
      //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      //       ),
      //       Expanded(
      //         child: DropdownButton<String>(
      //           value: selectedLanguage,
      //           isExpanded: true,
      //           items: languages.map((String value) {
      //             return DropdownMenuItem<String>(
      //               value: value,
      //               child: Text(
      //                 value,
      //                 overflow: TextOverflow.ellipsis,
      //                 style: const TextStyle(
      //                     fontWeight: FontWeight.w400, fontSize: 15),
      //               ),
      //             );
      //           }).toList(),
      //           onChanged: (newValue) {
      //             setState(() {
      //               // if (newValue == 'English') {
      //               //   this.setState(() {
      //               //     selectedLanguage = 'English';
      //               //     //icon = "us.png";
      //               //     context.locale = Locale('en', 'US');
      //               //   });
      //               // } else if (newValue == 'French') {
      //               //   this.setState(() {
      //               //     selectedLanguage = 'French';
      //               //     //icon = "fr.png";
      //               //     context.locale = Locale('fr', 'CA');
      //               //   });
      //               // }
      //             });
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      _buildUserDetails(),
      Expanded(child: ticketsWidget()),
    ]);
  }

  Widget ticketsWidget() {
    return FutureBuilder(
      future: future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            tickets = snapshot.data
                    ?.map((e) =>
                        Ticket.fromJson(e.data() as Map<String, dynamic>))
                    .toList() ??
                [];
            return GridView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: snapshot.data?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemBuilder: ((context, index) {
                return Stack(
                  children: [
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: OfferItem(
                          ticket: tickets[index],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => OfferDetail(
                                  ticket: tickets[index],
                                )),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          _showDeleteDialog(index);
                        },
                      ),
                    ),
                  ],
                );
              }),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('No Tickets Found'),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(
          child: Text(''),
        );
      }),
    );
  }

  Future<void> _showDeleteDialog(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Ticket'),
        content: const Text('Are you sure you want to delete this ticket?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Confirm delete
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      repository.deleteTicket(tickets[index].ticketid ?? "");
      tickets.removeAt(index);
    }
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 20.0),
          child: Text((_user?.displayName ?? "").capitalize(),
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0)),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Divider(),
        ),
      ],
    );
  }

  Widget _buildUserDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                    child: Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Colors.grey)),
                      child: const Center(
                        child: Text("Edit Profile",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => EditProfileScreen(_user,
                            photoUrl: _user?.photoUrl,
                            email: _user?.email,
                            name: _user?.displayName,
                            city: _user?.city,
                            country: _user?.country,
                            phone: _user?.phone)),
                      ),
                    );
                    retrieveUserDetails();
                  },
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 0, right: 0),
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Colors.grey)),
                      child: const Center(
                        child: Text("Contact Us",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  onTap: () async {
                    final Email email = Email(
                      body: 'Hi',
                      subject: 'Contact',
                      recipients: ['Contactus.tickettogo@gmail.com'],
                      isHTML: false,
                    );

                    try {
                      await FlutterEmailSender.send(email);
                    } catch (error) {
                      print('Error sending email: $error');
                    }
                  },
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 0, right: 0),
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Colors.grey)),
                      child: const Center(
                        child: Text("Remove Account",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  onTap: () async {
                    repository.removeAccount();
                    repository.signOut().then((v) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("isLoggedIn", false);
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const Login();
                          }),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget detailsWidget(String count, String label) {
    return Column(
      children: <Widget>[
        Text(count,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.black)),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(label,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
