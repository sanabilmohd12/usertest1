import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../model/models.dart';


class MainProvider extends ChangeNotifier {

  Reference ref = FirebaseStorage.instance.ref("IMAGEURL");
  FirebaseFirestore db = FirebaseFirestore.instance;



  final List<String> hintTexts = ["Search by Name..", "Search by Phone.."];
  int currentHintIndex = 0;

  String get currentHintText => hintTexts[currentHintIndex];

  MainProvider() {
    _startHintTextRotation();
  }

  void _startHintTextRotation() {
    Future.delayed(const Duration(seconds: 4), () {
      currentHintIndex = (currentHintIndex + 1) % hintTexts.length;
      notifyListeners();
      _startHintTextRotation();
    });
  }

  String userImageUrl = '';
  File? userImageFile;


  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  Future<void> addUser(BuildContext context) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    HashMap<String, dynamic> map = HashMap();
    map["USER_ID"] = id;

    map["NAME"] = nameController.text;
    map["AGE"] = ageController.text;
    map["NUMBER"] = numberController.text;

    try {
      await FirebaseFirestore.instance.collection("USERS").doc(id).set(map);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Successfully Added"),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xda4b4b4b),
            ),
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add user. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    notifyListeners();
  }

  List<User> usersList = [];

  Future<void> fetchUsers() async {
    try {
      final value = await FirebaseFirestore.instance.collection("USERS").get();

      if (value.docs.isNotEmpty) {
        usersList.clear();
        for (var element in value.docs) {
          usersList.add(User.fromFirestore(element));
        }
        filteredUsersList = List.from(usersList);
      }
      notifyListeners();
    } catch (e) {
      print("Error in fetchUsers: $e");
    }
  }


  List<User> filteredUsersList = [];

  Future<void> filterUsers(String query) async {
    if (query.isEmpty) {
      // If the query is empty, show all users
      filteredUsersList = List.from(usersList);
    } else {
      // Filter based on query
      filteredUsersList = usersList
          .where((user) =>
      user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.number.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    print("Filtered users: ${filteredUsersList.length}"); // Debugging
    notifyListeners(); // Notify listeners to update UI
  }



}



