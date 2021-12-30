import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        //ENGLISH LANGUAGE
        'en_US': {
          'hello': 'Hello World',
          'changelang': 'Language   ',
          'Calendar': 'Calendar',
          'Dashborad': 'Dashboard'
        },
        //HINDI LANGUAGE
        'it_IT': {
          'hello': 'Ciao mondo',
          'changelang': 'Lingua   ',
          'Calendar': 'Calendario',
          'Dashboard': 'Cruscotto'
        },
      };
}
