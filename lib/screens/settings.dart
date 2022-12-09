import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qreate/screens/delete_account.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ), body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[Container(
          width: 150,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(onPressed: () {
            try{
              FirebaseAuth.instance.signOut().then((value) => Navigator.pop(context));
            } on FirebaseAuthException catch(error){
              if (kDebugMode) {
                print(error);
              }
            }
          }, child: const Text("Sign Out")),
        ),
          Container(
            width: 150,
            margin: const EdgeInsets.symmetric(vertical: 10),

            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteAccount()));
            }, child: const Text("Delete Account", style: TextStyle(color: Colors.white),)),
          ),
        ],
    ),
      ),
    );
  }
}
