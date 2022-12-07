import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ), body: Center(
      child: ElevatedButton(onPressed: () {
        try{
          FirebaseAuth.instance.signOut().then((value) => Navigator.pop(context));
        } on FirebaseAuthException catch(error){
          print(error);
        }
      }, child: const Text("Sign Out")),
    ),
    );
  }
}
