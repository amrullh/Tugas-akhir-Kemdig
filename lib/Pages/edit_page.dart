import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'encryption_helper.dart';

class EditPage extends StatefulWidget {
  final String docId;
  final String initialJudul;
  final String initialDeskripsi; // ini masih terenkripsi!

  const EditPage({
    required this.docId,
    required this.initialJudul,
    required this.initialDeskripsi,
    Key? key,
  }) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController judulController;
  late TextEditingController deskripsiController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    judulController = TextEditingController(text: widget.initialJudul);
    // DESKRIPSI di-decrypt dulu sebelum masuk ke controller
    deskripsiController = TextEditingController(
      text: EncryptionHelper.decrypt(widget.initialDeskripsi),
    );
  }

  Future<void> updateMateri() async {
    if (judulController.text.isEmpty || deskripsiController.text.isEmpty)
      return;
    setState(() => isLoading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final encryptedDesc = EncryptionHelper.encrypt(deskripsiController.text);

      await FirebaseFirestore.instance
          .collection('materi')
          .doc(widget.docId)
          .update({
            'judul': judulController.text,
            'deskripsi': encryptedDesc,
            'updatedBy': uid,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Materi berhasil diupdate!")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Materi')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: judulController,
              decoration: InputDecoration(labelText: "Judul Materi"),
            ),
            SizedBox(height: 12),
            TextField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: "Isi Materi"),
              minLines: 3,
              maxLines: 10,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: updateMateri,
                    child: Text(
                      "Update Materi",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
