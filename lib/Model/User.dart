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

  Future<String?> getPseudoById(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (!userDoc.exists) {
      print("Erreur: L'utilisateur avec l'ID $userId n'existe pas.");
      return null; // ou une valeur par défaut comme "Inconnu"
    }

    return userDoc.get('pseudo');
  }
}
