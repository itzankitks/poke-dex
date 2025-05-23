import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pika_dex/services/shared_prefs_database_service.dart';

final favoritePokemonsProvider =
    StateNotifierProvider<FavoritePokemonsProvider, List<String>>((ref) {
      return FavoritePokemonsProvider([]);
    });

class FavoritePokemonsProvider extends StateNotifier<List<String>> {
  final SharedPrefsDatabaseService _sharedPrefsDatabaseService =
      GetIt.instance.get<SharedPrefsDatabaseService>();

  static const String FAVORITE_POKEMON_LIST_KEY = 'FAVORITE_POKEMON_LIST_KEY';

  FavoritePokemonsProvider(super._state) {
    _setUp();
  }

  Future<void> _setUp() async {
    List<String>? result = await _sharedPrefsDatabaseService.getList(
      FAVORITE_POKEMON_LIST_KEY,
    );
    state = result ?? [];
  }

  void addFavoritePokemon(String url) {
    state = [...state, url];
    _sharedPrefsDatabaseService.saveList(FAVORITE_POKEMON_LIST_KEY, state);
  }

  void removeFavoritePokemon(String url) {
    state = state.where((e) => e != url).toList();
    _sharedPrefsDatabaseService.saveList(FAVORITE_POKEMON_LIST_KEY, state);
  }
}
