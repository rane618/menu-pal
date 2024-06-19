import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menopal/screens/LoginScreen.dart';
import 'package:menopal/screens/RegistrationScreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(40),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(children: [
              Image.asset(
                'assets/launch_image.png',
                height: 250,
                width: 250,
              ),
              Positioned(
                bottom: 30,
                right: 10,
                child: Text(
                  'Stay on top of your cycle with ease.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lobsterTwo(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              )
            ]),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  backgroundColor: Colors.pink),
              child: Text('Log In',
                  style: GoogleFonts.oswald(fontSize: 25, color: Colors.black)),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return LoginScreen();
                  }),
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  backgroundColor: Colors.pink),
              child: Text(
                'Register Now',
                style: GoogleFonts.oswald(fontSize: 25, color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return RegistrationScreen();
                  }),
                );
              },
            ),
          ]),
    ));
  }
}
