import 'package:bloc_test/local_storage/hive/hive_class.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:intl/intl.dart';

class AppFunctions {
  String timeAgo({required String dateTime}) {
    var inMin = DateTime.now().difference(DateTime.parse(dateTime)).inMinutes;
    var inhr = DateTime.now().difference(DateTime.parse(dateTime)).inHours;
    var inDay = DateTime.now().difference(DateTime.parse(dateTime)).inDays;
    var minDiff = DateTime.now().difference(DateTime.parse(dateTime)).inMinutes;
    var hrDiff = DateTime.now().difference(DateTime.parse(dateTime)).inHours;
    var dayDiff = DateTime.now().difference(DateTime.parse(dateTime)).inDays;
    return inMin <= 59
        ? "$minDiff ${AppStrings.minAgo}"
        : inhr <= 23
            ? "$hrDiff ${AppStrings.hrAgo}"
            : inDay <= 1
                ? "$dayDiff ${AppStrings.dayAgo}"
                : "$dayDiff ${AppStrings.daysAgo}";
  }

  String? getUserId() {
    var hive = HiveClass().getBox(boxName: AppStr.userHiveBox);
    var userId = hive.getAt(0)?.id.toString();
    return userId;
  }

  String getDateTime({required String format, required String dateTime}) {
    return DateFormat(format).format(DateTime.parse(dateTime));
  }
}
