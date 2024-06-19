import 'package:flutter/material.dart';

class FileMenu extends StatelessWidget {
  const FileMenu(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress});

  final String title;
  final IconData icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onPress,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.pink,
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(title));
  }
}
