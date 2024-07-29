// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../providers/color_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  late TextEditingController regionController;
  late TextEditingController passwordController;

  String profileImageUrl = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dobController = TextEditingController(text: '');
    regionController = TextEditingController(text: 'region');

    passwordController = TextEditingController(text: '***********');

    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      setState(() {
        nameController = TextEditingController(text: userDoc['username']);
        emailController = TextEditingController(text: user.email);
        phoneController = TextEditingController(text: userDoc['phoneNumber']);

        isLoading = false;
      });

      DocumentSnapshot pro = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("otherData")
          .doc("profile")
          .get();
      setState(() {
        profileImageUrl = pro["profileImageUrl"] ?? "";
      });
    }
  }

  Future<void> updateUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'username': nameController.text,
        'phone': phoneController.text,
        'dob': dobController.text,
        'region': regionController.text,
      });

      if (emailController.text != user.email) {
        await user.updateEmail(emailController.text);
      }
    }
  }

  Future<void> uploadProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      User? user = _auth.currentUser;
      if (user != null) {
        TaskSnapshot uploadTask = await _storage
            .ref('profile_pictures/${user.uid}')
            .putFile(imageFile);
        String downloadUrl = await uploadTask.ref.getDownloadURL();

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection("otherData")
            .doc("profile")
            .set({
          'profileImageUrl': downloadUrl,
        });

        setState(() {
          profileImageUrl = downloadUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorState = ref.watch(colorProvider);

    return Scaffold(
      backgroundColor: colorState.baseColor,
      body: isLoading
          ? const SafeArea(child: Center(child: CircularProgressIndicator()))
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.chevron_left_rounded,
                              color: colorState.generatedColors[1],
                            ),
                          ),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 18,
                              color: colorState.generatedColors[1],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey,
                              backgroundImage: profileImageUrl.isNotEmpty
                                  ? NetworkImage(profileImageUrl)
                                  : null,
                              child: profileImageUrl.isEmpty
                                  ? const Icon(
                                      Icons.person_2_rounded,
                                      color: Colors.white,
                                      size: 82,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: uploadProfileImage,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: colorState.generatedColors[1],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: nameController,
                        hint: 'Mellisa Peters',
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: emailController,
                        hint: 'melpeters@gmail.com',
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Phone Number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: phoneController,
                        hint: '+233 098 7766',
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: passwordController,
                        hint: '**************',
                        readOnly: true,
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Date of Birth',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: dobController,
                        hint: '23/05/1995',
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Region',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: regionController,
                        hint: 'Greater Accra',
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await updateUserData();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorState
                                .generatedColors[1], // Background color
                            foregroundColor:
                                colorState.generatedColors[0], // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Custom border radius
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 34, vertical: 22), // Custom padding
                          ),
                          child: Text(
                            'Save Changes',
                            style: TextStyle(
                                color: colorState.generatedColors[0],
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
