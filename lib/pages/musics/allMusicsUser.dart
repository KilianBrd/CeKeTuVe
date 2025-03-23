import 'dart:async';

import 'package:cequejeveux/Model/music.dart';
import 'package:cequejeveux/tools.dart';
import 'package:cequejeveux/widget/PageTemplate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllMusicsByUserPage extends StatefulWidget {
  const AllMusicsByUserPage({super.key});

  @override
  State<AllMusicsByUserPage> createState() => _AllMusicsByUserPageState();
}

class _AllMusicsByUserPageState extends State<AllMusicsByUserPage> {
  Stream<List<Song>>? musics;

  @override
  void initState() {
    super.initState();
    loadMusics();
  }

  removeMusic(Song song) async {
    Song songToremove = song;
    await songToremove.removeThisSong();
  }

  loadMusics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    setState(() {
      musics = Song.getSongsByUserId(userId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Toutes mes musiques',
      backgroundColor: color3,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: musics,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Aucune musique trouvée.');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Song song = snapshot.data![index];
                      return ListTile(
                        title: Text(
                            '${song.title.toString().capitalize()} - ${song.artist.toString().capitalize()}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            setState(
                              () {
                                removeMusic(song);
                                loadMusics();
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
