import 'package:cequejeveux/widget/PageTemplate.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Paramètres',
      body: Column(
        children: [
          Text('Paramètres'),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings/background');
            },
            child: Text('Changer de fond d\'écran'),
          )
        ],
      ),
    );
  }
}
