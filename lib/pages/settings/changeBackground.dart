import 'package:cequejeveux/widget/PageTemplate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeBackground extends StatefulWidget {
  const ChangeBackground({super.key});

  @override
  State<ChangeBackground> createState() => _ChangeBackgroundState();
}

class _ChangeBackgroundState extends State<ChangeBackground> {
  changeBackground() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('backgroundUrl', _controller.text);
  }

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Changer le fond',
      body: Column(
        children: [
          Text('Changer le fond :'),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Entrez le lien d\'une vidéo youtube',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                changeBackground();
              },
              child: Text('Changer'))
        ],
      ),
    );
  }
}
