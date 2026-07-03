// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  // Fetch list of Pokémon (for the home screen)
  Future<List<Pokemon>> fetchPokemon({int limit = 50}) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Pokemon.fromListEntry(json)).toList();
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }

  // Fetch details for a single Pokémon (for the detail screen)
  Future<Pokemon> fetchPokemonDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Pokemon.fromDetails(data);
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }
}
