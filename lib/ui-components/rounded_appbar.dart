import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoundAppBar extends StatelessWidget implements PreferredSizeWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String titleName; // Add a parameter for the title name

  RoundAppBar(
      {super.key,
      required this.titleName}); // Constructor to initialize titleName

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titleName, // Use the titleName parameter here
        style: const TextStyle(
          color: Colors.white, // Set title color to white
        ),
      ),
      titleSpacing: 00.0,
      centerTitle: true,
      toolbarHeight: 60.2,
      toolbarOpacity: 0.8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      elevation: 0.00,
      backgroundColor: Colors.lightBlueAccent,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            _auth.signOut();
            Navigator.pushReplacementNamed(context, "login_screen");
            //Implement logout functionality
          },
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
