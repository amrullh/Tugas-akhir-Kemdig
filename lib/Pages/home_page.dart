import 'package:flutter/material.dart';
import 'upload_page.dart';
import 'profile_page.dart';
import 'notification_page.dart';
import 'edit_page.dart';
import 'detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final String role;
  const HomePage({required this.role, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == 'admin';

    final pages = isAdmin
        ? [MateriListPage(isAdmin: true), UploadPage(), ProfilePage()]
        : [MateriListPage(isAdmin: false), NotificationPage(), ProfilePage()];

    
    return Scaffold(
      body: pages[_selectedIndex],
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 25,
          right: 25,
          bottom: 15,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFC7E9C0),
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 112, 184, 98),
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.white,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              items: isAdmin
                  ? const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_rounded, size: 27),
                        label: 'Beranda',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.upload_rounded, size: 27),
                        label: 'Unggah',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_2_rounded, size: 27),
                        label: 'Profil',
                      ),
                    ]
                  : const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_rounded, size: 27),
                        label: 'Beranda',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.notifications_rounded, size: 27),
                        label: 'Notifikasi',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_2_rounded, size: 27),
                        label: 'Profil',
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}

class MateriListPage extends StatelessWidget {
  final bool isAdmin;
  const MateriListPage({required this.isAdmin, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('materi')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return Center(child: Text("Belum ada materi"));
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final docId = docs[i].id;

            return Card(
              color: const Color.fromARGB(255, 112, 184, 98),
              child: ListTile(
                title: Text(data['judul'] ?? ''),
                trailing: isAdmin
                    ? PopupMenuButton<String>(
                        color: Colors.white,
                        onSelected: (value) async {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditPage(
                                  docId: docId,
                                  initialJudul: data['judul'] ?? '',
                                  initialDeskripsi: data['deskripsi'] ?? '',
                                ),
                              ),
                            );
                          } else if (value == 'delete') {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                iconColor: Colors.white,
                                title: const Text(
                                  'Hapus Materi?',
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: const Text(
                                  'Yakin ingin menghapus materi ini?',
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text(
                                      'Batal',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                  ),
                                  ElevatedButton(
                                    child: const Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await FirebaseFirestore.instance
                                  .collection('materi')
                                  .doc(docId)
                                  .delete();
                            }
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Hapus'),
                          ),
                        ],
                      )
                    : null,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(
                      judul: data['judul'] ?? '',
                      deskripsi: data['deskripsi'] ?? '',
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
