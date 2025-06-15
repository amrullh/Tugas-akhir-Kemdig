import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Profile'), backgroundColor: Colors.white),
      body: Center(
        child: ElevatedButton(
          child: Text('Logout', style: TextStyle(color: Colors.black)),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
        ),
      ),
    );
  }
}
