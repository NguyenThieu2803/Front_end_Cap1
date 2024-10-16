import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    // Load localization based on locale
    return SynchronousFuture<AppLocalizations>(AppLocalizations());
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get appTitle => Intl.message('Account Setup', name: 'appTitle');
  String get myAccount => Intl.message('My account', name: 'myAccount');
  String get accountSecurity =>
      Intl.message('Account & Security', name: 'accountSecurity');
  String get address => Intl.message('Address', name: 'address');
  String get bankAccount =>
      Intl.message('Bank Account/Card', name: 'bankAccount');
  String get notificationSettings =>
      Intl.message('Notification settings', name: 'notificationSettings');
  String get language => Intl.message('Language', name: 'language');
  String get supportCenter =>
      Intl.message('Support center', name: 'supportCenter');
  String get communityStandards =>
      Intl.message('Community standards', name: 'communityStandards');
  String get satisfactionSurvey =>
      Intl.message('Satisfied with FurniFit AR? Let\'s evaluate together.',
          name: 'satisfactionSurvey');
  String get logOut => Intl.message('Log Out', name: 'logOut');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
