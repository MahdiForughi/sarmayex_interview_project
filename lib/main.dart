import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'app/app.dart';
import 'app/features/setting/domain/entities/app_setting_model.dart';
import 'app/features/setting/domain/repositories/app_setting_repository.dart';
import 'app/features/setting/presentation/cubit/app_setting_cubit.dart';
import 'locator.dart';

Future<void> main() async {
  /// ensure flutter engine is initialized so we can use native services like storage(shared_preferences)
  WidgetsFlutterBinding.ensureInitialized();

  /// set [ApplicationSupportedOrientation] to only [PortraitUp]
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Set [SystemStatusBar, SystemNavigationBar] backgroundColor transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  /// Route Manager Initialization
  GoRouter.optionURLReflectsImperativeAPIs = true; // enable updating url when using .push
  usePathUrlStrategy(); // removing the [#] sign in the url

  /// initializing global repositories
  await initializeRepositories();

  /// load [AppSetting] before app starts, so the app start with user stored settings.
  final appSettingModel = locator<AppSettingRepository>().load();

  runApp(
    BlocProvider(
      create: (_) => AppSettingCubit(appSettingModel ?? AppSettingModel.initial()),
      child: const App(),
    ),
  );
}
