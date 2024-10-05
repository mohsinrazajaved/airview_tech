import 'dart:io';

import 'package:airview_tech/models/app_user.dart';
import 'package:airview_tech/models/ticket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  late AppUser user;
  Ticket? ticket;

  Future<void> addUserToDb(User currentUser,
      {String? name,
      String? phonenumber,
      String? country,
      String? city}) async {
    user = AppUser(
      uid: currentUser.uid,
      email: currentUser.email,
      displayName: currentUser.displayName ?? name,
      photoUrl: currentUser.photoURL ?? "",
      phone: phonenumber,
      country: country,
      city: city,
    );

    return _firestore
        .collection("users")
        .doc(currentUser.uid)
        .set(user.toMap(user));
  }

  Future<bool> authenticateUser(User user) async {
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    if (docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  User? getCurrentUser() {
    User? currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<String?> signIn(String email, String password) async {
    //User? user;
    try {
      //user = userCredential.user;
      final response = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return response.user != null ? null : "";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          return "Email already used. Go to login page.";
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          return "Wrong email/password combination.";
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          return "No user found with this email.";
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          return "User disabled.";
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          return "Too many requests to log into this account.";
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          return "Email address is invalid.";
        default:
          return "Login failed. Please try again.";
      }
    }
  }

  Future<User?> registerUser(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<List<String>> uploadImagesToStorage(
      List<File> images, String type) async {
    var imageUrls =
        await Future.wait(images.map((image) => _uploadFile(image, type)));
    return imageUrls;
  }

  Future<String> _uploadFile(File image, String type) async {
    var storageReference =
        FirebaseStorage.instance.ref().child('$type/${image.path}');
    UploadTask storageUploadTask = storageReference.putFile(image);
    return await (await storageUploadTask).ref.getDownloadURL();
  }

  Future<void> addTicketToDb(
    Ticket ticket,
  ) {
    DocumentReference collectionRef = _firestore.collection("tickets").doc();
    ticket.ticketid = collectionRef.id;
    return collectionRef.set(ticket.toJson(ticket));
  }

  Future<AppUser> retrieveUserDetails(User user) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection("users").doc(user.uid).get();
    return AppUser.fromMap(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<bool> removeAccount() async {
    final user = _auth.currentUser;
    user?.delete();
    return Future.value(true);
  }

  Future<List<DocumentSnapshot>> retrieveTickets(String userId) async {
    QuerySnapshot? querySnapshot = await _firestore.collection("tickets").get();
    return querySnapshot.docs.where((e) => e["ownerUid"] == userId).toList();
  }

  Future<void> deleteTicket(String postid, String userid) async {
    DocumentReference queryReference =
        _firestore.collection("tickets").doc(postid);
    queryReference.delete();
  }

  Future<void> updatePhoto(String photoUrl, String uid) async {
    Map<String, dynamic> map = {};
    map['photoUrl'] = photoUrl;
    return _firestore.collection("users").doc(uid).update(map);
  }

  Future<void> updateDetails(String? uid, String? name, String? city,
      String? country, String? phone, String? bio, String? email) async {
    Map<String, dynamic> map = {};
    map['displayName'] = name;
    map['city'] = city;
    map['country'] = country;
    map['phone'] = phone;
    map['email'] = email;
    return _firestore.collection("users").doc(uid).update(map);
  }
}
