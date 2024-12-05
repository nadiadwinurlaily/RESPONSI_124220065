import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const FavoriteScreen({Key? key, required this.onUpdate}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> favorites = [];

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> removeFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites.remove(name);
    });
    await prefs.setStringList('favorites', favorites);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name removed from favorites')),
    );
    widget.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return Dismissible(
          key: Key(favorite),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => removeFavorite(favorite),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(favorite),
              trailing: const Icon(Icons.favorite, color: Colors.red),
            ),
          ),
        );
      },
    );
  }
}
