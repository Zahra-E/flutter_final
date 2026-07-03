// lib/models/pokemon.dart
class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> stats;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.height = 0,
    this.weight = 0,
    this.types = const [],
    this.stats = const [],
  });

  // For the LIST view (only name + url)
  factory Pokemon.fromListEntry(Map<String, dynamic> json) {
    final urlParts = json['url'].split('/');
    final id = int.parse(urlParts[urlParts.length - 2]);
    return Pokemon(
      id: id,
      name: json['name'],
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }

  // For the DETAILS view (full data)
  factory Pokemon.fromDetails(Map<String, dynamic> json) {
    final types = (json['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();
    final stats = (json['stats'] as List)
        .map((s) => '${s['stat']['name']}: ${s['base_stat']}')
        .toList();

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default'] ??
          json['sprites']['front_default'] ??
          '',
      height: json['height'] ~/ 10, // decimeters to meters
      weight: json['weight'] ~/ 10, // hectograms to kg
      types: types,
      stats: stats,
    );
  }
}
