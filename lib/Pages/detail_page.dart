import 'package:flutter/material.dart';
import 'encryption_helper.dart';

class DetailPage extends StatelessWidget {
  final String judul;
  final String deskripsi; // isinya masih decrypt

  const DetailPage({required this.judul, required this.deskripsi, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decryptedDeskripsi = EncryptionHelper.decrypt(deskripsi);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(judul)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(decryptedDeskripsi),
      ),
    );
  }
}
