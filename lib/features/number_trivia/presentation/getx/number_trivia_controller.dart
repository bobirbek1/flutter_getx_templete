import 'package:flutter_template/core/usecases/usecase.dart';
import 'package:flutter_template/core/utils/input_converter.dart';
import 'package:flutter_template/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_template/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_template/features/number_trivia/presentation/getx/number_trivia_state.dart';
import 'package:get/get.dart';

class NumberTriviaController extends GetxController {
  final InputConverter _inputConverter;
  final GetConcreteNumberTrivia _concreteNumberTrivia;
  final GetRandomNumberTrivia _randomNumberTrivia;

  NumberTriviaController(this._concreteNumberTrivia, this._randomNumberTrivia,
      this._inputConverter);

  Rx<NumberTriviaState> nTState = Rx(Empty());

  void getConcreteNumberTrivia(String number) async {
    final inputEither = _inputConverter.stringToUnsignedInt(number);

    await inputEither.fold(
      (failure) {
        print("error is ${failure.message}");
        nTState.value = Error(message: failure.message ?? "");
      },
      (number) async {
        nTState.value = Loading();
        final result = await _concreteNumberTrivia.call(Params(number: number));
        result.fold(
          (failure) {
            nTState.value = Error(message: failure.message ?? "");
          },
          (success) {
            nTState.value = Loaded(trivia: success);
          },
        );
      },
    );
  }

  void getRandomNumberTrivia() async {
    nTState.value = Loading();
    final result = await _randomNumberTrivia.call(NoParams());
    result.fold(
      (failure) {
        nTState.value = Error(message: failure.message ?? "");
      },
      (success) {
        nTState.value = Loaded(trivia: success);
      },
    );
  }
}
