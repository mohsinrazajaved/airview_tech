import 'package:airview_tech/Network/repository.dart';
import 'package:airview_tech/models/app_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utilities/widgets.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  _ForgetState createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  bool _saving = false;
  final repository = Repository();
  TextEditingController emailController = TextEditingController();
  final key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.1),
                Text(
                  "Forgot Password".tr,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Please enter your email for resting the password".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.64),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: buildTF(
                    emailController,
                    hint: "Password".tr,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _reset();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF00BF6D),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                  ),
                  child: Text("Reset".tr),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  _reset() {
    if (!AppUser.isEmailValid(emailController.text)) {
      Widgets.showInSnackBar("Enter your email".tr, key);
      return;
    }
    setState(() {
      _saving = true;
    });
    repository.forgotPassword(emailController.text).then((user) {
      setState(() {
        _saving = false;
      });
      Widgets.showInSnackBar("Password verification email is send".tr, key,
          color: Colors.green);
      emailController.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }
}
