import '../entities/app_setting_model.dart';

abstract class AppSettingDataSource {
  (String? themeModeIndex, String? languageCode) load();

  Future<void> save(AppSettingModel appSettingModel);
}
