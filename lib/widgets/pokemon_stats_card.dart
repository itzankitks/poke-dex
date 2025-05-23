import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pika_dex/models/pokemon_model.dart';
import 'package:pika_dex/providers/pokemon_data_provider.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String pokemonUrl;

  const PokemonStatsCard({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));

    return AlertDialog(
      title: Text("Statistics"),
      content: pokemon.when(
        data: (data) {
          return _statsUI(context, data);
        },
        error: (error, stackTrace) {
          return Text("Error: $error");
        },
        loading: () {
          return CircularProgressIndicator(color: Colors.white);
        },
      ),
    );
  }

  Widget _statsUI(BuildContext context, Pokemon? pokemon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          pokemon?.stats?.map((s) {
            return Text("${s.stat?.name?.toUpperCase()}: ${s.baseStat} ");
          }).toList() ??
          [Text("No stats available.")],
    );
  }
}
