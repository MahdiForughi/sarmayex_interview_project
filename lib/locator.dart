import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/core/abstracts/base_key_value_store.dart';
import 'app/core/abstracts/base_sse_client.dart';
import 'app/core/network/http_sse_client.dart';
import 'app/core/storage/shared_preferences_helper.dart';
import 'app/features/market/data/data_sources/market_sse_source.dart';
import 'app/features/market/data/repositories/market_repository_impl.dart';
import 'app/features/market/domain/data_sources/market_data_source.dart';
import 'app/features/market/domain/repositories/market_repository.dart';
import 'app/features/setting/data/data_sources/app_setting_local_source.dart';
import 'app/features/setting/data/repositories/app_setting_repository_impl.dart';
import 'app/features/setting/domain/data_sources/app_setting_data_source.dart';
import 'app/features/setting/domain/repositories/app_setting_repository.dart';

final locator = GetIt.instance;

/// initializing global repositories
Future<void> initializeRepositories() async {
  /// register [key-value] storage. we don't register it lazy because we need it immediately at start time to
  /// load [AppSettingModel] user selected before, if any.
  final storage = await SharedPreferences.getInstance();
  locator.registerSingleton<BaseKeyValueStore>(SharedPreferencesHelper(storage));

  /// lazy register SseClient
  locator.registerLazySingleton<BaseSseClient>(() => HttpSseClient());
  // locator.registerLazySingleton<BaseSseClient>(() => DioSseClient()); /// the Dio has issue with sse on web platform

  // AppSetting Repository
  locator.registerSingleton<AppSettingDataSource>(AppSettingLocalSource(locator()));
  locator.registerSingleton<AppSettingRepository>(AppSettingRepositoryImpl(locator()));

  // Market Repository
  locator.registerLazySingleton<MarketDataSource>(() => MarketSseSource(locator<BaseSseClient>()));
  locator.registerLazySingleton<MarketRepository>(() => MarketRepositoryImpl(locator<MarketDataSource>()));
}
