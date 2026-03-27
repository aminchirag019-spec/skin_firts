import 'dart:ui';

import 'package:equatable/equatable.dart';

class LocaleEvent {
  const LocaleEvent();
}

class ChangeLocale extends LocaleEvent {
  final Locale locale;
  const ChangeLocale(this.locale);
}

class LoadStoredLocale extends LocaleEvent {}
