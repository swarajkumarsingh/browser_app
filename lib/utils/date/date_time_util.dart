import 'package:intl/intl.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

/// Get the date in MMM dd, yyyy format.
String getDateInyMMMdFormat(DateTime dateTime) {
  final String formattedDate = DateFormat.yMMMd().format(dateTime);

  return formattedDate;
}

/// Get the time in hh:mm a format.
String getTimeInhhmmaFormat(DateTime dateTime) {
  final String formattedTime = DateFormat('hh:mm a').format(dateTime);

  return formattedTime;
}

DateTime timeNow() {
  return DateTime.now();
}

String convertTimeToString(DateTime dateTime) {
  return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
}

String greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime other) {
    final date = this;

    return date.year == other.year &&
        date.month == other.month &&
        date.day == other.day;
  }

  bool isSameMonth(DateTime other) {
    final date = this;
    return date.year == other.year && date.month == other.month;
  }

  int compareOnlyDate(DateTime other) {
    final date = this;
    final first = DateTime(other.year, other.month, other.day);
    final second = DateTime(date.year, date.month, date.day);
    return second.compareTo(first);
  }

  int compareOnlyYearAndMonth(DateTime other) {
    final date = this;
    final first = DateTime(other.year, other.month);
    final second = DateTime(date.year, date.month);
    return second.compareTo(first);
  }

  /// only pass year and month in date time format
  /// for eg. DateTime(2021,03)
  int diffInMonths(DateTime end) {
    final date = this;
    return (date.difference(end).inDays / 30.417).abs().toInt() + 1;
  }

  double get getDifferenceInYears {
    return (DateTime.now().diffInMonths(this) / 12);
  }

  int get daysInMonth {
    final date = this;

    return DateTime(date.year, date.month + 1, 0).day;
  }

  DateTime get lastDayOfMonth =>
      month < 12 ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);

  DateTime get findFirstDateOfTheWeek => subtract(Duration(days: weekday - 1));

  DateTime get findLastDateOfTheWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday));

  String get timeLeft {
    final endDate = this;
    final startDate = DateTime.now();

    final diffInYrs = endDate.year - startDate.year;
    final diffInMonths = endDate.month - startDate.month;

    final totalMonth = (12 * diffInYrs + diffInMonths);
    final nearEndDate = startDate;
    final totalDays = endDate.difference(nearEndDate).inDays;

    if (totalDays.isNegative) {
      return '';
    }
    final years = totalMonth ~/ 12;
    final months = totalMonth % 12;
    final weeks = totalDays ~/ 7;
    final days = totalDays % 7;

    if (totalDays > 1 && totalDays < 31) {
      return days == 1 ? 'A day left' : '$days days left';
    }
    if (years >= 1) {
      return years == 1 ? 'A year left' : '$years years left';
    }
    if (months >= 1) {
      return months == 1 ? 'A month left' : '$months months left';
    }
    if (weeks >= 1) {
      return weeks == 1 ? 'A week left' : '$weeks weeks left';
    }
    if (days >= 1) {
      return days == 1 ? 'A day left' : '$days days left';
    }
    return '';
  }

  String get exactDaysLeft {
    final days = difference(DateTime.now()).inDays;
    if (days >= 1) {
      return days == 1 ? 'a day' : '$days days';
    }
    return '';
  }

  bool get isToday {
    final today = DateTime.now();
    return isSameDate(today);
  }

  bool get isYesterday {
    final yDay = DateTime.now().subtract(const Duration(days: 1));
    return isSameDate(yDay);
  }

  bool get isLessThanMinute => DateTime.now().difference(this).inMinutes == 0;

  String get humanizeDays {
    final date2 = DateTime.now();

    final elapsed = millisecondsSinceEpoch - date2.millisecondsSinceEpoch;

    final totalDays = difference(date2).inDays;

    if (totalDays.isNegative) {
      return '';
    }

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result;
    if (seconds < 90) {
      result = '1 minute';
    } else if (minutes < 45) {
      result = '${minutes.round()} minutes';
    } else if (minutes < 90) {
      result = '1 hour';
    } else if (hours < 24) {
      result = '${hours.round()} hours';
    } else if (hours < 48) {
      result = '1 day';
    } else if (days < 30) {
      result = '${days.round()} days';
    } else if (days < 60) {
      result = '1 month';
    } else if (days < 365) {
      result = '${months.round()} months';
    } else if (years < 2) {
      result = '1 year';
    } else {
      result = '${years.round()} years';
    }
    return result;
  }

  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return 'just now';
  }

  int get customWeekday {
    switch (weekday) {
      case DateTime.sunday:
        return 0;
      case DateTime.monday:
        return 1;
      case DateTime.tuesday:
        return 2;
      case DateTime.wednesday:
        return 3;
      case DateTime.thursday:
        return 4;
      case DateTime.friday:
        return 5;
      case DateTime.saturday:
        return 6;
      default:
        return weekday;
    }
  }

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  DateTime get toCustomDate {
    return DateTime(year, month);
  }

  DateTime get toOnlyDate {
    return DateTime(year, month, day);
  }
}
