import 'package:flutter/material.dart';
import 'package:menopal/screens/RegistrationScreen.dart';

class updateProfile extends StatefulWidget {
  const updateProfile({super.key});

  @override
  State<updateProfile> createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        ClipPath(
          clipper: CustomClipPath(),
          child: Container(
            height: 110,
            width: 1920,
            color: Colors.pink,
            child: Padding(
              padding: EdgeInsets.fromLTRB(50, 50, 0, 0),
              child: Text(
                'Edit Profile',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('assets/User.jpg')),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.amber[600]),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.pink,
                        size: 15,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ]),
    ));
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 2);
    path.cubicTo(size.width / 4, 3 * (size.height / 2), 3 * (size.width / 4),
        size.height / 2, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
