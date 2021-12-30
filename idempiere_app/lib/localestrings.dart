import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        //ENGLISH LANGUAGE
        'en_US': {
          'hello': 'Hello World',
          'message': 'Welcome to Proto Coders Point',
          'title': 'Flutter Language - Localization',
          'sub': 'Subscribe Now',
          'changelang': 'Language   '
        },
        //HINDI LANGUAGE
        'it_IT': {
          'hello': 'Ciao mondo',
          'message': 'Welcome to Proto Coders Point',
          'title': 'Flutter Language - Localization',
          'sub': 'Subscribe Now',
          'changelang': 'Lingua   '
        },
      };
}
