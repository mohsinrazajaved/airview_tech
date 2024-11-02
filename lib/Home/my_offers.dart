import 'package:airview_tech/Home/offer_detail.dart';
import 'package:airview_tech/Home/offer_item.dart';
import 'package:airview_tech/Network/repository.dart';
import 'package:airview_tech/Utilities/widgets.dart';
import 'package:airview_tech/models/app_user.dart';
import 'package:airview_tech/models/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MyOfferView extends StatefulWidget {
  const MyOfferView({Key? key}) : super(key: key);

  @override
  MyOfferViewState createState() => MyOfferViewState();
}

class MyOfferViewState extends State<MyOfferView> {
  final key = GlobalKey<ScaffoldState>();
  bool saving = false;
  final _repository = Repository();
  Future<List<DocumentSnapshot>>? _future;
  AppUser? _user;
  User? currentUser;
  List<Ticket?> tickets = [];

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }

  retrieveUserDetails() async {
    currentUser = _repository.getCurrentUser();
    if (currentUser != null) {
      AppUser? user = await _repository.retrieveUserDetails(currentUser!);
      setState(() {
        _user = user;
      });
    }
    _future = _repository.retrieveTickets(_user?.uid ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ModalProgressHUD(
              inAsyncCall: saving,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "My Tickets".tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Expanded(child: _buildTicketList()),
                ],
              )),
        ));
  }

  Widget _buildTicketList() {
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Center(child: Text("No Tickets Found".tr));
        }

        tickets = snapshot.data!
            .map((e) => Ticket.fromJson(e.data() as Map<String, dynamic>))
            .toList();

        tickets.sort((a, b) => (a?.time?.millisecondsSinceEpoch ?? 0)
            .compareTo(b?.time?.millisecondsSinceEpoch ?? 0));

        if (tickets.isEmpty) {
          return Center(child: Text("No Tickets Found".tr));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (currentUser == null) {
                    Widgets.showInSnackBar("Please Signup/Login".tr, key);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OfferDetail(ticket: tickets[index]!),
                      ),
                    );
                  }
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        child: OfferItem(ticket: tickets[index]!),
                      ),
                      Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _showDeleteDialog(index);
                            },
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showDeleteDialog(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Ticket".tr),
        content: Text("Are you sure you want to delete this ticket?".tr),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Close the dialog
            },
            child: Text("Cancel".tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Confirm delete
            },
            child: Text("Delete".tr),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _repository.deleteTicket(tickets[index]?.ticketid ?? "");
      tickets.removeAt(index);
    }
  }
}
