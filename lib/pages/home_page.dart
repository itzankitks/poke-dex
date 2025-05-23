import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pika_dex/controllers/home_page_controller.dart';
import 'package:pika_dex/models/home_page_data_model.dart';
import 'package:pika_dex/models/pokemon_model.dart';
import 'package:pika_dex/providers/favorite_pokemon_provider.dart';
import 'package:pika_dex/providers/home_page_controller_provider.dart';
import 'package:pika_dex/widgets/pokemon_card.dart';
import 'package:pika_dex/widgets/pokemon_list_tile.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonListScrollController = ScrollController();

  late HomePageController _homePageController;
  late HomePageData _homePageData;

  late List<String> _favoritePokemonsList;

  @override
  void initState() {
    super.initState();
    _allPokemonListScrollController.addListener(_scrollListner);
  }

  @override
  void dispose() {
    _allPokemonListScrollController.removeListener(_scrollListner);
    _allPokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListner() {
    if (_allPokemonListScrollController.offset >=
            _allPokemonListScrollController.position.maxScrollExtent * 1 &&
        !_allPokemonListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favoritePokemonsList = ref.watch(favoritePokemonsProvider);

    return _homePageData.data == null
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(body: _buildUI(context));
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favoritePokemonsGridView(context),
              _allPokemonsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _favoritePokemonsGridView(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Favorite Pokemons", style: TextStyle(fontSize: 25)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favoritePokemonsList.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.48,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                      itemCount: _favoritePokemonsList.length,
                      itemBuilder: (context, index) {
                        String favPokemonUrl = _favoritePokemonsList[index];
                        return PokemonCard(pokemonUrl: favPokemonUrl);
                      },
                    ),
                  ),
                if (_favoritePokemonsList.isEmpty)
                  const Center(child: Text("No favorite pokemons yet.")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allPokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("All Pokemons", style: TextStyle(fontSize: 25)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              controller: _allPokemonListScrollController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult pokemon = _homePageData.data!.results![index];
                return PokemonListTile(pokemonUrl: pokemon.url!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
