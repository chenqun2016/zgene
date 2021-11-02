///时间格式转化
class TimeUtils {
  ///转化成时分秒
  static String formatDuration(Duration position) {
    final ms = position.inMilliseconds;

    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    final minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10
        ? '$hours'
        : hours == 0
            ? '00'
            : '0$hours';

    final minutesString = minutes >= 10
        ? '$minutes'
        : minutes == 0
            ? '00'
            : '0$minutes';

    final secondsString = seconds >= 10
        ? '$seconds'
        : seconds == 0
            ? '00'
            : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

    return formattedTime;
  }

  ///时间的展示
  static String getTimeText(int time) {
    //获取当前时间
    var now = new DateTime.now();
    //以前时间格式化
    var old = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    //两个时间差时间差
    var difference = now.difference(old);
    if (difference.inDays > 1) {
      return (difference.inDays).toString() + '天前';
    } else if (difference.inDays == 1) {
      return '昨天'.toString();
    } else if (difference.inHours >= 1 && difference.inHours < 24) {
      return (difference.inHours).toString() + '小时前';
    } else if (difference.inMinutes > 5 && difference.inMinutes < 60) {
      return (difference.inMinutes).toString() + '分钟前';
    } else if (difference.inMinutes <= 5) {
      return '刚刚';
    }
  }

  ///图片淡出时间
  static fadeInDuration() {
    return Duration(milliseconds: 100);
  }

  ///图片载入时间
  static fadeOutDuration() {
    return Duration(milliseconds: 100);
  }

  ///判断按钮是否可以点击
  static bool intervalClick(var lastTime, int needTime) {
    // 防重复提交
    if (lastTime == null ||
        DateTime.now().difference(lastTime) > Duration(seconds: needTime)) {
      return true;
    } else {
      return false;
    }
  }

  //时间格式化，根据总秒数转换为对应的 hh:mm:ss 格式
  static String constructTime(int seconds) {
    int day = seconds ~/ 3600 ~/ 24;
    int hour = (seconds - (day * 24 * 3600)) ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    if (day != 0) {
      // return '$day天$hour小时$minute分$second秒';
      return formatTime(day) +
          '天' +
          formatTime(hour) +
          "小时" +
          formatTime(minute) +
          "分" +
          formatTime(second) +
          "秒";
    } else if (hour != 0) {
      // return '00天$hour小时$minute分$second秒';
      return '00天' +
          formatTime(hour) +
          "小时" +
          formatTime(minute) +
          "分" +
          formatTime(second) +
          "秒";
    } else if (minute != 0) {
      // return '00天00小时$minute分$second秒';
      return "00天00小时" + formatTime(minute) + "分" + formatTime(second) + "秒";
    } else if (second != 0) {
      // return '00天00小时00分$second秒';
      return "00天00小时00分" + formatTime(second) + "秒";
    } else {
      return '';
    }
  }

  static String constructTime_day(int seconds) {
    int day = seconds ~/ 3600 ~/ 24;
    int hour = (seconds - (day * 24 * 3600)) ~/ 3600;

    if (day != 0) {
      return formatTime(day);
    } else {
      return '00';
    }
  }

  static String constructTime_hour(int seconds) {
    int day = seconds ~/ 3600 ~/ 24;
    int hour = (seconds - (day * 24 * 3600)) ~/ 3600;

    if (hour != 0) {
      return formatTime(hour);
    } else {
      return '00';
    }
  }

  static String constructTime_minute(int seconds) {
    int minute = seconds % 3600 ~/ 60;
    if (minute != 0) {
      return formatTime(minute);
    } else {
      return '00';
    }
  }

  static String constructTime_second(int seconds) {
    int second = seconds % 60;
    if (second != 0) {
      return formatTime(second);
    } else {
      return '00';
    }
  }

  //数字格式化，将 0~9 的时间转换为 00~09
  static String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }
}
