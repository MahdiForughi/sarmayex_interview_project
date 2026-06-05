import 'package:flutter/material.dart';
import 'package:sarmayex_interview_project/l10n/app_localizations.dart';

extension ContextUtils on BuildContext {
  AppLocalizations get localizations => AppLocalizations.of(this);

  ThemeData get theme => Theme.of(this);
}