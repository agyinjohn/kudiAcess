// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kudiaccess/screens/login.dart';
import 'package:kudiaccess/utils/commons/commons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

final authMethodProvider = Provider((ref) => AuthMethods(ref: ref));

Future<String> uploadImage(File image, String uid) async {
  Reference ref = FirebaseStorage.instance.ref().child('userImages/$uid');
  UploadTask uploadTask = ref.putFile(image);
  TaskSnapshot taskSnapshot = await uploadTask;
  return await taskSnapshot.ref.getDownloadURL();
}

class AuthMethods {
  AuthMethods({required this.ref});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final ProviderRef ref;

  Future<bool> signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    bool res = false;
    try {
      res = false;
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firebaseFirestore
                .collection('users')
                .doc(cred.user!.uid)
                .get();
        if (snapshot.data() != null) {
          UserModel user = UserModel.fromMap(snapshot.data()!);
          debugPrint(user.username);
          ref.read(userProvider.notifier).saveUser(user);

          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("isAuthenticated", true);
        }
      }
      res = true;
    } on FirebaseAuthException catch (e) {
      res = false;
      showSnackBar(context, e.message!);
    } catch (e) {
      res = false;
      showSnackBar(context, e.toString());
      print(e.toString());
    }
    return res;
  }

  Future<bool> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
    // Changed from profileImage to medicalImage
  }) async {
    bool res = false;
    try {
      res = false;
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // String imageUrl = await uploadImage(medicalImage, credential.user!.uid);

      // Fetch data from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? triggersString = prefs.getString('triggers');
      String? colorsString = prefs.getString('colors');
      String? medicalString = prefs.getString('medicalData');

      Map<String, dynamic> triggersMap =
          triggersString != null ? jsonDecode(triggersString) : {};
      Map<String, dynamic> colorsMap =
          colorsString != null ? jsonDecode(colorsString) : {};
      Map<String, dynamic> medicalMap =
          medicalString != null ? jsonDecode(medicalString) : {};

      // Save user data
      UserModel user = UserModel(
        username: username,
        email: email,
        uid: credential.user!.uid,
        phoneNumber: phoneNumber,
        // Changed from profileImageUrl to medicalImageUrl
      );

      await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(user.toMap());

      // Save triggers and colors in separate collections
      await _firebaseFirestore
          .collection('triggers')
          .doc(_auth.currentUser!.uid)
          .set(triggersMap);

      await _firebaseFirestore
          .collection('colors')
          .doc(_auth.currentUser!.uid)
          .set(colorsMap);
      await _firebaseFirestore
          .collection("medicalData")
          .doc(_auth.currentUser!.uid)
          .set(medicalMap);
      res = true;
    } on FirebaseAuthException catch (e) {
      res = false;
      showSnackBar(context, e.message!);
    } catch (e) {
      res = false;
      showSnackBar(context, e.toString());
    }
    return res;
  }

  signOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }
}
