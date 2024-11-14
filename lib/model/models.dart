import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String age;
  String number;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.number,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc.get("NAME").toString(),
      age: doc.get("AGE").toString(),
      number: doc.get("NUMBER").toString(),
    );
  }
}
