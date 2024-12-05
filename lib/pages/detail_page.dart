import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String amiiboSeries;
  final String character;
  final String gameSeries;
  final String type;
  final String head;
  final String tail;
  final Map<String, String> releaseDates;

  const DetailPage({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.amiiboSeries,
    required this.character,
    required this.gameSeries,
    required this.type,
    required this.head,
    required this.tail,
    required this.releaseDates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                imageUrl,
                width: 200, 
                height: 200,
                fit: BoxFit.contain, 
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100);
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailsRow('Amiibo Series', amiiboSeries),
            _buildDetailsRow('Character', character),
            _buildDetailsRow('Game Series', gameSeries),
            _buildDetailsRow('Type', type),
            _buildDetailsRow('Head', head),
            _buildDetailsRow('Tail', tail),
            const SizedBox(height: 16),
            const Text(
              'Release Dates:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...releaseDates.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(entry.value),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
