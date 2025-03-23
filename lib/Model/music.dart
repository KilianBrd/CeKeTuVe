import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Song {
  final String? title;
  final String? artist;
  final String? URL;
  final String? userId;

  Song({
    this.title,
    this.artist,
    this.URL,
    this.userId,
  });

  factory Song.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Song(
      title: data['title'],
      artist: data['artist'],
      URL: data['URL'],
      userId: data['userId'],
    );
  }

  Future<List<Song>> getSongWithString(query) async {
    var titleSnapshot = await FirebaseFirestore.instance
        .collection('musics')
        .where('title', isGreaterThanOrEqualTo: query.toString().toLowerCase())
        .where('title',
            isLessThanOrEqualTo: '${query.toString().toLowerCase()}\uf8ff')
        .get();

    var artistSnapshot = await FirebaseFirestore.instance
        .collection('musics')
        .where('artist', isGreaterThanOrEqualTo: query)
        .where('artist', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    var combinedResults = [...titleSnapshot.docs, ...artistSnapshot.docs];
    var uniqueResults = Set.from(combinedResults).toList();
    return uniqueResults.map((doc) => Song.fromSnapshot(doc)).toList();
  }

  addToFirebase() async {
    await FirebaseFirestore.instance.collection('musics').add(
      {
        'title': title,
        'artist': artist,
        'URL': URL,
        'userId': userId,
      },
    );
  }

  static Stream<List<Song>> getSongsByUserId(String userId) {
    return FirebaseFirestore.instance
        .collection('musics')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Song.fromSnapshot(doc)).toList());
  }

  removeThisSong() async {
    await FirebaseFirestore.instance
        .collection('musics')
        .where('userId', isEqualTo: userId)
        .where('title', isEqualTo: title)
        .where('artist', isEqualTo: artist)
        .where('URL', isEqualTo: URL)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
