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
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        backgroundColor: const Color(0xFF73AEF5),
        elevation: 1,
        title: const Text('Profile'),
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
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Text(
              "Language: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: DropdownButton<String>(
                value: selectedLanguage,
                isExpanded: true,
                items: languages.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    // if (newValue == 'English') {
                    //   this.setState(() {
                    //     selectedLanguage = 'English';
                    //     //icon = "us.png";
                    //     context.locale = Locale('en', 'US');
                    //   });
                    // } else if (newValue == 'French') {
                    //   this.setState(() {
                    //     selectedLanguage = 'French';
                    //     //icon = "fr.png";
                    //     context.locale = Locale('fr', 'CA');
                    //   });
                    // }
                  });
                },
              ),
            ),
          ],
        ),
      ),
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
            final tickets = snapshot.data
                    ?.map((e) =>
                        Ticket.fromJson(e.data() as Map<String, dynamic>))
                    .toList() ??
                [];
            return GridView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: snapshot.data?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, crossAxisSpacing: 0, mainAxisSpacing: 0),
              itemBuilder: ((context, index) {
                return GestureDetector(
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

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 20.0),
          child: Text(_user?.displayName ?? "",
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
