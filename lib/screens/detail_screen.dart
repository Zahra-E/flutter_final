// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/api_service.dart';
import '../models/pokemon.dart';
import '../providers/favorites_provider.dart';

class DetailScreen extends StatefulWidget {
  final int pokemonId;
  final String pokemonName;
  final String imageUrl;

  const DetailScreen({
    super.key,
    required this.pokemonId,
    required this.pokemonName,
    required this.imageUrl,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Pokemon> futureDetails;

  @override
  void initState() {
    super.initState();
    futureDetails = ApiService().fetchPokemonDetails(widget.pokemonId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          widget.pokemonName.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favProvider, child) {
              final tempPokemon = Pokemon(
                id: widget.pokemonId,
                name: widget.pokemonName,
                imageUrl: widget.imageUrl,
              );
              return IconButton(
                icon: Icon(
                  favProvider.isFavorite(tempPokemon)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favProvider.isFavorite(tempPokemon)
                      ? Colors.red
                      : colorScheme.onPrimary,
                  size: 28,
                ),
                onPressed: () {
                  favProvider.toggleFavorite(tempPokemon);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        favProvider.isFavorite(tempPokemon)
                            ? 'added_to_favorites'.tr()
                            : 'removed_from_favorites'.tr(),
                      ),
                      duration: const Duration(seconds: 1),
                      backgroundColor: favProvider.isFavorite(tempPokemon)
                          ? Colors.green
                          : Colors.grey,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Pokemon>(
        future: futureDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('loading_details'.tr()),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    '${'error'.tr()}: ${snapshot.error}',
                    style: TextStyle(fontSize: 16, color: colorScheme.onBackground),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureDetails = ApiService().fetchPokemonDetails(widget.pokemonId);
                      });
                    },
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            );
          }

          final pokemon = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Image.network(
                    pokemon.imageUrl,
                    height: 250,
                    width: 250,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 3,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.catching_pokemon,
                          size: 80,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  pokemon.name.toUpperCase(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: TextStyle(
                    fontSize: 18,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.label, size: 20, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      ...pokemon.types.map(
                        (type) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Chip(
                            label: Text(
                              type.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: _getTypeColor(type),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        icon: Icons.height,
                        label: 'height'.tr(),
                        value: '${pokemon.height} m',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        icon: Icons.monitor_weight,
                        label: 'weight'.tr(),
                        value: '${pokemon.weight} kg',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'base_stats'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...pokemon.stats.map((stat) => _buildStatTile(stat)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String stat) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final parts = stat.split(':');
    final statName = parts[0].trim().toUpperCase();
    final statValue = parts.length > 1 ? parts[1].trim() : '0';
    final int value = int.tryParse(statValue) ?? 0;
    final maxValue = 255;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              statName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              statValue,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: value / maxValue,
                minHeight: 8,
                backgroundColor: colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  value > 100 ? colorScheme.primary : colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    final typeColors = {
      'normal': Colors.brown.shade300,
      'fire': Colors.orange.shade700,
      'water': Colors.blue.shade400,
      'grass': Colors.green.shade500,
      'electric': Colors.yellow.shade700,
      'ice': Colors.cyan.shade300,
      'fighting': Colors.red.shade800,
      'poison': Colors.purple.shade500,
      'ground': Colors.brown.shade500,
      'flying': Colors.indigo.shade300,
      'psychic': Colors.pink.shade400,
      'bug': Colors.lime.shade700,
      'rock': Colors.grey.shade700,
      'ghost': Colors.deepPurple.shade400,
      'dark': Colors.grey.shade900,
      'dragon': Colors.deepPurple.shade700,
      'steel': Colors.grey.shade500,
      'fairy': Colors.pink.shade200,
    };
    return typeColors[type.toLowerCase()] ?? Colors.grey.shade400;
  }
}
