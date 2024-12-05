import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_page.dart';
import 'favorite_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _data;
  int _selectedIndex = 0;
  List<String> favorites = [];

  Future<List<dynamic>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://www.amiiboapi.com/api/amiibo/'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['amiibo'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> toggleFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    if (favorites.contains(name)) {
      favorites.remove(name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name removed from favorites')),
      );
    } else {
      favorites.add(name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name added to favorites')),
      );
    }
    await prefs.setStringList('favorites', favorites);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _data = fetchData();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeScreen(),
      FavoriteScreen(onUpdate: loadFavorites), 
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nintendo Amiibo App'),
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomeScreen() {
    return FutureBuilder<List<dynamic>>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              final isFavorite = favorites.contains(item['name']);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    item['image'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                  title: Text(item['name']),
                  subtitle: Text(item['gameSeries']),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () => toggleFavorite(item['name']),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(
                        name: item['name'],
                        imageUrl: item['image'],
                        amiiboSeries: item['amiiboSeries'] ?? 'Unknown',
                        character: item['character'] ?? 'Unknown',
                        gameSeries: item['gameSeries'] ?? 'Unknown',
                        type: item['type'] ?? 'Unknown',
                        head: item['head'] ?? 'Unknown',
                        tail: item['tail'] ?? 'Unknown',
                        releaseDates: {
                          'Australia': item['release']['au'] ?? 'N/A',
                          'Europe': item['release']['eu'] ?? 'N/A',
                          'Japan': item['release']['jp'] ?? 'N/A',
                          'North America': item['release']['na'] ?? 'N/A',
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
