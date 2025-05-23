import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pika_dex/models/pokemon_model.dart';
import 'package:pika_dex/providers/favorite_pokemon_provider.dart';
import 'package:pika_dex/providers/pokemon_data_provider.dart';
import 'package:pika_dex/widgets/pokemon_stats_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonUrl;

  late FavoritePokemonsProvider _favoritePokemonsProvider;

  PokemonCard({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);

    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));

    return pokemon.when(
      data: (data) {
        return _card(context, data, false);
      },
      error: (error, stackTrace) {
        return Text("Error: $error");
      },
      loading: () {
        return _card(context, null, true);
      },
    );
  }

  Widget _card(BuildContext context, Pokemon? pokemon, bool isLoading) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (_) {
                return PokemonStatsCard(pokemonUrl: pokemonUrl);
              },
            );
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(color: Colors.black26, spreadRadius: 2, blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon?.name?.toUpperCase() ?? "Pokemon",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "#${pokemon?.id?.toString()}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.05,
                  backgroundImage:
                      pokemon != null
                          ? NetworkImage(pokemon.sprites!.frontDefault!)
                          : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${pokemon?.moves?.length} Moves",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      _favoritePokemonsProvider.removeFavoritePokemon(
                        pokemonUrl,
                      );
                    },
                    child: const Icon(Icons.favorite, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
