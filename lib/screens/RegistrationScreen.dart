import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:menopal/screens/Getstarted.dart';
import 'package:menopal/screens/Home.dart';
import 'package:menopal/screens/Tracker.dart';
import 'package:menopal/screens/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile/EditProfile.dart';
import 'AdminDashboard.dart';
import '../model/user_model.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //Boolean variable for admin
  bool isAdmin = false;
  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController _firstNameController =
      new TextEditingController();
  final TextEditingController _lastNameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController =
      new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    //firstname field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: _firstNameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill your first name';
        }
        return null;
      },
      onSaved: (value) {
        _firstNameController.text = value!;
      },
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          hintText: 'First name',
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //lastName field
    final lastNameField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.name,
      controller: _lastNameController,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your last name';
        }
        return null;
      },
      onSaved: (value) {
        _lastNameController.text = value!;
      },
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          hintText: "Last Name",
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //Password field
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

    //confirmPassword field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _confirmPasswordController,
      textInputAction: TextInputAction.done,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value == null || value.isEmpty) {
          return 'Please re-enter your Password';
        }
        if (_confirmPasswordController.text != _passwordController.text) {
          return 'Password dont match';
        }
        return null;
      },
      onSaved: (value) {
        _confirmPasswordController.text = value!;
      },
      decoration: InputDecoration(
          hintText: "Confirm Password",
          prefixIcon: Icon(Icons.key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //sign up button
    final signUpButton = Material(
        elevation: 5,
        color: Colors.pink,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          onPressed: () {
            signUp(_emailController.text, _passwordController.text);
          },
          padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
          child: Text("Sign Up",
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center),
        ));
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 220, 192),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/launch_image.png',
                        height: 200,
                        width: 200,
                      ),
                      Positioned(
                        bottom: 10,
                        child: Text(
                          'Create your account',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  firstNameField,
                  SizedBox(height: 20),
                  lastNameField,
                  SizedBox(height: 20),
                  emailField,
                  SizedBox(height: 20),
                  passwordField,
                  SizedBox(height: 20),
                  confirmPasswordField,
                  SizedBox(height: 30),
                  signUpButton,
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  //signUp function
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                if (email == "admin@gmail.com")
                  {
                    isAdmin = true,
                  },
                postDetailsToFirestore()
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    //calling firestore
    //calling user model
    //sending values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = _firstNameController.text;
    userModel.lastName = _lastNameController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");

    if (isAdmin) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => AdminDashboardUI(
                    isAdmin: true,
                    context: context,
                  )),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => Homepage()),
          (route) => false);
    }
  }
}
