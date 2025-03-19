import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? email;
  String? pseudo;

  User({this.email, this.pseudo});

  addToFirebase(String userId) async {
    await FirebaseFirestore.instance.collection('Users').doc(userId).set(
      {
        'email': email,
        'pseudo': pseudo,
        'createdAt': DateTime.now(),
      },
    );
  }
}
