import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:app_launch_check/app_launch_check.dart';
import 'package:app_launch_check/app_clone_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  dynamic _appOriginality = 'Unknown';

  bool isAppCloned = false;
  final _appLaunchCheckPlugin = AppLaunchCheck();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _appLaunchCheckPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      checkAppValid();
    });
  }

  Future<void> checkAppValid() async {
    dynamic pluginResponse;
    try {
      pluginResponse = await AppCloneChecker.appOriginality(
          "com.mmsfl.plugings.app_launch_check_example",
          isWorkProfileAllowed: true);

      var resultData = ResultData.fromJson(pluginResponse);
      pluginResponse = resultData.message;
    } on PlatformException {
      pluginResponse = 'Failed to get result.';
    }

    if (!mounted) return;

    setState(() {
      _appOriginality = pluginResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('Running on Cloned : $_appOriginality\n')
            ],
          ),
        ),
      ),
    );
  }
}

class ResultData {
  ResultData({
    this.result,
    this.message,
  });

  ResultData.fromJson(dynamic json) {
    result = json['result'];
    message = json['message'];
  }

  String? result;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = result;
    map['message'] = message;
    return map;
  }
}
