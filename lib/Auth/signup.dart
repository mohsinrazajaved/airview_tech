import 'package:airview_tech/Auth/terms.dart';
import 'package:airview_tech/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Network/repository.dart';
import '../Utilities/widgets.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _saving = false;
  final repository = Repository();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  BuildContext? bcontext;
  var key = GlobalKey<ScaffoldState>();

  authenticateUser(User user) {
    repository.authenticateUser(user).then((value) {
      if (value) {
        repository
            .addUserToDb(
          user,
          name: usernameController.text,
          city: cityController.text,
          country: countryController.text,
          phonenumber: phoneNumberController.text,
        )
            .then((value) async {
          setState(() {
            _saving = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Terms(
              callback: () async {},
            );
          }));
        });
      } else {
        setState(() {
          _saving = false;
        });
        Widgets.showInSnackBar("Authentication Failed", key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                SizedBox(height: constraints.maxHeight * 0.04),
                Text(
                  "Sign Up".tr,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: constraints.maxHeight * 0.05),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTF(hint: "Name".tr, usernameController),
                      buildTF(hint: "Email".tr, emailController),
                      buildTF(hint: "Password".tr, passwordController),
                      buildTF(
                          hint: "Confirm Password".tr,
                          confirmPasswordController),
                      buildTF(hint: "Phone#".tr, phoneNumberController),
                      buildTF(hint: "Country".tr, countryController),
                      buildTF(hint: "City".tr, cityController),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _signup();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF00BF6D),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: Text("Sign Up".tr),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Already have an account? ".tr,
                            children: [
                              TextSpan(
                                text: "Sign in".tr,
                                style: TextStyle(color: Color(0xFF00BF6D)),
                              ),
                            ],
                          ),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.64),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  _signup() {
    if (!AppUser.isEmailValid(emailController.text)) {
      Widgets.showInSnackBar("Enter your email".tr, key);
      return;
    }

    if (!AppUser.isUsernameValid(usernameController.text)) {
      Widgets.showInSnackBar("Enter your username".tr, key);
      return;
    }

    if (!AppUser.isPasswordValid(passwordController.text)) {
      Widgets.showInSnackBar("Enter your password".tr, key);
      return;
    }

    if (!AppUser.isConfirmPassword(
        passwordController.text, confirmPasswordController.text)) {
      Widgets.showInSnackBar("Password not matched".tr, key);
      return;
    }

    if (phoneNumberController.text.isEmpty) {
      Widgets.showInSnackBar("Enter phone number".tr, key);
      return;
    }

    if (countryController.text.isEmpty) {
      Widgets.showInSnackBar("Enter country".tr, key);
      return;
    }

    if (cityController.text.isEmpty) {
      Widgets.showInSnackBar("Enter city".tr, key);
      return;
    }
    setState(() {
      _saving = true;
    });
    repository
        .registerUser(emailController.text, passwordController.text)
        .then((user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        setState(() {
          _saving = false;
        });
        Widgets.showInSnackBar("Authentication Failed".tr, key);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    countryController.dispose();
    cityController.dispose();
  }
}
