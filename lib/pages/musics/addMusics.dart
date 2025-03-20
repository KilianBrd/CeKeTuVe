import 'package:cequejeveux/Model/music.dart';
import 'package:cequejeveux/tools.dart';
import 'package:cequejeveux/widget/PageTemplate.dart';
import 'package:cequejeveux/widget/form/textFieldMusic.dart';
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
      title: 'Ajouter une musique',
      backgroundColor: color3,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        child: Column(
          children: [
            Text('Ajouter une musique'),
            TextFieldMusic(
              icon: Icon(Icons.music_note),
              controller: _musicName,
              hintText: 'Nom de la musique',
            ),
            spacingM,
            TextFieldMusic(
              icon: Icon(Icons.person),
              controller: _musicArtist,
              hintText: 'Artiste',
            ),
            spacingM,
            TextFieldMusic(
              icon: Icon(Icons.link),
              controller: _musicUrl,
              hintText: 'URL Youtube',
            ),
            spacingM,
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 500),
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black)),
                onPressed: () {
                  Song newSong = Song(
                      userId: userId,
                      title: _musicName.text,
                      artist: _musicArtist.text,
                      URL: _musicUrl.text);
                  newSong.addToFirebase();
                  showToast(context, 'Musique ajoutée !');
                },
                child: Text(
                  'Ajouter',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            spacingsM,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 500),
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Annuler',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
