import 'package:airview_tech/Network/repository.dart';
import 'package:airview_tech/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
    _bioController.text = widget.bio ?? "";
    _emailController.text = widget.email ?? "";
    _cityController.text = widget.city ?? "";
    _countryController.text = widget.country ?? "";
    _phoneController.text = widget.phone ?? "";
    currentUser = repository.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        elevation: 1,
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF73AEF5),
        leading: GestureDetector(
          child: const Icon(Icons.close, color: Colors.white),
          onTap: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(Icons.done, color: Colors.white),
            ),
            onTap: () {
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
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: ListView(
            children: <Widget>[
              const Column(
                children: <Widget>[],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Name",
                        labelText: "Name",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        hintText: "City",
                        labelText: "City",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: _countryController,
                      decoration: const InputDecoration(
                        hintText: "Country",
                        labelText: "Country",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Phone#',
                        labelText: 'Phone#',
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 15.0, vertical: 8.0),
                  //   child: TextField(
                  //     controller: _bioController,
                  //     maxLines: 3,
                  //     decoration: const InputDecoration(
                  //       hintText: 'Bio',
                  //       labelText: 'Bio',
                  //     ),
                  //   ),
                  // ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Private Information",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: TextField(
                      controller: _emailController,
                      onChanged: null,
                      decoration: const InputDecoration(
                        hintText: "Email address",
                        labelText: "Email address",
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
