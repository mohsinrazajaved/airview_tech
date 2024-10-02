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
  final Key mapKey = UniqueKey();
  final _repository = Repository();
  Future<List<DocumentSnapshot>>? _future;
  AppUser? _user;
  User? currentUser;

  List<String?> cities = [];
  String? selectedCity;

  List<String?> country = [];
  String? selectedCountry;

  List<String?> type = [];
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
        title: const Text("Offer"),
        elevation: 1,
        backgroundColor: const Color(0xFF73AEF5),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
        inAsyncCall: saving,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Column(
            children: [
              Expanded(
                child: _buildLoaded(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoaded() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ticketsWidget(),
      ),
    );
  }

  Widget ticketsWidget() {
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        List<Ticket?> offers = [];
        if (snapshot.hasData) {
          offers = snapshot.data
                  ?.map(
                      (e) => Ticket.fromJson(e.data() as Map<String, dynamic>))
                  .toList() ??
              [];
          cities = (offers.map((e) => e?.city).toSet().toList());
          country = offers.map((e) => e?.country).toSet().toList();

          type = offers.map((e) => e?.type).toSet().toList();

          if (selectedCity != null) {
            offers = offers.where((e) => e?.city == selectedCity).toList();
          }
          if (selectedCountry != null) {
            offers =
                offers.where((e) => e?.country == selectedCountry).toList();
          }

          if (selectedType != null) {
            offers = offers.where((e) => e?.type == selectedType).toList();
          }

          offers.sort((a, b) => (a?.time?.millisecondsSinceEpoch ?? 0)
              .compareTo(b?.time?.millisecondsSinceEpoch ?? 0));

          offers.sort((a, b) => (a?.time?.millisecondsSinceEpoch ?? 0)
              .compareTo(b?.time?.millisecondsSinceEpoch ?? 0));

          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                _header(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: offers.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          // DocumentSnapshot? documentSnapshot = snapshot.data
                          //     ?.firstWhere((data) =>
                          //         (data.data()
                          //             as Map<String, dynamic>)['postid'] ==
                          //         offers[index]?.ticketid);
                          if (currentUser == null) {
                            Widgets.showInSnackBar("Please Signup/Login", key);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => OfferDetail(
                                      ticket: offers[index]!,
                                    )),
                              ),
                            );
                          }
                        },
                        child: OfferItem(
                          ticket: offers[index]!,
                        ),
                      );
                    }),
                  ),
                ),
              ],
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

  Row _header() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  "Type: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedType,
                    isExpanded: true,
                    items: type.map((String? value) {
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
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  "Country: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCountry,
                    isExpanded: true,
                    items: country.map((String? value) {
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
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  "City: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCity,
                    isExpanded: true,
                    items: cities.map((String? value) {
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
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => false;
}
