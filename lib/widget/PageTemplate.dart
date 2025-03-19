import 'package:cequejeveux/pages/musics/addMusics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageTemplate extends StatefulWidget {
  Widget body;
  String title = '';

  PageTemplate({super.key, required this.body, this.title = ''});

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
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
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
                  child: Text('Se déconnecter'))
          ],
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: widget.body);
  }
}
