import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_service.dart';

class SettingsCubit extends Cubit<ThemeMode> {
  SettingsCubit(this._settingsService) : super(ThemeMode.system);

  final SettingsService _settingsService;

  Future<void> loadSettings() async {
    final themeMode = await _settingsService.themeMode();
    emit(themeMode);
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == state) return;
    emit(newThemeMode);
    await _settingsService.updateThemeMode(newThemeMode);
  }
}
