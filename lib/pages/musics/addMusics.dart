import 'package:cequejeveux/Model/music.dart';
import 'package:cequejeveux/tools.dart';
import 'package:cequejeveux/widget/PageTemplate.dart';
import 'package:cequejeveux/widget/form/textFieldMusic.dart';
import 'package:field_suggestion/field_suggestion.dart';
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

  Future<List<Song>> loadAllSong(input) {
    Song song = Song();
    return song.getSongWithString(input);
  }

  final TextEditingController _musicName = TextEditingController();
  final TextEditingController _musicArtist = TextEditingController();
  final TextEditingController _musicUrl = TextEditingController();
  TextEditingController songFromBdd = TextEditingController();
  BoxController boxController = BoxController();
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
            spacingM,
            Text('Rechercher une musique dans la base de données'),
            FieldSuggestion.network(
                inputDecoration: InputDecoration(
                  hintText: 'Rechercher une musique',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                boxController: boxController,
                textController: songFromBdd,
                future: (input) => loadAllSong(input),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].title
                              .toString()
                              .capitalize()),
                          subtitle: Text(snapshot.data![index].artist
                              .toString()
                              .capitalize()),
                          onTap: () async {
                            Song newSong = Song(
                                userId: userId,
                                title:
                                    snapshot.data![index].title?.toLowerCase(),
                                artist:
                                    snapshot.data![index].artist?.toLowerCase(),
                                URL: snapshot.data![index].URL);
                            await newSong.addToFirebase();
                            boxController.close?.call();
                            showToast(context, 'Musique ajoutée !');
                          },
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            spacingM,
            Text('---------------------- OU -------------------------'),
            Text('Ajouter une musique dans la base de données'),
            spacingM,
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
                      title: _musicName.text.toLowerCase(),
                      artist: _musicArtist.text.toLowerCase(),
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
