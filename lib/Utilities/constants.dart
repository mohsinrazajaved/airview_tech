import 'package:flutter/material.dart';

const kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

const kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(const EdgeInsets.all(15.0)),
  elevation: MaterialStateProperty.all(5.0),
  foregroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) =>
        states.contains(MaterialState.disabled) ? Colors.white : Colors.white,
  ),
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) =>
        states.contains(MaterialState.disabled) ? Colors.white : Colors.white,
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  ),
);

final skipkButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
  elevation: MaterialStateProperty.all(0),
  foregroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) =>
        states.contains(MaterialState.disabled) ? Colors.white : Colors.white,
  ),
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) =>
        states.contains(MaterialState.disabled) ? Colors.white : Colors.white,
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  ),
);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
