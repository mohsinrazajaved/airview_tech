import 'package:airview_tech/Home/offer_detail.dart';
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
  String? selectedCity;

  List<String?> countries = [];
  String? selectedCountry;

  List<String?> types = [];
  String? selectedType;

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
        title: const Text("Offers"),
        elevation: 1,
        backgroundColor: const Color(0xFF73AEF5),
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
                  _buildFilters(),
                  Expanded(child: _buildTicketList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDropdown("Type", types, selectedType, (value) {
          setState(() {
            selectedType = value;
          });
        }),
        _buildDropdown("Country", countries, selectedCountry, (value) {
          setState(() {
            selectedCountry = value;
          });
        }),
        _buildDropdown("City", cities, selectedCity, (value) {
          setState(() {
            selectedCity = value;
          });
        }),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String?> items,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              hint: Text("Select $label"),
              items: items.map((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketList() {
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        List<Ticket?> offers = [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('No Tickets Found'));
        }

        offers = snapshot.data!
            .map((e) => Ticket.fromJson(e.data() as Map<String, dynamic>))
            .toList();

        // Filter logic
        if (selectedCity != null) {
          offers = offers.where((e) => e?.city == selectedCity).toList();
        }
        if (selectedCountry != null) {
          offers = offers.where((e) => e?.country == selectedCountry).toList();
        }
        if (selectedType != null) {
          offers = offers.where((e) => e?.type == selectedType).toList();
        }

        offers.sort((a, b) => (a?.time?.millisecondsSinceEpoch ?? 0)
            .compareTo(b?.time?.millisecondsSinceEpoch ?? 0));

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

  @override
  bool get wantKeepAlive => true;
}
