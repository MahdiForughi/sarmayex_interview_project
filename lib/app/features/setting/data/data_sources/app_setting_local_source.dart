import 'package:sarmayex_interview_project/app/core/abstracts/base_key_value_store.dart';
import 'package:sarmayex_interview_project/app/core/constants/storage_keys.dart';

import '../../domain/data_sources/app_setting_data_source.dart';
import '../../domain/entities/app_setting_model.dart';

class AppSettingLocalSource extends AppSettingDataSource {
  final BaseKeyValueStore _storage;

  AppSettingLocalSource(this._storage);

  @override
  (String? themeModeIndex, String? languageCode) load() {
    final themeModeIndex = _storage.get(StorageKeys.themeMode);
    final languageCode = _storage.get(StorageKeys.locale);

    return (themeModeIndex, languageCode);
  }

  @override
  Future<void> save(AppSettingModel appSettingModel) async {
    await _storage.write(StorageKeys.themeMode, appSettingModel.themeMode.index.toString());
    await _storage.write(StorageKeys.locale, appSettingModel.locale.languageCode);
  }
}
