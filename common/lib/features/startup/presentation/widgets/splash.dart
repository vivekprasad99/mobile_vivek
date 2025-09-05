import 'package:core/config/managers/device_manager.dart';
import 'package:core/config/resources/images.dart';
import 'package:core/features/presentation/bloc/theme/theme_bloc.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  final DeviceManager deviceManager = DeviceManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            Center(
                child: (state == ThemeData.light())
                    ? SizedBox(
                        width: 250,
                        child: Image.asset(
                          Images.splashScreen,
                        ),
                      )
                    : SizedBox(
                        width: 250,
                        child: Image.asset(
                          Images.splashScreenDark,
                        ),
                      ),),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: FutureBuilder(
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Text(
                        snapshot.data ?? "",
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                future: di<DeviceManager>().getDisplayAppVersion(),
              ),
            ),
          ],),
        );
      },
    );
  }
}
