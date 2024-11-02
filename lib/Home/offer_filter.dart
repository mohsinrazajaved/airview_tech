import 'package:airview_tech/Utilities/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/ticket.dart';

class FilterScreen extends StatefulWidget {
  final List<String> countries;
  final List<String> cities;
  final List<String> types;
  final Function(
    String? selectedCountry,
    String? selectedCity,
    String? selectedType,
    DateTime? selectedDate,
  ) callback;

  const FilterScreen({
    super.key,
    required this.countries,
    required this.cities,
    required this.types,
    required this.callback,
  });

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedCountry;
  String? selectedCity;
  String? selectedType;
  DateTime? selectedDate;
  String dateString = 'Select Date';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Filters".tr,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            buidDropDownField(selectedCountry, widget.countries, (value) {
              selectedCountry = value as String;
              setState(() {});
            }, hint: "Country".tr),
            const SizedBox(height: 16),
            buidDropDownField(selectedCity, widget.cities, (value) {
              selectedCity = value as String;
              setState(() {});
            }, hint: "City".tr),
            const SizedBox(height: 16),
            buidDropDownField(selectedType, widget.types, (value) {
              selectedType = value as String;
              setState(() {});
            }, hint: "Type".tr),
            const SizedBox(height: 16),
            buildDatePicker(dateString, () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                  dateString = selectedDate == null
                      ? 'Select Date'
                      : DateFormat('yyyy-MM-dd').format(selectedDate!);
                });
              }
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _applyFilters();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF00BF6D),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: const StadiumBorder(),
              ),
              child: Text("Apply".tr),
            ),
          ],
        ),
      ),
    );
  }

  _applyFilters() {
    widget.callback(
      selectedCountry,
      selectedCity,
      selectedType,
      selectedDate,
    );
    Navigator.pop(context);
  }
}
