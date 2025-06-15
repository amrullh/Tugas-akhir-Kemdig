import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthGate());
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData) {
          return LoginPage();
        } else {
          final uid = snapshot.data!.uid;
          print('>>> LOGIN UID: $uid'); 
          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                print('>>> USER DATA NOT FOUND FOR UID: $uid');
                return Scaffold(
                  body: Center(child: Text('User data not found')),
                );
              }
              final userData = userSnapshot.data!.data();
              print(
                '>>> USER DATA: $userData',
              ); 
              print('>>> USER DATA KEYS: ${userData?.keys}');
              
              if (!userData!.containsKey('role')) {
                print('>>> FIELD role TIDAK ADA DI FIrestore!');
              }
              final role = userData['role'] ?? 'student';
              print('>>> ROLE YANG DIAMBIL: $role'); 
              return HomePage(role: role);
            },
          );
        }
      },
    );
  }
}
