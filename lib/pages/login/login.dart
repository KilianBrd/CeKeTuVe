import 'package:cequejeveux/widget/PageTemplate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    try {
      String email = emailController.text;
      String password = passwordController.text;
      UserCredential userCredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vous êtes bien connecté !")),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isConnected', true);
      prefs.setString('userId', userCredentials.user!.uid);

      Navigator.pushNamed(context, '/home');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Se connecter',
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              login();
            },
            child: Text('Se connecter'),
          ),
        ],
      ),
    );
  }
}
