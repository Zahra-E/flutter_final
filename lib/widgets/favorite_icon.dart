// lib/widgets/favorite_icon.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../providers/favorites_provider.dart';

class FavoriteIcon extends StatelessWidget {
  final Pokemon pokemon;

  const FavoriteIcon({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    // Listen to the FavoritesProvider
    final favProvider = context.watch<FavoritesProvider>();
    final isFav = favProvider.isFavorite(pokemon);

    return IconButton(
      icon: Icon(
        // Show filled heart if favorite, empty border if not
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.red : Colors.grey,
        size: 28,
      ),
      onPressed: () {
        // Toggle favorite status
        context.read<FavoritesProvider>().toggleFavorite(pokemon);
      },
    );
  }
}
