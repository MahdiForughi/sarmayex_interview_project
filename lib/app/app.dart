import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/app_localizations.dart';
import '../locator.dart';
import 'core/constants/consts.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/market/domain/repositories/market_repository.dart';
import 'features/market/presentation/bloc/market_bloc.dart';
import 'features/market/presentation/bloc/sse_connection_bloc.dart';
import 'features/order_book/presentation/bloc/order_book_bloc.dart';
import 'features/setting/domain/entities/app_setting_model.dart';
import 'features/setting/presentation/cubit/app_setting_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ConnectionBloc(locator<MarketRepository>())..add(const ChangeMarket('USDT_IRT')),
        ),
        BlocProvider(
          create: (context) => MarketBloc(context.read<ConnectionBloc>()),
        ),
        BlocProvider(
          create: (context) => OrderBookBloc(context.read<ConnectionBloc>()),
        ),
      ],
      child: BlocBuilder<AppSettingCubit, AppSettingModel>(
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
        ),
      ),
    );
  }
}
