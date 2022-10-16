import 'package:intl/intl.dart';

class ComeInDateUtils {
  static DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  static DateTime? toDateTime(String dateStr) {
    return dateStr != '' ? dateFormat.parse(dateStr) : null;
  }

  static String toStr(DateTime? date) {
    if (date == null) {
      print('toStr Date is null');
    } else {
      print('toStr : ${date}');
    }

    return date == null ? '' : dateFormat.format(date);
  }

  static String toStrFormat(DateTime? date, String dateFormat) {
    print('toStrFormat : ${date}');

    return date == null ? '' : DateFormat(dateFormat).format(date);
  }
}
