import 'package:flutter/material.dart';

@immutable
class AppSettingModel {
  final ThemeMode themeMode;
  final Locale locale;

  const AppSettingModel({required this.themeMode, required this.locale});

  factory AppSettingModel.initial() => const AppSettingModel(themeMode: ThemeMode.system, locale: Locale('en'));

  AppSettingModel copyWith({ThemeMode? themeMode, Locale? locale}) {
    return AppSettingModel(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}
