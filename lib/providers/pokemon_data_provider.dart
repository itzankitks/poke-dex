import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pika_dex/models/pokemon_model.dart';
import 'package:pika_dex/services/http_service.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>((
  ref,
  url,
) async {
  HTTPService _httpService = GetIt.instance.get<HTTPService>();
  Response? response = await _httpService.get(url);

  if (response != null && response.data != null) {
    return Pokemon.fromJson(response.data!);
  }

  return null;
});
