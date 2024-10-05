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
    _future = _repository.retrieveTickets(_user?.uid ?? "");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text("Tickets",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        elevation: 1,
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF73AEF5),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterScreen(
                        countries:
                            offers.map((e) => e?.country).toSet().toList(),
                        types: offers.map((e) => e?.type).toSet().toList(),
                        cities: offers.map((e) => e?.city).toSet().toList(),
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
              icon: const Icon(Icons.filter_alt))
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: saving,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(child: _buildTicketList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketList() {
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('No Tickets Found'));
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
          return const Center(child: Text('No Tickets Found'));
        }

        return ListView.builder(
          itemCount: offers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (currentUser == null) {
                  Widgets.showInSnackBar("Please Signup/Login", key);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OfferDetail(ticket: offers[index]!),
                    ),
                  );
                }
              },
              child: OfferItem(ticket: offers[index]!),
            );
          },
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
