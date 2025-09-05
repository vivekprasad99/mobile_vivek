import 'package:core/config/error/failure.dart';

class RefundFailure extends Failure {
  @override
  bool operator ==(Object other) => other is RefundFailure;

  @override
  int get hashCode => 0;
}
