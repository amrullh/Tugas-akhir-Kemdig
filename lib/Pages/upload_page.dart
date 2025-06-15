import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'encryption_helper.dart'; // pastikan path benar

class UploadPage extends StatefulWidget {
  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  bool isLoading = false;

  Future<void> uploadMateri() async {
    if (judulController.text.isEmpty || deskripsiController.text.isEmpty) return;
    setState(() => isLoading = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      final encryptedDesc = EncryptionHelper.encrypt(deskripsiController.text);

      await FirebaseFirestore.instance.collection('materi').add({
        'judul': judulController.text,
        'deskripsi': encryptedDesc,
        'createdBy': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Materi berhasil diupload!"))
      );
      judulController.clear();
      deskripsiController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: judulController,
            decoration: InputDecoration(labelText: "Judul Materi (teks)"),
          ),
          SizedBox(height: 12),
          TextField(
            controller: deskripsiController,
            decoration: InputDecoration(labelText: "Isi Materi (teks)"),
            minLines: 3,
            maxLines: 10,
          ),
          SizedBox(height: 20),
          isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: uploadMateri,
                  child: Text(
                    "Upload Materi",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
        ],
      ),
    );
  }
}
