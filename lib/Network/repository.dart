import 'dart:async';
import 'dart:io';

import 'package:airview_tech/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ticket.dart';
import 'firebase_provider.dart';

class Repository {
  final _firebaseProvider = FirebaseProvider();

  Future<void> addUserToDb(User user,
          {String? name, String? phonenumber, String? country, String? city}) =>
      _firebaseProvider.addUserToDb(
        user,
        name: name,
        phonenumber: phonenumber,
        country: country,
        city: city,
      );

  Future<String?> signIn(String email, String password) =>
      _firebaseProvider.signIn(email, password);
  Future<User?> registerUser(String email, String password) =>
      _firebaseProvider.registerUser(email, password);

  Future<bool> authenticateUser(User user) =>
      _firebaseProvider.authenticateUser(user);

  User? getCurrentUser() => _firebaseProvider.getCurrentUser();

  Future<void> signOut() => _firebaseProvider.signOut();
  Future<void> forgotPassword(String email) =>
      _firebaseProvider.forgotPassword(email);

  Future<void> addTicketToDb(
    Ticket ticket,
  ) =>
      _firebaseProvider.addTicketToDb(ticket);

  Future<void> deletePost(String postid, String userid) =>
      _firebaseProvider.deleteTicket(postid, userid);

  Future<AppUser> retrieveUserDetails(User user) =>
      _firebaseProvider.retrieveUserDetails(user);

  Future<bool> removeAccount() => _firebaseProvider.removeAccount();

  Future<List<DocumentSnapshot>> retrieveTickets(String type) =>
      _firebaseProvider.retrieveTickets(type);

  Future<List<String>> uploadImagesToStorage(List<File> images, String type) =>
      _firebaseProvider.uploadImagesToStorage(images, type);

  Future<void> updatePhoto(String photoUrl, String uid) =>
      _firebaseProvider.updatePhoto(photoUrl, uid);

  Future<void> updateDetails(String? uid, String? name, String? city,
          String? country, String? phone, String? bio, String? email) =>
      _firebaseProvider.updateDetails(
          uid, name, city, country, phone, bio, email);
}
