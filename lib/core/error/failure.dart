import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;
  final String? message;

  const Failure({this.properties = const [],required this.message});

  @override
  List<Object?> get props => properties..add(message);
}

class ServerUnknownFailure extends Failure {
  const ServerUnknownFailure({String? message}) : super(message: message);
}

class ServerTimeOutFailure extends Failure {

  const ServerTimeOutFailure({String? message}) : super(message: message);
}

class ServerUnAuthorizeFailure extends Failure {

  const ServerUnAuthorizeFailure({String? message}) : super(message: message);
}

class ServerNotFoundFailure extends Failure {

  const ServerNotFoundFailure({String? message}) : super(message: message);
}

class ServerCancelFailure extends Failure {

  const ServerCancelFailure({String? message}) : super(message: message);
}

class CacheFailure extends Failure {

  const CacheFailure({String? message}) : super(message:message);

}
