import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menopal/firebase_options.dart';
import 'package:menopal/screens/Getstarted.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MenoPal());
}

class MenoPal extends StatelessWidget {
  const MenoPal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Meno Pal",
        theme: ThemeData(
          fontFamily: GoogleFonts.robotoCondensed().fontFamily,
          primaryColor: Color.fromARGB(0, 31, 8, 68),
          primarySwatch: Colors.pink,
          primaryColorLight: Color.fromARGB(255, 0, 0, 0),
          scaffoldBackgroundColor: Color.fromARGB(255, 240, 220, 192),
          textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodySmall: TextStyle(color: Colors.black)),
        ),
        home: HomePage());
  }
}
