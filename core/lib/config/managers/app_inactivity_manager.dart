import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

class AppInactivityManager {
  final Duration duration;

  AppInactivityManager({
    required this.duration,
  });

  int _seconds = 0;
  Timer? _timer;
  bool _isRunning = false;
  bool _isInitialized = false;
  late VoidCallback _handleTimeOutCallback;
  final bool _enableLog = false;

  void initialize({required VoidCallback onTimeout}) {
    if(_enableLog) log('initialize.', name: "AppInactivityManager");
    _handleTimeOutCallback = onTimeout;
    _isInitialized = true;
    //_resetTimer();
  }

  void reset(){
    if(_enableLog) log('reset.', name: "AppInactivityManager");
    _resetTimer(startTimer: false);
    _isInitialized = false;
  }

  void _startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _seconds++;
        if(_enableLog) log('$_seconds', name: "AppInactivityManager");
        if (_seconds == duration.inSeconds) {
          if(_enableLog) log('_handleTimeOutCallback.', name: "AppInactivityManager");
          _handleTimeOutCallback();
          _timer?.cancel();
        }
      },
    );
  }

  void _resetTimer({bool startTimer = true}) {
    if(!_isInitialized) return;
    _isRunning = false;
    _timer?.cancel();
    _seconds = 0;
    if (startTimer) _startTimer();
  }

  void onUserInteraction([PointerEvent? event]) => _resetTimer();

  void dispose() {
    if(_enableLog) log('dispose.', name: "AppInactivityManager");
    _timer?.cancel();
  }
}
