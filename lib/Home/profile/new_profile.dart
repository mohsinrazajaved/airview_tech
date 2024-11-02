import 'package:airview_tech/Auth/login.dart';
import 'package:airview_tech/Home/my_offers.dart';
import 'package:airview_tech/Home/profile/profile_edit.dart';
import 'package:airview_tech/Network/repository.dart';
import 'package:airview_tech/Utilities/HelperItems.dart';
import 'package:airview_tech/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utilities/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  final repository = Repository();
  AppUser? _user;
  String? icon;
  Color? color;
  bool saving = false;
  String id = "";
  List<String> languages = ['English', 'French'];
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = HelperItems.selectedLang;
    retrieveUserDetails();
  }

  retrieveUserDetails() async {
    User? currentUser = repository.getCurrentUser();
    if (currentUser != null) {
      AppUser? user = await repository.retrieveUserDetails(currentUser);
      setState(() {
        _user = user;
      });
      id = currentUser.uid;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const ProfilePic(),
              const SizedBox(height: 20),
              ProfileMenu(
                text: "My Account".tr,
                icon: const Icon(Icons.account_balance),
                press: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => EditProfileScreen(
                            _user,
                            photoUrl: _user?.photoUrl,
                            email: _user?.email,
                            name: _user?.displayName,
                            city: _user?.city,
                            country: _user?.country,
                            phone: _user?.phone,
                          )),
                    ),
                  );
                },
              ),
              ProfileMenu(
                text: "My Tickets".tr,
                icon: const Icon(Icons.card_membership),
                press: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const MyOfferView()),
                    ),
                  )
                },
              ),
              ProfileMenu(
                text: "Contact Us".tr,
                icon: const Icon(Icons.contact_mail),
                press: () async {
                  final Email email = Email(
                    body: "Hi",
                    subject: "Contact",
                    recipients: ["contact.buymyticket@gmail.com"],
                    isHTML: false,
                  );

                  try {
                    await FlutterEmailSender.send(email);
                  } catch (error) {
                    print('Error sending email: $error');
                  }
                },
              ),
              ProfileMenu(
                text: "Request to Remove Account".tr,
                icon: const Icon(Icons.delete),
                press: () {
                  repository.removeAccount();
                  repository.signOut().then((v) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool("isLoggedIn", false);
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const Login();
                        }),
                      );
                    }
                  });
                },
              ),
              ProfileMenu(
                text: "Log Out".tr,
                icon: const Icon(Icons.logout),
                press: () {
                  repository.signOut().then((v) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool("isLoggedIn", false);

                    if (mounted) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const Login();
                      }));
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: buidDropDownField(selectedLanguage, languages, (value) {
                  selectedLanguage = value as String;

                  if (value == 'English') {
                    setState(() {
                      selectedLanguage = 'English';
                      Get.updateLocale(const Locale('en', ''));
                    });
                  } else if (value == 'French') {
                    setState(() {
                      selectedLanguage = 'French';
                      Get.updateLocale(const Locale('fr', ''));
                    });
                  }

                  HelperItems.selectedLang = selectedLanguage ?? "";
                }, hint: "Type".tr),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Row(
//     children: [
//       const Text(
//         "Language: ",
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//       ),
//       Expanded(
//         child: DropdownButton<String>(
//           value: selectedLanguage,
//           isExpanded: true,
//           items: languages.map((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(
//                 value,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w400, fontSize: 15),
//               ),
//             );
//           }).toList(),
//           onChanged: (newValue) {
//             setState(() {
//               // if (newValue == 'English') {
//               //   this.setState(() {
//               //     selectedLanguage = 'English';
//               //     //icon = "us.png";
//               //     context.locale = Locale('en', 'US');
//               //   });
//               // } else if (newValue == 'French') {
//               //   this.setState(() {
//               //     selectedLanguage = 'French';
//               //     //icon = "fr.png";
//               //     context.locale = Locale('fr', 'CA');
//               //   });
//               // }
//             });
//           },
//         ),
//       ),
//     ],
//   ),
// ),

class ProfilePic extends StatelessWidget {
  const ProfilePic({
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
      ],
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.icon,
    required this.text,
    this.press,
  }) : super(key: key);

  final String text;
  final Icon icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF00BF6D),
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5FCF9),
        ),
        onPressed: press,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const cameraIcon =
    '''<svg width="20" height="16" viewBox="0 0 20 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M10 12.0152C8.49151 12.0152 7.26415 10.8137 7.26415 9.33902C7.26415 7.86342 8.49151 6.6619 10 6.6619C11.5085 6.6619 12.7358 7.86342 12.7358 9.33902C12.7358 10.8137 11.5085 12.0152 10 12.0152ZM10 5.55543C7.86698 5.55543 6.13208 7.25251 6.13208 9.33902C6.13208 11.4246 7.86698 13.1217 10 13.1217C12.133 13.1217 13.8679 11.4246 13.8679 9.33902C13.8679 7.25251 12.133 5.55543 10 5.55543ZM18.8679 13.3967C18.8679 14.2226 18.1811 14.8935 17.3368 14.8935H2.66321C1.81887 14.8935 1.13208 14.2226 1.13208 13.3967V5.42346C1.13208 4.59845 1.81887 3.92664 2.66321 3.92664H4.75C5.42453 3.92664 6.03396 3.50952 6.26604 2.88753L6.81321 1.41746C6.88113 1.23198 7.06415 1.10739 7.26604 1.10739H12.734C12.9358 1.10739 13.1189 1.23198 13.1877 1.41839L13.734 2.88845C13.966 3.50952 14.5755 3.92664 15.25 3.92664H17.3368C18.1811 3.92664 18.8679 4.59845 18.8679 5.42346V13.3967ZM17.3368 2.82016H15.25C15.0491 2.82016 14.867 2.69466 14.7972 2.50917L14.2519 1.04003C14.0217 0.418041 13.4113 0 12.734 0H7.26604C6.58868 0 5.9783 0.418041 5.74906 1.0391L5.20283 2.50825C5.13302 2.69466 4.95094 2.82016 4.75 2.82016H2.66321C1.19434 2.82016 0 3.98846 0 5.42346V13.3967C0 14.8326 1.19434 16 2.66321 16H17.3368C18.8057 16 20 14.8326 20 13.3967V5.42346C20 3.98846 18.8057 2.82016 17.3368 2.82016Z" fill="#757575"/>
</svg>
''';
