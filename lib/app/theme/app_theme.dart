import 'package:flutter/material.dart';
import 'package:sarmayex_interview_project/app/theme/app_colors.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: .light,
    colorSchemeSeed: AppColors.primary,
  );

  static final dark = ThemeData(
    brightness: .dark,
    colorSchemeSeed: AppColors.primaryDark,
  );
}
