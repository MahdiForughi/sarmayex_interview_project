import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarmayex_interview_project/locator.dart';

import '../../domain/entities/app_setting_model.dart';
import '../../domain/repositories/app_setting_repository.dart';

class AppSettingCubit extends Cubit<AppSettingModel> {
  AppSettingCubit(super.initialState);

  final _repository = locator<AppSettingRepository>();

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    final newState = state.copyWith(themeMode: themeMode);
    await _repository.save(newState);

    emit(newState);
  }

  Future<void> changeLocale(Locale locale) async {
    final newState = state.copyWith(locale: locale);
    await _repository.save(newState);

    emit(newState);
  }

  /// load from key-value storage.
  AppSettingModel? loadSettings() {
    final savedAppSettingModel = _repository.load();
    return savedAppSettingModel;
  }
}
