import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final DateTime lastPeriodStart;
  final int cycleLength;

  User({
    required this.name,
    required this.email,
    required this.lastPeriodStart,
    required this.cycleLength,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'lastPeriodStart': lastPeriodStart,
      'cycleLength': cycleLength,
    };
  }

  Future<void> saveToFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(email).set(toMap());
  }
}
