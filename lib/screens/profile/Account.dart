import 'dart:math'; // Import the Cart.dart file
import 'package:flutter/material.dart';
import 'package:menopal/model/user_model.dart';
import 'package:menopal/screens/LoginScreen.dart';
import 'package:menopal/screens/profile/EditProfile.dart';
import '../About.dart';
import '../Cart.dart';
import 'Menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late UserModel userModel; // Initialize userModel with null

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CustomClipPath(),
              child: Container(
                height: 110,
                width: 1920,
                color: Colors.pink,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50, 50, 0, 0),
                  child: Text(
                    'Profile',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  userModel = UserModel.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);
                  return buildProfileContent(context, userModel);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileContent(BuildContext context, UserModel userModel) {
    return Container(
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
                  child: Image.asset('assets/User.jpg'),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.amber[600],
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.pink,
                    size: 15,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(userModel.firstName! + ' ' + userModel.lastName!),
          Text(userModel.email!),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: userModel),
                  ),
                );
              },
              child: const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                side: BorderSide.none,
                shape: StadiumBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 5),

          //Menu
          Container(
            padding: EdgeInsets.fromLTRB(60, 10, 0, 0),
            child: Column(
              children: [
                FileMenu(
                  title: 'My Cart',
                  icon: Icons.shopping_cart,
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartPage()));
                  },
                ),
                const SizedBox(height: 5),
                FileMenu(
                  title: 'About Us',
                  icon: Icons.group_sharp,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUs()),
                    );
                  },
                ),
                const SizedBox(height: 5),
                FileMenu(
                  title: 'Socials',
                  icon: Icons.facebook,
                  onPress: () {},
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 60, 2),
                  child: ElevatedButton(
                    onPressed: () {
                      logout(context);
                    },
                    child: const Text(
                      'Log Out',
                      style: TextStyle(),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        side: BorderSide.none,
                        shape: StadiumBorder()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
}
