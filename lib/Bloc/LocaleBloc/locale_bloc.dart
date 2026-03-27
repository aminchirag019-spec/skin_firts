import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../Helper/sharedpref_helper.dart';
import 'locale_event.dart';
import 'locale_state.dart';


class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(Locale('en'))) {
  on<ChangeLocale>(_onChangeLocale);
  on<LoadStoredLocale>(_onLoadStoredLocale);
  }
    void _onChangeLocale(ChangeLocale event, Emitter<LocaleState> emit)
 async {
      await SharedPrefsHelper.setLanguage(event.locale.languageCode);
      emit(LocaleState(event.locale));
    }
}

   void _onLoadStoredLocale(LoadStoredLocale event, Emitter<LocaleState> emit)  async {
      final langCode = await SharedPrefsHelper.getLanguage();
      if (langCode != null) {
        emit(LocaleState(Locale(langCode)));
      }
    }
