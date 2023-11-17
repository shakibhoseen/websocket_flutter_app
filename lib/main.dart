import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:websocket_flutter_app/view/home_scren.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:  ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily
    ),
      home: const HomeScreen(),
    );
  }
}