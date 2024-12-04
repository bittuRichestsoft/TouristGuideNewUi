import 'package:intl/intl.dart';

class CommonDateTimeFormats {
  static String dateFormat1(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

    return formattedDate; // Output: 29 Aug 2024
  }

  static String timeFormatLocal(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return formattedTime; // Output: 9:14 PM
  }
}
