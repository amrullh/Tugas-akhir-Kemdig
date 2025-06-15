import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPage extends StatefulWidget {
  final String docId;
  final String initialJudul;
  final String initialDeskripsi;

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
    deskripsiController = TextEditingController(text: widget.initialDeskripsi);
  }

  Future<void> handleEdit() async {
    setState(() => isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('materi')
          .doc(widget.docId)
          .update({
        'judul': judulController.text.trim(),
        'deskripsi': deskripsiController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      Navigator.pop(context); // Balik ke list setelah update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Materi berhasil diupdate!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Materi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: judulController,
              decoration: InputDecoration(labelText: 'Judul Materi'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: deskripsiController,
              maxLines: 4,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            SizedBox(height: 24),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: handleEdit,
                    child: Text('Update Materi',style: TextStyle(color: Colors.black),),
                  ),
          ],
        ),
      ),
    );
  }
}
