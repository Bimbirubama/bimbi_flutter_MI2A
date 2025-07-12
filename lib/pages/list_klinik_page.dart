import 'package:flutter/material.dart';
import '../models/klinik_model.dart';
import '../services/api_service.dart';
import 'detail_klinik_page.dart';
import 'form_klinik_page.dart';

class ListKlinikPage extends StatefulWidget {
  const ListKlinikPage({Key? key}) : super(key: key);

  @override
  State<ListKlinikPage> createState() => _ListKlinikPageState();
}

class _ListKlinikPageState extends State<ListKlinikPage> {
  late Future<List<KlinikModel>> futureKlinik;

  @override
  void initState() {
    super.initState();
    futureKlinik = ApiService.fetchKlinik();
  }

  void _refreshData() {
    setState(() {
      futureKlinik = ApiService.fetchKlinik();
    });
  }

  void _deleteKlinik(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Hapus Klinik'),
        content: Text('Yakin ingin menghapus data klinik ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ApiService.deleteKlinik(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Klinik berhasil dihapus')),
        );
        _refreshData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus klinik')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Daftar Klinik'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<KlinikModel>>(
        future: futureKlinik,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.orange));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Belum ada data klinik.'));
          }

          final klinikList = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: klinikList.length,
            itemBuilder: (context, index) {
              final klinik = klinikList[index];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    klinik.nama,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.orange[800],
                    ),
                  ),
                  subtitle: Text(
                    klinik.kategori,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailKlinikPage(klinik: klinik),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormKlinikPage(
                                klinik: klinik,
                                isEdit: true,
                              ),
                            ),
                          ).then((result) {
                            if (result == true) {
                              _refreshData();
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteKlinik(klinik.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FormKlinikPage(isEdit: false),
            ),
          ).then((result) {
            if (result == true) {
              _refreshData();
            }
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Klinik',
      ),
    );
  }
}
