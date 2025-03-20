import 'package:flutter/material.dart';

class TextFieldMusic extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  Icon icon = Icon(Icons.search);
  TextFieldMusic(
      {super.key,
      required this.controller,
      this.hintText = '',
      required this.icon});

  @override
  State<TextFieldMusic> createState() => _TextFieldMusicState();
}

class _TextFieldMusicState extends State<TextFieldMusic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: widget.icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
