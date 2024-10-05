import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/ticket.dart';

class FilterScreen extends StatefulWidget {
  final List<String?> countries;
  final List<String?> cities;
  final List<String?> types;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filters",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        elevation: 1,
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF73AEF5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedCountry,
              decoration: InputDecoration(
                labelText: 'Country',
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: widget.countries.map((String? country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country ?? ""),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCountry = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCity,
              decoration: InputDecoration(
                labelText: 'City',
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: widget.cities.map((String? city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city ?? ""),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCity = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: InputDecoration(
                labelText: 'Type',
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: widget.types.map((String? type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type ?? ""),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedType = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF73AEF5)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(selectedDate == null
                    ? 'Select Date'
                    : DateFormat('yyyy-MM-dd').format(selectedDate!)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _applyFilters();
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF73AEF5)),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
