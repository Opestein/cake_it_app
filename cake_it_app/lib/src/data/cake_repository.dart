import 'dart:convert';

import 'package:cake_it_app/src/data/cake_api_client.dart';
import 'package:cake_it_app/src/models/cake.dart';

class CakeRepository {
  CakeRepository({CakeApiClient? apiClient})
      : _apiClient = apiClient ?? CakeApiClient();

  final CakeApiClient _apiClient;

  Future<List<Cake>> fetchCakes() async {
    final jsonString = await _apiClient.fetchCakesJson();

    final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(Cake.fromJson)
        .toList();
  }

  void dispose() {
    _apiClient.dispose();
  }
}
