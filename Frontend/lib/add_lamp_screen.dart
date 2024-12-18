import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart';

class AddLampScreen extends StatefulWidget {
  @override
  _AddLampScreenState createState() => _AddLampScreenState();
}

class _AddLampScreenState extends State<AddLampScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idProductController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _installationDateController = TextEditingController();
  String _status = 'new'; // Default status
  bool _isSubmitting = false;

  // Fungsi untuk menambahkan lampu
  Future<void> _submitLamp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final lampData = {
        "id_product": _idProductController.text,
        "location": _locationController.text,
        "installation_date": _installationDateController.text,
        "status": _status,
        "owner_id": loggedInUserId, // Ambil owner_id dari variabel global
      };

      try {
        final response = await http.post(
          Uri.parse('http://192.168.0.105:8080/lamps'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(lampData),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lampu berhasil ditambahkan!')),
          );
          Navigator.pop(context);
        } else if (response.statusCode == 409) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lampu sudah ditambahkan! Silahkan cek daftar lampu.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan lampu: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Tidak dapat terhubung ke server')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Lampu'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID Produk
                TextFormField(
                  controller: _idProductController,
                  decoration: InputDecoration(
                    labelText: 'ID Produk',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'ID Produk tidak boleh kosong' : null,
                ),
                SizedBox(height: 16),

                // Lokasi
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Lokasi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Lokasi tidak boleh kosong' : null,
                ),
                SizedBox(height: 16),

                // Tanggal Instalasi
                TextFormField(
                  controller: _installationDateController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Instalasi (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Tanggal instalasi wajib diisi';
                    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                    if (!regex.hasMatch(value)) return 'Format tanggal salah';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Status Dropdown
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: 'new', child: Text('Baru')),
                    DropdownMenuItem(value: 'active', child: Text('Aktif')),
                    DropdownMenuItem(value: 'inactive', child: Text('Tidak Aktif')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
                SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitLamp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: _isSubmitting
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Simpan Lampu'),
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
