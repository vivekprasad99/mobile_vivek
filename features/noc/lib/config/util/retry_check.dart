class RetryCheck {
  static int _attempts = 0;
  static void incrementAttempt() {
    _attempts = _attempts + 1;
  }

  static bool canRetry() {
    return _attempts < 2;
  }
}
