import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addMusic(String title, String artist, String url) async {
  try {
    print('dans la vie');
    await FirebaseFirestore.instance.collection('musics').add({
      'title': title,
      'artist': artist,
      'url': url,
    });
    print('Musique ajoutée');
  } catch (e) {
    print('Erreur lors de l\'ajout de la musique: $e');
  }
}
