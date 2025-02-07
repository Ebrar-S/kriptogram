import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kriptogram/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kriptogram',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: LoginPage(),
    );
  }
}
