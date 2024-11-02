import 'package:airview_tech/Network/repository.dart';
import 'package:airview_tech/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  final String? photoUrl, email, bio, name, city, country, phone;
  final AppUser? user;

  const EditProfileScreen(this.user,
      {super.key,
      this.photoUrl,
      this.email,
      this.bio,
      this.name,
      this.city,
      this.country,
      this.phone});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final repository = Repository();
  User? currentUser;
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();

  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name ?? "";
    _emailController.text = widget.email ?? "";
    _cityController.text = widget.city ?? "";
    _countryController.text = widget.country ?? "";
    _phoneController.text = widget.phone ?? "";
    currentUser = repository.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const ProfileHeader(),
              Form(
                child: Column(
                  children: [
                    UserInfoEditField(
                      text: "Name".tr,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5, vertical: 16.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                    UserInfoEditField(
                      text: "City".tr,
                      child: TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5, vertical: 16.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                    UserInfoEditField(
                      text: "Country".tr,
                      child: TextFormField(
                        controller: _countryController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5, vertical: 16.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                    UserInfoEditField(
                      text: "Phone".tr,
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5, vertical: 16.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "Private Information".tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: TextField(
                  controller: _emailController,
                  onChanged: null,
                  decoration: InputDecoration(
                    hintText: "Email address".tr,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.08),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: const StadiumBorder(),
                      ),
                      child: Text("Cancel".tr),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BF6D),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        setState(() {
                          _saving = true;
                        });

                        repository
                            .updateDetails(
                          currentUser?.uid,
                          _nameController.text,
                          _cityController.text,
                          _countryController.text,
                          _phoneController.text,
                          _bioController.text,
                          _emailController.text,
                        )
                            .then((v) {
                          setState(() {
                            _saving = false;
                          });
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Save Update".tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Text(
          "My Profile".tr,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
      ],
    );
  }
}

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(text),
          ),
          Expanded(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}
