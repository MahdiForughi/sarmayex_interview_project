import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarmayex_interview_project/app/features/market/presentation/bloc/market_bloc.dart';
import 'package:sarmayex_interview_project/app/features/order_book/presentation/bloc/order_book_bloc.dart';

import '../app/constants/consts.dart';
import '../l10n/app_localizations.dart';
import '../locator.dart';
import 'features/market/domain/repositories/market_repository.dart';
import 'features/setting/domain/entities/app_setting_model.dart';
import 'features/setting/presentation/cubit/app_setting_cubit.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingCubit, AppSettingModel>(
      builder: (context, setting) => MaterialApp.router(
        themeMode: setting.themeMode,
        locale: setting.locale,
        debugShowCheckedModeBanner: false,
        title: Consts.appName,
        routerConfig: AppRouter.router,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => MarketBloc(locator<MarketRepository>()),
              ),
              BlocProvider(
                create: (_) => OrderBookBloc(locator<MarketRepository>()),
              ),
            ],
            child: child!,
          );
        },
      ),
    );
  }
}
