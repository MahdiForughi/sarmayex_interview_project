import 'package:flutter/material.dart';

import '../../domain/data_sources/app_setting_data_source.dart';
import '../../domain/entities/app_setting_model.dart';
import '../../domain/repositories/app_setting_repository.dart';

class AppSettingRepositoryImpl extends AppSettingRepository {
  final AppSettingDataSource localSource;

  AppSettingRepositoryImpl(this.localSource);

  @override
  Future<void> save(AppSettingModel appSettingModel) {
    return localSource.save(appSettingModel);
  }

  @override
  AppSettingModel? load() {
    final (themeModeIndex, languageCode) = localSource.load();
    final parsedThemeModeIndex = int.tryParse(themeModeIndex.toString());

    if (parsedThemeModeIndex == null || languageCode == null) return null;
    return AppSettingModel(themeMode: ThemeMode.values[parsedThemeModeIndex], locale: Locale(languageCode));
  }
}
