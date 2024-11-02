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

Widget buildTF(TextEditingController controller,
    {String hint = "Enter ", TextInputType? keyboardType}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF5FCF9),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0 * 1.5, vertical: 16.0),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        validator: (value) {
          if (value == null || value == "") {
            return "Enter $hint";
          }
          return null;
        },
        keyboardType: keyboardType,
        controller: controller,
      ),
      const SizedBox(height: 10.0),
    ],
  );
  // return Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     const SizedBox(height: 10.0),
  //     Text(
  //       text,
  //       style: kLabelStyle,
  //     ),
  //     const SizedBox(height: 10.0),
  //     Container(
  //       alignment: Alignment.centerLeft,
  //       decoration: kBoxDecorationStyle,
  //       height: 50.0,
  //       child: TextField(
  //         controller: controller,
  //         obscureText: false,
  //         keyboardType: TextInputType.multiline,
  //         textInputAction: TextInputAction.done,
  //         maxLines: 10,
  //         style: const TextStyle(
  //           color: Colors.white,
  //           fontFamily: 'OpenSans',
  //         ),
  //         decoration: InputDecoration(
  //           border: InputBorder.none,
  //           contentPadding: const EdgeInsets.all(14),
  //           hintText: hint + text,
  //           hintStyle: kHintTextStyle,
  //         ),
  //       ),
  //     ),
  //     const SizedBox(height: 10.0),
  //   ],
  // );
}

Widget buidDropDownField(
    String? selectedType, List<String> list, void Function(String?) onChanged,
    {String hint = "Enter "}) {
  return DropdownButtonFormField(
    value: selectedType,
    items: list.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ));
    }).toList(),
    icon: const Icon(Icons.expand_more),
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5FCF9),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0 * 1.5, vertical: 16.0),
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    ),
  );
}

Widget buildDescriptionTF(String text, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        height: 130.0,
        child: TextField(
          controller: controller,
          obscureText: false,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          maxLines: 10,
          decoration: InputDecoration(
            filled: true,
            hintText: text,
            fillColor: const Color(0xFFF5FCF9),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0 * 1.5, vertical: 16.0),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ),
      const SizedBox(height: 20.0),
    ],
  );
}

Widget buildDatePicker(String text, Function()? ontap) {
  return GestureDetector(
    onTap: ontap,
    child: Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCF9),
        borderRadius: BorderRadius.circular(50),
      ),
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0 * 1.5, vertical: 16.0),
      height: 50.0,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
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
