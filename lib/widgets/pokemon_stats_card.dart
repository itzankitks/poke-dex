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
      title: Align(
        alignment: Alignment.center,
        child: Text("Statistics", textAlign: TextAlign.center),
      ),
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
    return Row(
      children: [
        Expanded(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: MediaQuery.of(context).size.height * 0.05,
            backgroundImage:
                pokemon != null
                    ? NetworkImage(pokemon.sprites!.frontDefault!)
                    : null,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              pokemon?.stats?.map((s) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${s.stat?.name?.toUpperCase()}: ${s.baseStat} "),
                      Stack(
                        children: [
                          Container(
                            height: 5,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Container(
                            height: 5,
                            width: s.baseStat! * 1.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.lightGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList() ??
              [Text("No stats available.")],
        ),
      ],
    );
  }
}
