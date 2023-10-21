import 'package:intl/intl.dart';

class DataUtils {
  // String to Won, 단위 변환용
  static final oCcy = NumberFormat("#,###", "Ko_KR");
  static String calcStringToWon(String priceString) {
    if (priceString == "무료나눔") return priceString;
    return "${oCcy.format(int.parse(priceString))}원";
  }
}