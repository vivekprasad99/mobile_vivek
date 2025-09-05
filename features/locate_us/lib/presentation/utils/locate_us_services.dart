import 'dart:async';

import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/bottom_sheet/mf_bottom_sheet.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import '../../locate_us.dart';

class LocateUsServices {
  LocateUsServices._();

  static Completer<AndroidMapRenderer?>? _initializedRendererCompleter;

  static void trigger(BuildContext context) async {
    Future.delayed(Duration.zero, () {
      showLoaderDialog(context, getString(lblLoUsLoading));
    });
    final position = await determinePosition();
    Future.delayed(Duration.zero, () {
      Navigator.of(context, rootNavigator: true).pop();
    });
    if (context.mounted) {
      if (position == null) {
        context.pushNamed(Routes.locateUsSearch.name);
      } else {
        context.pushNamed(Routes.locateUsMap.name);
      }
    }
  }

  static void triggerFromDeny(BuildContext context) async {
    showLoaderDialog(context, getString(lblLoUsLoading));
    final position = await determinePosition();
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      if (position == null) {
        showMFFormBottomSheet(
          context,
          title: getString(msgLoUsLocationPermissionOff),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getString(msgLoUsEnableLocationForHassleFreeExp),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: MfCustomButton(
                  onPressed: () {
                    Geolocator.openLocationSettings();
                  },
                  text: getString(msgLoUsEnableLocation),
                  outlineBorderButton: true,
                ),
              ),
            ],
          ),
        );
      } else {
        final matches =
            GoRouter.of(context).routerDelegate.currentConfiguration.matches;
        if (matches.length == 3) {
          context.pop();
        } else {
          context.pushReplacementNamed(Routes.locateUsMap.name);
        }
      }
    }
  }

  /// Initializes map renderer to the `latest` renderer type for Android platform.
  static void init() {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
      _initializeMapRenderer();
    }
  }

  static Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, we cannot request permissions.
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<AndroidMapRenderer?> _initializeMapRenderer() async {
    if (_initializedRendererCompleter != null) {
      return _initializedRendererCompleter!.future;
    }

    final Completer<AndroidMapRenderer?> completer =
        Completer<AndroidMapRenderer?>();
    _initializedRendererCompleter = completer;

    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      unawaited(mapsImplementation
          .initializeWithRenderer(AndroidMapRenderer.latest)
          .then((AndroidMapRenderer initializedRenderer) =>
              completer.complete(initializedRenderer)));
    } else {
      completer.complete(null);
    }

    return completer.future;
  }
}
