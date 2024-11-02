import 'package:airview_tech/Home/offer_detail.dart';
import 'package:airview_tech/Home/offer_filter.dart';
import 'package:airview_tech/Home/offer_item.dart';
import 'package:airview_tech/Network/repository.dart';
import 'package:airview_tech/Utilities/widgets.dart';
import 'package:airview_tech/models/app_user.dart';
import 'package:airview_tech/models/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OfferView extends StatefulWidget {
  const OfferView({Key? key}) : super(key: key);

  @override
  OfferViewState createState() => OfferViewState();
}

class OfferViewState extends State<OfferView>
    with AutomaticKeepAliveClientMixin<OfferView> {
  final key = GlobalKey<ScaffoldState>();
  bool saving = false;
  final _repository = Repository();
  Future<List<DocumentSnapshot>>? _future;
  AppUser? _user;
  User? currentUser;

  List<String?> cities = [];
  List<String?> countries = [];
  List<String?> types = [];
  List<Ticket?> offers = [];

  String? selectedCountry;
  String? selectedCity;
  String? selectedType;
  DateTime? selectedDate;

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
    _future = _repository.retrieveAllTickets();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: key,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ModalProgressHUD(
              inAsyncCall: saving,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tickets".tr,
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
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF00BF6D),
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FilterScreen(
                    countries:
                        offers.map((e) => e?.country ?? "").toSet().toList(),
                    types: offers.map((e) => e?.type ?? "").toSet().toList(),
                    cities: offers.map((e) => e?.city ?? "").toSet().toList(),
                    callback: (country, city, type, data) {
                      setState(() {
                        selectedCountry = country;
                        selectedCity = city;
                        selectedType = type;
                        selectedDate = data;
                      });
                    }),
              ),
            );
          },
          child: const Icon(Icons.filter_alt),
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

        offers = snapshot.data!
            .map((e) => Ticket.fromJson(e.data() as Map<String, dynamic>))
            .toList();

        offers.sort((a, b) => (a?.time?.millisecondsSinceEpoch ?? 0)
            .compareTo(b?.time?.millisecondsSinceEpoch ?? 0));

        if (selectedCity != null) {
          offers = offers.where((e) => e?.city == selectedCity).toList();
        }
        if (selectedCountry != null) {
          offers = offers.where((e) => e?.country == selectedCountry).toList();
        }
        if (selectedType != null) {
          offers = offers.where((e) => e?.type == selectedType).toList();
        }
        if (selectedDate != null) {
          offers = offers.where((e) {
            return e?.time != null && isSameDay(e?.time, selectedDate);
          }).toList();
        }

        if (offers.isEmpty) {
          return Center(child: Text("No Tickets Found".tr));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: offers.length,
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
                            OfferDetail(ticket: offers[index]!),
                      ),
                    );
                  }
                },
                child: OfferItem(ticket: offers[index]!),
              );
            },
          ),
        );
      },
    );
  }

  bool isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  bool get wantKeepAlive => true;
}
