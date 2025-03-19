import 'package:cequejeveux/Model/music.dart';
import 'package:cequejeveux/widget/PageTemplate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMusicPage extends StatefulWidget {
  const AddMusicPage({super.key});

  @override
  State<AddMusicPage> createState() => _AddMusicPageState();
}

class _AddMusicPageState extends State<AddMusicPage> {
  String? userId;

  @override
  void initState() {
    super.initState();
    loadShared();
  }

  loadShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  TextEditingController _musicName = TextEditingController();
  TextEditingController _musicArtist = TextEditingController();
  TextEditingController _musicUrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      body: Column(
        children: [
          Text('Ajouter une musique'),
          TextField(
            controller: _musicName,
            decoration: InputDecoration(
              labelText: 'Nom de la musique',
            ),
          ),
          TextField(
            controller: _musicArtist,
            decoration: InputDecoration(
              labelText: 'Artiste',
            ),
          ),
          TextField(
            controller: _musicUrl,
            decoration: InputDecoration(
              labelText: 'Lien de la musique',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Song newSong = Song(
                  userId: userId,
                  title: _musicName.text,
                  artist: _musicArtist.text,
                  URL: _musicUrl.text);
              newSong.addToFirebase();
            },
            child: Text('Ajouter'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Annuler'),
          )
        ],
      ),
    );
  }
}
