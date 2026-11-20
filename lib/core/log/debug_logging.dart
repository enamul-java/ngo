

class DebugLogging {
  static const bool enable = true;
  static const String INFO = 'INFO Log: ';
  static const String ERR = 'ERROR Log: ';
  static const String message = 'DebugLogging';

  static void log(String message) {
    if (enable) {
      print('$INFO: ${DateTime.timestamp()} : $message');
    }
  }
  static void logError(String message) {
    if (enable) {
      print('$ERR: ${DateTime.timestamp()} : $message');
    }
  }
}