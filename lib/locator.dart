import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/abstracts/base_key_value_store.dart';
import 'app/features/setting/data/data_sources/app_setting_local_source.dart';
import 'app/features/setting/data/repositories/app_setting_repository_impl.dart';
import 'app/features/setting/domain/data_sources/app_setting_data_source.dart';
import 'app/features/setting/domain/repositories/app_setting_repository.dart';
import 'app/storage/shared_preferences_helper.dart';

final locator = GetIt.instance;

/// initializing global repositories
Future<void> initializeRepositories() async {
  /// register [key-value] storage. we don't register it lazy because we need it immediately at start time to
  /// [AppSettingModel] user selected before, if any.
  final storage = await SharedPreferences.getInstance();
  locator.registerSingleton<BaseKeyValueStore>(SharedPreferencesHelper(storage));

  // AppSettingModel
  locator.registerSingleton<AppSettingDataSource>(AppSettingLocalSource(locator()));
  locator.registerSingleton<AppSettingRepository>(AppSettingRepositoryImpl(locator()));
}
