import 'package:airview_tech/Network/repository.dart';
import 'package:airview_tech/Utilities/HelperItems.dart';
import 'package:airview_tech/Utilities/widgets.dart';
import 'package:airview_tech/models/ticket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

enum TicketType { train, bus, plane }

class PublishOffer extends StatefulWidget {
  final bool isRequest;
  const PublishOffer({Key? key, this.isRequest = false}) : super(key: key);

  @override
  PublishOfferState createState() => PublishOfferState();
}

class PublishOfferState extends State<PublishOffer>
    with AutomaticKeepAliveClientMixin {
  bool _saving = false;
  late TextEditingController titleController;
  late TextEditingController depatureController;
  late TextEditingController arrivalController;
  late TextEditingController cityController;
  late TextEditingController countryController;
  late TextEditingController priceController;
  late TextEditingController numberOfTicketsController;
  late TextEditingController descriptionController;

  DateTime? goDate;
  DateTime? returnDate;
  final key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _repository = Repository();
  String godateString = "Go Date".tr;
  String returndateString = "Return Date".tr;
  String selectedTicktType = "bus";
  List<String> types = ["bus", "train", "plane"];
  User? user;

  final df = DateFormat('dd-MM-yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    depatureController = TextEditingController();
    arrivalController = TextEditingController();
    cityController = TextEditingController();
    countryController = TextEditingController();
    priceController = TextEditingController();
    numberOfTicketsController = TextEditingController();
    descriptionController = TextEditingController();
    user = _repository.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _saving,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Text(
                      "Create Ticket".tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildTF(hint: "Title".tr, titleController),
                          buildTF(hint: "Departure".tr, depatureController),
                          buildTF(hint: "Arrival".tr, arrivalController),
                          buildTF(hint: "City".tr, cityController),
                          buildTF(hint: "Country".tr, countryController),
                          buildTF(hint: "Price".tr, priceController),
                          buildTF(
                              hint: "No of Tickets", numberOfTicketsController),
                          buildDatePicker(godateString, () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                              helpText: "Select Date".tr,
                            );

                            if (picked != null) {
                              setState(() {
                                goDate = picked;
                                godateString =
                                    HelperItems.dateToStringWithFormat(
                                        "MM/dd/yyyy", picked);
                              });
                            }
                          }),
                          const SizedBox(height: 10),
                          buildDatePicker(returndateString, () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                              helpText: "Select Date",
                            );

                            if (picked != null) {
                              setState(() {
                                returnDate = picked;
                                returndateString =
                                    HelperItems.dateToStringWithFormat(
                                        "MM/dd/yyyy", picked);
                              });
                            }
                          }),
                          const SizedBox(height: 10),
                          buidDropDownField(selectedTicktType, types, (value) {
                            selectedTicktType = value as String;
                            setState(() {});
                          }, hint: "Type".tr),
                          const SizedBox(height: 10),
                          buildDescriptionTF(
                              "Description".tr, descriptionController),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  saveOffer();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xFF00BF6D),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 48),
                                shape: const StadiumBorder(),
                              ),
                              child: Text("Save".tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  saveOffer() async {
    setState(() {
      _saving = true;
    });

    if (goDate == null) {
      Widgets.showInSnackBar("Please select go date".tr, key);
      setState(() {
        _saving = false;
      });
      return;
    }

    if (returnDate == null) {
      Widgets.showInSnackBar("Please select return date".tr, key);
      setState(() {
        _saving = false;
      });
      return;
    }

    User? currentUser = _repository.getCurrentUser();
    if (currentUser != null) {
      _repository.retrieveUserDetails(currentUser).then((user) {
        Ticket ticket = Ticket(
          currentUserUid: currentUser.uid,
          type: selectedTicktType,
          title: titleController.text,
          city: cityController.text,
          country: countryController.text,
          arrival: arrivalController.text,
          departure: depatureController.text,
          goDate: godateString,
          returnDate: returndateString,
          dateTime: df.format(DateTime.now()),
          description: descriptionController.text,
          price: priceController.text,
          time: DateTime.now(),
          sellerEmail: user.email ?? "",
          ownerName: user.displayName ?? "",
          ownerPhotoUrl: user.photoUrl ?? "",
          noOfTickets: int.tryParse(numberOfTicketsController.text) ?? 0,
        );
        _repository.addTicketToDb(ticket).then((value) {
          setState(() {
            _saving = false;
            clearControllers();
          });
        }).catchError((e) {
          setState(() {
            _saving = false;
          });
        });
      });
    } else {
      setState(() {
        _saving = false;
      });
      Widgets.showInSnackBar("Current User is null", key);
    }
  }

  clearControllers() {
    goDate = null;
    returnDate = null;
    godateString = "Select";
    returndateString = "Select";
    titleController.clear();
    depatureController.clear();
    arrivalController.clear();
    cityController.clear();
    countryController.clear();
    priceController.clear();
    numberOfTicketsController.clear();
    descriptionController.clear();
  }

  disposeControllers() {
    goDate = null;
    returnDate = null;
    titleController.dispose();
    depatureController.dispose();
    arrivalController.dispose();
    cityController.dispose();
    countryController.dispose();
    priceController.dispose();
    numberOfTicketsController.dispose();
    descriptionController.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    disposeControllers();
  }

  @override
  bool get wantKeepAlive => true;
}
