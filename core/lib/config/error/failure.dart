abstract class Failure {
  /// ignore: avoid_unused_constructor_parameters
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  final String? message;
  final String? statusCode;

  const ServerFailure(this.message,{this.statusCode});

  @override
  bool operator ==(Object other) =>
      other is ServerFailure && other.message == message && other.statusCode==statusCode;

  @override
  int get hashCode => message.hashCode;
}

class NoDataFailure extends Failure {
  @override
  bool operator ==(Object other) => other is NoDataFailure;

  @override
  int get hashCode => 0;
}

class CacheFailure extends Failure {
  @override
  bool operator ==(Object other) => other is CacheFailure;

  @override
  int get hashCode => 0;
}
