import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cequejeveux/Model/music.dart';
import 'package:cequejeveux/pages/login/signup.dart';
import 'package:cequejeveux/pages/musics/addMusics.dart';
import 'package:cequejeveux/widget/PageTemplate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final YoutubeExplode _yt = YoutubeExplode();
  bool _isPlaying = false;
  String _currentVideoUrl = '';
  String _errorMessage = '';
  String musicTitle = '';
  String musicArtist = '';
  String? userId;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
    // Listen for state changes using the updated API
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        buttonPlayAction();
      }
    });

    // Use the correct error listener for the latest audioplayers version
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
      });
    });

    // Listen for player errors
    _audioPlayer.onLog.listen((String log) {
      print("AudioPlayer log: $log");
    });
  }

  Future<void> playAudio(String videoUrl) async {
    try {
      setState(() {
        _isPlaying = false;
        _currentVideoUrl = videoUrl;
        _errorMessage = '';
      });

      // Extract video ID from the URL
      var videoId = VideoId(videoUrl);

      // Get streams manifest
      var manifest = await _yt.videos.streamsClient.getManifest(videoId);

      // Get audio-only stream URL
      var audioOnlyStreams = manifest.audioOnly;
      if (audioOnlyStreams.isEmpty) {
        throw Exception("No audio streams found");
      }

      var audioUrl = audioOnlyStreams.withHighestBitrate().url.toString();

      // Use the correct method to play audio
      try {
        await _audioPlayer.play(UrlSource(audioUrl));
        setState(() {
          _isPlaying = true;
        });
      } catch (audioError) {
        print("Audio playback error: $audioError");
        setState(() {
          _errorMessage = "Playback error: ${audioError.toString()}";
        });
      }
    } catch (e) {
      print("Error preparing audio: $e");
      setState(() {
        _errorMessage = "Error: ${e.toString()}";
      });
    }
  }

  void stopAudio() async {
    try {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      print("Error stopping audio: $e");
      setState(() {
        _errorMessage = "Error stopping: ${e.toString()}";
      });
    }
  }

  buttonPlayAction() async {
    Stream<List<Song>> songs = Song.getSongsByUserId(userId!);
    StreamSubscription<List<Song>> subscription =
        songs.listen((List<Song> songsAvailable) {
      if (songsAvailable.isNotEmpty) {
        Random random = Random();
        int randomIndex = random.nextInt(songsAvailable.length);
        Song randomSong = songsAvailable[randomIndex];

        if (randomSong.URL != null) {
          String url = randomSong.URL!;
          playAudio(url);
          setState(() {
            musicArtist = randomSong.artist!;
            musicTitle = randomSong.title!;
          });
        }
      }
    }, onError: (error) {
      print("Erreur lors de la récupération des chansons: $error");
    });
    Future.delayed(Duration(seconds: 5), () {
      subscription.cancel();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: widget.title,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                // Navigate to the MusicsPage when the image is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMusicPage()),
                );
              },
              child: Text('Ajouter une musique'),
            ),
            Text(
              _isPlaying
                  ? "En train de lire : $musicTitle - $musicArtist"
                  : "Lance une musique",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            if (_currentVideoUrl.isNotEmpty && _isPlaying)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "URL en cours : $_currentVideoUrl",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isPlaying ? stopAudio : () => buttonPlayAction(),
                  icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                  label: Text(_isPlaying ? "Stop" : "Play Audio"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
