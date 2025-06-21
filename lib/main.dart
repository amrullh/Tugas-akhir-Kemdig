import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase dengan pengecekan platform
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
    print('>>> Memulai AuthGate');

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print('>>> Stream Auth Status: ${snapshot.connectionState}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          print('>>> Menunggu koneksi auth...');
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          print('>>> Belum login, arahkan ke LoginPage');
          return LoginPage();
        }

        final uid = snapshot.data!.uid;
        print('>>> UID terdeteksi: $uid');

        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
          builder: (context, userSnapshot) {
            print('>>> Status userSnapshot: ${userSnapshot.connectionState}');

            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (userSnapshot.hasError) {
              print('>>> ERROR ambil userSnapshot: ${userSnapshot.error}');
              return Scaffold(
                body: Center(
                  child: Text('Terjadi kesalahan saat mengambil data pengguna'),
                ),
              );
            }

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              print('>>> Data pengguna tidak ditemukan di Firestore');
              return Scaffold(
                body: Center(child: Text('Data pengguna tidak ditemukan')),
              );
            }

            final userData = userSnapshot.data!.data();
            print('>>> Data pengguna ditemukan: $userData');

            final role = userData?['role'] ?? 'student';
            print('>>> Role pengguna: $role');

            return HomePage(role: role);
          },
        );
      },
    );
  }
}
