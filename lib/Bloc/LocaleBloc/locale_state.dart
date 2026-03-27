import 'dart:ui';

import 'package:equatable/equatable.dart';

class LocaleState extends Equatable {
  final Locale locale;
  const LocaleState(this.locale);

  LocaleState copyWith({
    Locale? locale
  }) {
    return LocaleState(
      locale ?? this.locale,
    );
  }
  @override
  List<Object?> get props => [locale];
}
