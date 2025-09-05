import 'dart:io' show Platform;
import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

class MapsUtils {
  static Uri _androidShareUri(double latitude, double longitude) {
    return Uri.https('www.google.com', '/maps/search/',
        {'api': '1', 'query': '$latitude,$longitude'});
  }

  static Uri _androidUri(double latitude, double longitude) {
    var query = '$latitude,$longitude';
    return Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
  }

  static Uri _iOSUri(double latitude, double longitude) {
    var params = {
      'll': '$latitude,$longitude',
    };
    return Uri.https('maps.apple.com', '/', params);
  }

  static Uri _createCoordinatesUri(double latitude, double longitude) {
    return Platform.isIOS
        ? _iOSUri(latitude, longitude)
        : _androidUri(latitude, longitude);
  }

  static Uri shareUri(double latitude, double longitude) {
    return Platform.isIOS
        ? _iOSUri(latitude, longitude)
        : _androidShareUri(latitude, longitude);
  }

  static Future<bool> launchCoordinates(double latitude, double longitude) {
    return launchUrl(_createCoordinatesUri(latitude, longitude));
  }

  static double haversineDistance({
    required ({double lat, double lon}) place1,
    required ({double lat, double lon}) place2,
  }) {
    var R = 6371e3; // metres
    var phi1 = (place1.lat * pi) / 180; // φ, λ in radians
    var phi2 = (place2.lat * pi) / 180;
    var deltaPhi = ((place2.lat - place1.lat) * pi) / 180;
    var deltaLambda = ((place2.lon - place1.lon) * pi) / 180;

    var a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);

    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // in metres
    return d / 1000; // in km
  }
}
