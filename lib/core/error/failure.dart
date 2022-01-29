import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  var properties = [];
  final String? message;

  Failure({required this.message, List? props}) {
    if (props != null) properties.addAll(props);
    if(message != null) properties.add(message);
  }

  @override
  List<Object?> get props => properties;
}

class ServerUnknownFailure extends Failure {
  ServerUnknownFailure({String? message}) : super(message: message);
}

class ServerTimeOutFailure extends Failure {
   ServerTimeOutFailure({String? message}) : super(message: message);
}

class ServerUnAuthorizeFailure extends Failure {
  ServerUnAuthorizeFailure({String? message}) : super(message: message);
}

class ServerNotFoundFailure extends Failure {
  ServerNotFoundFailure({String? message}) : super(message: message);
}

class ServerCancelFailure extends Failure {
  ServerCancelFailure({String? message}) : super(message: message);
}

class CacheFailure extends Failure {
  CacheFailure({String? message}) : super(message: message);
}
