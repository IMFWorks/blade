class Logger {
  static void log(String msg) {
    assert(() {
      print('blade#$msg');
      return true;
    }());
  }

  static void logObject(Object msg) {
    assert(() {
      print('blade: $msg');
      return true;
    }());
  }


  static void error(String msg) {
    print('blade#$msg');
  }
}
