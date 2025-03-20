import 'package:cequejeveux/pages/login/login.dart';
import 'package:cequejeveux/pages/login/signup.dart';
import 'package:cequejeveux/pages/musics/home.dart';
import 'package:cequejeveux/pages/settings/changeBackground.dart';
import 'package:cequejeveux/pages/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter is initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isConnected;
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    loadShared();
  }

  loadShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isConnected') == true) {
      try {
        setState(() {
          isConnected = true;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isConnected = false;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isConnected = false;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const MyHomePage(title: 'Ce que je veux'),
        '/register': (context) => const signup(),
        '/login': (context) => const login(),
        '/settings': (context) => const SettingsPage(),
        '/settings/background': (context) => const ChangeBackground(),
      },
      title: 'YouTube Audio Player',
      theme: ThemeData(
        textTheme: GoogleFonts.ptSansTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isConnected == true
              ? const MyHomePage(title: 'Ce que je veux')
              : signup(),
    );
  }
}
