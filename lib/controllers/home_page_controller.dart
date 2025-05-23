import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pika_dex/models/pokemon_model.dart';
import 'package:pika_dex/services/http_service.dart';
import '../models/home_page_data_model.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;

  late HTTPService _httpService;

  HomePageController(super._state) {
    _httpService = _getIt.get<HTTPService>();
    _setUp();
  }

  Future<void> _setUp() async {
    loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? response = await _httpService.get(
        'https://pokeapi.co/api/v2/pokemon?limit=20&offset=0',
      );
      if (response != null && response.data != null) {
        PokemonListData data = PokemonListData.fromJson(response.data);
        state = state.copyWith(data: data);
      }
    } else {
      if (state.data?.next != null) {
        Response? response = await _httpService.get(state.data!.next!);

        if (response != null && response.data != null) {
          PokemonListData data = PokemonListData.fromJson(response.data!);
          state = state.copyWith(
            data: data.copyWith(
              results: [...?state.data?.results, ...?data.results],
            ),
          );
        }
      }
    }
  }
}
