import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HTTPService {
  HTTPService();

  final _dio = Dio();

  Future<Response?> get(String url) async {
    try {
      Response response = await _dio.get(url);
      return response;
    } catch (e) {
      debugPrint("error: $e");
    }
    return null;
  }
}
