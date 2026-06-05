import 'package:flutter/material.dart';
import 'package:sarmayex_interview_project/app/core/theme/app_colors.dart';

import '../../../gen/fonts.gen.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: .light,
    colorSchemeSeed: AppColors.primary,
    fontFamily: FontFamily.poppins,
  );

  static final dark = ThemeData(
    brightness: .dark,
    colorSchemeSeed: AppColors.primaryDark,
    fontFamily: FontFamily.poppins,
  );
}
