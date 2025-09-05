import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locate_us/presentation/screens/locate_us_search_screen.dart';

void main() {
  testWidgets("finds a google map in dashboard", (WidgetTester tester) async {
    const containerGoogleMap = Key("SizedBox GoogleMap");
    const googleMapKey = Key("Google Map");
    await tester.pumpWidget(const MaterialApp(
        home: LocateUsSearchScreen(
      isForDealer: false,
    )));
    expect(find.byType(GoogleMap), findsOneWidget);
    expect(find.byKey(googleMapKey), findsOneWidget);
    expect(find.byKey(containerGoogleMap), findsOneWidget);
  });
}
