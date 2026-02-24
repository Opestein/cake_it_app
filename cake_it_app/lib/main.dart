import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/config/app_config.dart';
import 'src/data/cake_repository.dart';

void main() {
  final cakeRepository = CakeRepository(baseUrl: AppConfig.baseUrl);

  runApp(MyApp(cakeRepository: cakeRepository));
}
