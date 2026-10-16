import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'shared_pref_utils.dart';

class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(_savedLocale());

  static const List<String> supportedCodes = ['ar', 'en'];

  static Locale? _savedLocale() {
    final code = SharedPrefUtils.languageCode;
    return code != null ? Locale(code) : null;
  }

  Future<void> changeLanguage(String code) async {
    if (!supportedCodes.contains(code)) return;
    if (state?.languageCode == code) return;

    emit(Locale(code));
    await SharedPrefUtils.saveLanguageCode(code);
  }
}
