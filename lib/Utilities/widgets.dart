import 'package:airview_tech/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Widgets {
  static void showInSnackBar(String value, GlobalKey<ScaffoldState> key,
      {MaterialColor? color}) {
    ScaffoldMessenger.of(key.currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: color ?? Colors.red,
        content: Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

Widget buildTF(String text, TextEditingController controller,
    {String hint = "Enter "}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10.0),
      Text(
        text,
        style: kLabelStyle,
      ),
      const SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 50.0,
        child: TextField(
          controller: controller,
          obscureText: false,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          maxLines: 10,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(14),
            hintText: hint + text,
            hintStyle: kHintTextStyle,
          ),
        ),
      ),
      const SizedBox(height: 10.0),
    ],
  );
}

Widget buildDescriptionTF(String text, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        text,
        style: kLabelStyle,
      ),
      const SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 130.0,
        child: TextField(
          controller: controller,
          obscureText: false,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          maxLines: 10,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(14),
            hintText: "Description here!",
            hintStyle: kHintTextStyle,
          ),
        ),
      ),
      const SizedBox(height: 20.0),
    ],
  );
}

Widget buildDatePicker(String label, String text, Function()? ontap) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: kLabelStyle,
      ),
      const SizedBox(height: 15.0),
      GestureDetector(
        onTap: ontap,
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
      ),
    ],
  );
}

//Helper methods

selectImageFromCamera(Function(PickedFile pickedFile) callback) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  callback(PickedFile(pickedFile?.path ?? ""));
}

selectImageFromGallery(Function(PickedFile pickedFile) callback) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  callback(PickedFile(pickedFile?.path ?? ""));
}
