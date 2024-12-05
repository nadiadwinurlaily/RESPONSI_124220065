import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatelessWidget {
  final String head;
  final String character;
  final String gameSeries;
  final String title;
  final String imageUrl;
  final String name;

  const DetailPage(
      {super.key,
      required this.head,
      required this.character,
      required this.gameSeries,
      required this.title,
      required this.imageUrl,
      required this.name});
  Future<Map<String, dynamic>> fetchDetail() async {
    final response = await http
        .get(Uri.parse('https://www.amiiboapi.com/api/amiibo/$head/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$head Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan gambar
                  Image.network(data['image'] ?? '', fit: BoxFit.cover),

                  const SizedBox(height: 16),
                  // Menampilkan judul
                  Text(
                    data['amiiboSeries'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Menampilkan nama
                  Text(
                    'Name: ${data['name'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  // Menampilkan character
                  Text(
                    'Character: ${data['character'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  // Menampilkan game series
                  Text(
                    'Game Series: ${data['gameSeries'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  // Floating action button yang dapat diubah fungsinya
                  FloatingActionButton(
                    onPressed: () {
                      // Fungsi lainnya sesuai kebutuhan
                      // Contoh: navigasi ke link eksternal atau lakukan aksi lain
                    },
                    child: const Icon(Icons.open_in_browser),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
