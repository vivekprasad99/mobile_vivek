abstract class AppRouteState {}

class RouteInitState extends AppRouteState {}

class AppRouteHomePageNavigation extends AppRouteState {
  final String pathFrom;
  AppRouteHomePageNavigation({required this.pathFrom});
}
