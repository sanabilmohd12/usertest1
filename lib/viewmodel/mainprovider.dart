import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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

 void cleartextfield (){
    nameController.clear();
    ageController.clear();
    numberController.clear();
 }


  List<User> usersList = [];
  List<User> filteredUsersList = [];
  DocumentSnapshot? lastDocument;

  bool isFetching = false;

  Future<void> fetchUsers() async {
    if (isFetching) return;
    isFetching = true;
    try {
      QuerySnapshot querySnapshot;
      if (lastDocument == null) {
        querySnapshot = await FirebaseFirestore.instance.collection("USERS").limit(10).get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection("USERS")
            .startAfterDocument(lastDocument!)
            .limit(10)
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        for (var element in querySnapshot.docs) {
          usersList.add(User.fromFirestore(element));
        }
        lastDocument = querySnapshot.docs.last;
        filteredUsersList = List.from(usersList);
      }
      notifyListeners();
    } catch (e) {
      print("Error in fetchUsers: $e");
    } finally {
      isFetching = false; // Allow fetching again
    }
  }

  Future<void> filterUsers(String query) async {
    if (query.isEmpty) {
      filteredUsersList = List.from(usersList);
    } else {
      filteredUsersList = usersList
          .where((user) =>
      user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.number.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    print("Filtered users: ${filteredUsersList.length}");
    notifyListeners();
  }


  void sortUsersByAge(int? selectedOption) {
    switch (selectedOption) {
      case 1: // Younger (below 60)
        filteredUsersList = usersList.where((user) => int.parse(user.age) < 60).toList();
        break;
      case 2: // Older (60 and above)
        filteredUsersList = usersList.where((user) => int.parse(user.age) >= 60).toList();
        break;
      default: // All
        filteredUsersList = List.from(usersList);
        break;
    }
    print("Filtered users after sorting: ${filteredUsersList.length}");
    notifyListeners();
  }


}


