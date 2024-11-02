import 'package:airview_tech/Auth/forget.dart';
import 'package:airview_tech/Auth/signup.dart';
import 'package:airview_tech/Home/home/home.dart';
import 'package:airview_tech/Network/repository.dart';
import 'package:airview_tech/Utilities/widgets.dart';
import 'package:airview_tech/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false;
  User? user;

  final repository = Repository();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _saving,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.1),
                    Text(
                      "Sign In".tr,
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
                          buildTF(
                            emailController,
                            hint: "Email".tr,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          buildTF(
                            passwordController,
                            hint: "Password".tr,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                _login();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFF00BF6D),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: const StadiumBorder(),
                            ),
                            child: Text("Sign in".tr),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool("isLoggedIn", true);
                              if (mounted) {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const Home();
                                }));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFF00BF6D),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: const StadiumBorder(),
                            ),
                            child: Text("Skip".tr),
                          ),
                          const SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Forget()));
                            },
                            child: Text(
                              "Forgot Password?".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.64),
                                  ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Signup()));
                            },
                            child: Text.rich(
                              TextSpan(
                                text: "Don’t have an account? ".tr,
                                children: [
                                  TextSpan(
                                    text: "Sign Up".tr,
                                    style: TextStyle(color: Color(0xFF00BF6D)),
                                  ),
                                ],
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
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
            },
          ),
        ),
      ),
    );
  }

  _login() {
    if (!AppUser.isEmailValid(emailController.text)) {
      Widgets.showInSnackBar("Enter your email".tr, _scaffoldKey);
      return;
    }

    if (!AppUser.isPasswordValid(passwordController.text)) {
      Widgets.showInSnackBar("Enter your password".tr, _scaffoldKey);
      return;
    }

    setState(() {
      _saving = true;
    });

    repository
        .signIn(emailController.text, passwordController.text)
        .then((value) async {
      if (value == null) {
        setState(() {
          _saving = false;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);

        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
          }));
        }
      } else {
        setState(() {
          _saving = false;
        });
        Widgets.showInSnackBar(value, _scaffoldKey);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
