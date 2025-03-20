import 'package:cequejeveux/pages/musics/addMusics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageTemplate extends StatefulWidget {
  Widget body;
  String title = '';
  Color backgroundColor;

  PageTemplate(
      {super.key,
      required this.body,
      this.title = '',
      this.backgroundColor = Colors.white});

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    loadShared();
  }

  loadShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isConnected = prefs.getBool('isConnected') == true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.backgroundColor,
        appBar: AppBar(
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            if (isConnected)
              TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/register', (r) => false);
                  },
                  child: Text(
                    'Se déconnecter',
                    style: TextStyle(color: Colors.white),
                  ))
          ],
          title: Text(widget.title),
          backgroundColor: Color(0xFF7B435B),
        ),
        body: widget.body);
  }
}
