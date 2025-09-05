import 'package:core/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(ThemeData.light()) {
    on<ThemeChangedEvent>((event, emit) async {
      final bool hasDarkTheme = PrefUtils.isDarkTheme();
      if (hasDarkTheme) {
        emit(ThemeData.dark());
      } else {
        emit(ThemeData.light());
      }
    });

    on<ThemeSwitchEvent>((event, emit) {
      emit(PrefUtils.isDarkTheme() ? ThemeData.dark() : ThemeData.light());
    });
  }
}
