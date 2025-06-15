import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> handleLogin() async {
    setState(() => isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // --- Ambil UID dan email
      final uid = userCredential.user!.uid;
      final email = userCredential.user!.email ?? '';

      // --- Ambil nama user dari Firestore (collection users)
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final nama = userDoc.data()?['nama'] ?? '';

      // --- Catat ke collection login_logs
      await FirebaseFirestore.instance.collection('login_logs').add({
        'uid': uid,
        'email': email,
        'nama': nama,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('>>> Berhasil menulis login_logs ke Firestore');

      // --- Tampilkan pesan, lalu pindah halaman (jangan pakai setState lagi)
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login sukses! Selamat datang, $nama')),
      );
      // Delay sedikit supaya user lihat snackbar
      await Future.delayed(const Duration(milliseconds: 700));

      // Pindah ke halaman utama atau tutup halaman login, **tidak perlu setState lagi**
      if (mounted)
        Navigator.pop(context); // atau pushReplacement ke halaman utama
    } on FirebaseAuthException catch (e) {
      String message = "Login gagal: ";
      if (e.code == 'user-not-found') {
        message += "Email tidak ditemukan";
      } else if (e.code == 'wrong-password') {
        message += "Password salah";
      } else {
        message += e.message ?? e.code;
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Login'), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 24),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: handleLogin,
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Belum punya akun? Register di sini",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
