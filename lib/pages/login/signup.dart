import 'package:cequejeveux/Model/User.dart' as UserDB;
import 'package:cequejeveux/widget/PageTemplate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pseudoController = TextEditingController();

  signup() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      String userId = userCredential.user!.uid;
      UserDB.User user = UserDB.User(
          pseudo: _pseudoController.text, email: _emailController.text);
      user.addToFirebase(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Compte créé avec succès !")),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isConnected', true);
      prefs.setString('userId', userId);
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        body: Column(
      children: [
        TextField(
          controller: _pseudoController,
          decoration: InputDecoration(labelText: 'Pseudo'),
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Mot de passe'),
          obscureText: true,
        ),
        ElevatedButton(
          onPressed: () {
            signup();
          },
          child: Text('S\'inscrire'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text('Se connecter'),
        ),
      ],
    ));
  }
}
