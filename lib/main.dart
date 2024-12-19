import 'package:car/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Sign out the user on app start
  await FirebaseAuth.instance.signOut();


  // Listen for authentication state changes
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(0, 48, 48, 1),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 25),

        ),
        scaffoldBackgroundColor: Color.fromRGBO(229, 225, 218, 1),

        inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        borderSide: BorderSide(color: Colors.blue),

        ),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
          labelStyle: TextStyle(color: Colors.black), // Style for the label
          hintStyle: TextStyle(color: Colors.grey), // Style for the hint tex
      ),
      )
    );
  }
}
