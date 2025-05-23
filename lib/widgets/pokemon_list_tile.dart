import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pika_dex/models/pokemon_model.dart';
import 'package:pika_dex/providers/favorite_pokemon_provider.dart';
import 'package:pika_dex/providers/pokemon_data_provider.dart';
import 'package:pika_dex/widgets/pokemon_stats_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;

  late FavoritePokemonsProvider _favoritePokemonsProvider;
  late List<String> _favoritePokemonsList;

  PokemonListTile({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);
    _favoritePokemonsList = ref.watch(favoritePokemonsProvider);

    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));

    return pokemon.when(
      data: (data) {
        return _pokemonListTile(context, data, false);
      },
      error: (error, stackTrace) {
        return Text("Error: $error");
      },
      loading: () {
        return _pokemonListTile(context, null, true);
      },
    );
  }

  Widget _pokemonListTile(
    BuildContext context,
    Pokemon? pokemon,
    bool isLoading,
  ) {
    return Skeletonizer(
      enabled: isLoading,
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
        child: ListTile(
          leading:
              pokemon != null
                  ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      pokemon.sprites!.frontDefault!,
                    ),
                  )
                  : CircleAvatar(),
          title: Text(
            pokemon != null
                ? pokemon.name!.toUpperCase()
                : "Loading name for Pokemon.",
          ),
          subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} moves"),
          trailing: IconButton(
            onPressed: () {
              if (_favoritePokemonsList.contains(pokemonUrl)) {
                _favoritePokemonsProvider.removeFavoritePokemon(pokemonUrl);
              } else {
                _favoritePokemonsProvider.addFavoritePokemon(pokemonUrl);
              }
            },
            icon: Icon(
              _favoritePokemonsList.contains(pokemonUrl)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
