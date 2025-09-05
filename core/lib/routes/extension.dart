
import 'package:go_router/go_router.dart';
const String successNavigation = 'success';
extension GoRouterExtension on GoRouter {
  // Navigate back to a specific route
  void popUntilPath(String ancestorPath) {
    while (routerDelegate.currentConfiguration.matches.last.matchedLocation !=
        ancestorPath) {
      if (!canPop()) {
        return;
      }
      pop(successNavigation);
    }
  }
}