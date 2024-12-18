import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lamp_list_screen.dart';
import 'add_lamp_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String serverIP = '192.168.0.105';
  final int serverPort = 8080;
  String statusMessage = "";
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    checkDatabaseConnection(); // Cek koneksi saat layar dimuat
  }

  // Fungsi untuk mengecek koneksi ke backend
  Future<void> checkDatabaseConnection() async {
    final String url = 'http://$serverIP:$serverPort/ping';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isConnected = true;
          statusMessage = "Terhubung ke server: $serverIP:$serverPort\n${data['message']}";
        });
      } else {
        setState(() {
          isConnected = false;
          statusMessage = "Gagal terhubung ke server: $serverIP:$serverPort\nStatus: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isConnected = false;
        statusMessage = "Kesalahan: Tidak dapat terhubung ke server: $serverIP:$serverPort\nError: $e";
      });
    }

    // Tampilkan pop-up notifikasi
    showConnectionDialog();
  }

  // Fungsi untuk menampilkan dialog pop-up
  void showConnectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isConnected ? "Koneksi Berhasil" : "Koneksi Gagal"),
          content: Text(statusMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text("Okay"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Clock Icon
                  Column(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 64,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Jam',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  // Buttons with Icons
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add_circle, size: 40, color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddLampScreen()),
                          );
                        },
                      ),
                      Text('Tambah Lampu'),
                    ],
                  ),

                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.list, size: 40, color: Colors.orange),
                        onPressed: () {
                          // Navigate to List Lamp Screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LampListScreen()));
                        },
                      ),
                      Text('Daftar Lampu'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings, size: 40, color: Colors.blue),
                        onPressed: () {
                          // Navigate to Settings Screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsScreen()));
                        },
                      ),
                      Text('Pengaturan'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Power Consumption Section
              Text(
                'Power Consumptions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to Detail PJU Screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailPJUScreen()));
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(Icons.show_chart, size: 64, color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Map Section
              Text(
                'Units',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.map,
                    size: 64,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListLampScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Lampu')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigasi ke LampListScreen menggunakan Navigator
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LampListScreen()),
            );
          },
          child: Text('Lihat Daftar Lampu'),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengaturan')),
      body: Center(child: Text('Pengaturan')),
    );
  }
}

class DetailPJUScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail PJU')),
      body: Center(child: Text('Detail Informasi PJU')),
    );
  }
}
