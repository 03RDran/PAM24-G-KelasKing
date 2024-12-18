import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lamp_detail_screen.dart';

const String baseUrl = '192.168.0.105'; // Sesuaikan dengan backend

class LampListScreen extends StatefulWidget {
  @override
  _LampListScreenState createState() => _LampListScreenState();
}

class _LampListScreenState extends State<LampListScreen> {
  List<dynamic> lampList = []; // Menyimpan data lampu

  @override
  void initState() {
    super.initState();
    fetchLampList();
  }

  // Fungsi mengambil data lampu dari backend
  Future<void> fetchLampList() async {
    try {
      final response = await http.get(Uri.parse('http://$baseUrl:8080/lamps'));
      if (response.statusCode == 200) {
        final List<dynamic> lamps = json.decode(response.body);
        setState(() {
          lampList = lamps;
        });
      } else {
        throw Exception('Gagal mengambil data lampu');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil daftar lampu. Error: $e')),
      );
    }
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return "${parsedDate.day}-${parsedDate.month}-${parsedDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Lampu'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke dashboard
          },
        ),
      ),
      body: lampList.isEmpty
          ? Center(child: Text('Tidak ada lampu yang tersedia.'))
          : ListView.builder(
              itemCount: lampList.length,
              itemBuilder: (context, index) {
                final lamp = lampList[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: lamp['status'] == 'active'
                          ? Colors.green
                          : lamp['status'] == 'new'
                              ? Colors.orange
                              : Colors.red,
                      child: Icon(Icons.lightbulb, color: Colors.white),
                    ),
                    title: Text(
                      'ID Produk: ${lamp['id_product']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lokasi: ${lamp['location']}'),
                        Text(
                            'Tanggal Instalasi: ${formatDate(lamp['installation_date'])}'),
                      ],
                    ),
                    trailing: Text(
                      lamp['status'] == 'active'
                          ? 'Aktif'
                          : lamp['status'] == 'new'
                              ? 'Baru'
                              : 'Tidak Aktif',
                      style: TextStyle(
                        color: lamp['status'] == 'active'
                            ? Colors.green
                            : lamp['status'] == 'new'
                                ? Colors.orange
                                : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LampDetailScreen(lampId: lamp['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
