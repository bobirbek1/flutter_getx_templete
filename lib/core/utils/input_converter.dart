

import 'package:dartz/dartz.dart';
import 'package:flutter_template/app/app_constants.dart';
import 'package:flutter_template/core/error/failure.dart';


class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure(message: INVALID_INPUT_FAILURE_MESSAGE));
    }
  }
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure({String? message}) : super(message: message);
}
