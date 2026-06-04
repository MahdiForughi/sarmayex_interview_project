import '../entities/app_setting_model.dart';

abstract class AppSettingRepository {
  Future<void> save(AppSettingModel appSettingModel);

  AppSettingModel? load();
}
