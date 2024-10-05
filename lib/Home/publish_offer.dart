import 'package:airview_tech/Network/repository.dart';
import 'package:airview_tech/Utilities/HelperItems.dart';
import 'package:airview_tech/Utilities/constants.dart';
import 'package:airview_tech/Utilities/widgets.dart';
import 'package:airview_tech/models/ticket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final _repository = Repository();
  String godateString = "Select";
  String returndateString = "Select";
  String selectedTicktType = "bus";
  List<String> types = ["bus", "train", "plane"];
  User? user;

  final df = DateFormat('dd-MM-yyyy HH:mm');
  final ScrollController _scrollController = ScrollController();

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
    return SafeArea(
      child: Scaffold(
          key: key,
          backgroundColor: const Color(0xFF73AEF5),
          appBar: AppBar(
            title: const Text('TICKET TO GO'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: const Color(0xFF73AEF5),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                      clearControllers();
                    },
                    child: const Text("Clear"),
                  )),
            ],
          ),
          body: ModalProgressHUD(
            inAsyncCall: _saving,
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: _buildLoaded(context),
                ),
              ),
            ),
          )),
    );
  }

  saveOffer() async {
    setState(() {
      _saving = true;
    });

    if (titleController.text.isEmpty) {
      Widgets.showInSnackBar("Please enter title", key);
      setState(() {
        _saving = false;
      });
      return;
    }

    if (cityController.text.isEmpty) {
      Widgets.showInSnackBar("Please enter departure", key);
      setState(() {
        _saving = false;
      });
      return;
    }

    if (cityController.text.isEmpty) {
      Widgets.showInSnackBar("Please enter arrival", key);
      setState(() {
        _saving = false;
      });
      return;
    }

    if (goDate == null) {
      Widgets.showInSnackBar("Please select go date", key);
      setState(() {
        _saving = false;
      });
      return;
    }

    if (goDate == null) {
      Widgets.showInSnackBar("Please select return date", key);
      setState(() {
        _saving = false;
      });
      return;
    }

    if (cityController.text.isEmpty) {
      Widgets.showInSnackBar("Please enter city", key);
      setState(() {
        _saving = false;
      });
      return;
    }

    if (countryController.text.isEmpty) {
      Widgets.showInSnackBar("Please enter country", key);
      setState(() {
        _saving = false;
      });
      return;
    }

    if (priceController.text.isEmpty) {
      Widgets.showInSnackBar("Please enter price", key);
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

  Widget _buildLoaded(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTF("Title", titleController),
          buildTF("Departure", depatureController),
          buildTF("Arrival", arrivalController),
          buildTF("City", cityController),
          buildTF("Country", countryController),
          buildTF("Price", priceController),
          buildTF("No of Tickets", numberOfTicketsController),
          buildDatePicker("Go Date", godateString, () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              helpText: "Select Date",
            );

            if (picked != null) {
              goDate = picked;
              godateString =
                  HelperItems.dateToStringWithFormat("MM/dd/yyyy", picked);
            }
          }),
          const SizedBox(height: 8),
          buildDatePicker("Return Date", returndateString, () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              helpText: "Select Date",
            );

            if (picked != null) {
              returnDate = picked;
              returndateString =
                  HelperItems.dateToStringWithFormat("MM/dd/yyyy", picked);
            }
          }),
          const SizedBox(height: 8),
          _typeDropDown(),
          const SizedBox(height: 8),
          buildDescriptionTF("Description", descriptionController),
          const SizedBox(height: 8),
          GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 0, right: 0),
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: Colors.grey)),
                  child: const Center(
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              onTap: () async {
                saveOffer();
              }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  DropdownButtonFormField<String> _typeDropDown() {
    return DropdownButtonFormField(
      value: selectedTicktType,
      items: types
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ))
          .toList(),
      onChanged: (val) {
        selectedTicktType = val as String;
        setState(() {});
      },
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(14),
        hintText: "Description here!",
        hintStyle: kHintTextStyle,
      ),
    );
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
