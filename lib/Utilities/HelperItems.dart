import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class HelperItems {
  static double percentageCalculate(double percent) {
    if (percent == 0) {
      return 0;
    }
    double actualPercentage;
    actualPercentage = percent / 100;

    return actualPercentage;
  }

  static String selectedLang = 'English';

  static double costCalculate(double actualCost, double budgetCost) {
    double costPercentage;
    costPercentage = ((actualCost / budgetCost) * 100);
    return costPercentage;
  }

  static int _numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  static int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(date.year - 1);
    } else if (woy > _numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  static String newFormatDate(String dateString, String newFormat) {
    if (dateString == "") {
      return "-";
    }
    var now = DateFormat("yyyy-MM-ddThh:mm:ss").parse(dateString);
    var formatter = DateFormat(newFormat);
    String formatted = formatter.format(now);

    return formatted;
  }

  static String formatDate(String dateString, String newFormat) {
    var now = DateFormat("yyyy/MM/dd").parse(dateString);
    var formatter = DateFormat(newFormat);
    String formatted = formatter.format(now);

    return formatted;
  }

  static String dashformatDate(String dateString, String newFormat) {
    if (dateString == "") {
      return "";
    }
    var now = DateFormat("yyyy-MM-dd").parse(dateString);
    var formatter = DateFormat(newFormat);
    String formatted = formatter.format(now);
    return formatted;
  }

  static String woFormatDate(String dateString, String newFormat) {
    var now = DateFormat("MM/dd/yyyy hh:mm:ss a").parse(dateString);
    var formatter = DateFormat(newFormat);
    String formatted = formatter.format(now);

    return formatted;
  }

  static String genericFormatDate(
      String currentFormat, String dateString, String newFormat) {
    if (dateString == "") {
      return "-";
    }
    var now = DateFormat(currentFormat).parse(dateString);
    var formatter = DateFormat(newFormat);
    String formatted = formatter.format(now);
    return formatted;
  }

  static String getResourceName(String name) {
    var list = name.split("|");
    if (list.length > 1) {
      var np = list[1].split(" ").where((e) => e != "").toList();
      return np.first[0] + np.last[0];
    }
    return "-";
  }

  static DateTime? convertStringToDate(
      String currentFormat, String dateString) {
    try {
      var now = DateFormat(currentFormat).parse(dateString);
      return now;
    } on FormatException {
      return DateTime.now();
    }
  }

  static String dateToStringConversion(DateTime newFormat) {
    var now = newFormat;
    var formatter = DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(now);

    return formatted;
  }

  static String dateToStringWithFormat(String format, DateTime newFormat) {
    var now = newFormat;
    var formatter = DateFormat(format);
    String formatted = formatter.format(now);

    return formatted;
  }

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  static int getColorHexEmptyFromStr(String colorStr) {
    if (colorStr == "") {
      colorStr = "#0000ffff";
    } else if (colorStr == "#000") {
      colorStr = "#000000";
    }
    colorStr = "FF$colorStr";
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw const FormatException(
            "An error occurred when converting a color");
      }
    }
    return val;
  }

  static int getColorHexFromStr(String colorStr) {
    if (colorStr == "") {
      colorStr = "#D3D3D3";
    } else if (colorStr == "#000") {
      colorStr = "#000000";
    }
    colorStr = "FF$colorStr";
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw const FormatException(
            "An error occurred when converting a color");
      }
    }
    return val;
  }
}
