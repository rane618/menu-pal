import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AdminDashboard.dart';
import 'package:menopal/screens/Tracker.dart';
import 'package:menopal/screens/Getstarted.dart';
import 'package:menopal/screens/Home.dart';
import 'RegistrationScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //boolean variable for admin
  bool isAdmin = false;
  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        RegExp regExp = new RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
        if (value == null || value.isEmpty) {
          return 'Please Enter Your Email!!';
        }
        if (!regExp.hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        _emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: "Email",
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    //password field
    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value == null || value.isEmpty) {
          return 'Please enter your Password';
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter a Valid Password(Min 6 char)");
        }
        return null;
      },
      onSaved: (value) {
        _passwordController.text = value!;
      },
      decoration: InputDecoration(
          hintText: "Password",
          prefixIcon: Icon(Icons.key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    //login button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.pink,
      child: MaterialButton(
        onPressed: () {
          signIn(_emailController.text, _passwordController.text);
        },
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          "Login",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 220, 192),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'Welcome back to Meno Pal!',
                      style: GoogleFonts.lobsterTwo(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    emailField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 40),
                    loginButton
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //login function

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                if (email == "admin@gmail.com")
                  {
                    isAdmin = true,
                  }, // Update this line

                Fluttertoast.showToast(msg: "Login Successful!"),

                if (isAdmin)
                  {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminDashboardUI(
                                isAdmin: true,
                                context: context,
                              )),
                      (route) => false,
                    ),
                  }
                else
                  {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                      (route) => false,
                    ),
                  }
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  Future<bool> checkAdmin(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('admin').doc(uid).get();
    return snapshot.exists && snapshot.data() != null;
  }
}
