import 'package:intl/intl.dart';

String formatDate(String? inputDateString) {
  if (inputDateString == null) {
    return "";
  }
  DateTime inputDate = DateTime.parse(inputDateString);
  DateFormat dateFormat = DateFormat('EEEE d MMMM, yyyy');
  String formattedDate = dateFormat.format(inputDate);
  List<String> splitDate = formattedDate.split(" ");
  String weekday = splitDate[0];
  String dayNumber = splitDate[1];
  String month = splitDate[2];
  String year = splitDate[3];  
  switch (dayNumber.substring(dayNumber.length - 1)) {
    case "1":
      dayNumber = "${dayNumber}st";
      break;
    case "2":
      dayNumber = "${dayNumber}nd";
      break;
    case "3":
      dayNumber = "${dayNumber}rd";
      break;
    default:
      dayNumber = "${dayNumber}th";
      break;
  }  
  return "$dayNumber $month $year";
}

String formatTime(String? inputTimeString) {
  if (inputTimeString == null) {
    return "";
  }
  DateTime dateTime = DateTime.parse('0000-00-00 $inputTimeString');
  DateFormat timeFormat = DateFormat('h:mm a');
  return timeFormat.format(dateTime);
}