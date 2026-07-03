// lib/providers/favorites_provider.dart
import 'package:flutter/foundation.dart';
import '../models/pokemon.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Pokemon> _favorites = [];

  List<Pokemon> get favorites => _favorites;

  bool isFavorite(Pokemon pokemon) {
    return _favorites.any((p) => p.id == pokemon.id);
  }

  void toggleFavorite(Pokemon pokemon) {
    if (isFavorite(pokemon)) {
      _favorites.removeWhere((p) => p.id == pokemon.id);
    } else {
      _favorites.add(pokemon);
    }
    notifyListeners(); // Tells the screen to update
  }
}
