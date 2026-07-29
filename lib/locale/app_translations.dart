import 'package:get/get.dart';

import 'app_en.dart';
import 'app_sw.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': appEn,
        'sw': appSw,
      };
}
