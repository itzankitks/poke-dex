import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pika_dex/controllers/home_page_controller.dart';
import 'package:pika_dex/models/home_page_data_model.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
      return HomePageController(HomePageData.initial());
    });
