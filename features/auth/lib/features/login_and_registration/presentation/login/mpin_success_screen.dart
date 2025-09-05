import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route.dart';

class MPINSuccessScreen extends StatefulWidget {
  const MPINSuccessScreen({super.key});

  @override
  State<MPINSuccessScreen> createState() => _MPINSuccessScreenState();
}

class _MPINSuccessScreenState extends State<MPINSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      context.goNamed(Routes.login.name, extra: <Profiles>[]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Center(
        child: Text(
          getString(msgMpinSuccess),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
