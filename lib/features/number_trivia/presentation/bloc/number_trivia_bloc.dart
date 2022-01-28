// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/usecases/usecase.dart';
import 'package:flutter_template/core/utils/input_converter.dart';
import 'package:flutter_template/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_template/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_template/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      print("new event added");
      final inputEither =
          inputConverter.stringToUnsignedInt(event.numberString);

      await inputEither.fold((failure) {
        emit.call(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      }, (number) async {
        emit.call(Loading());
        final result = await getConcreteNumberTrivia.call(Params(number: number));
        result.fold(
            (failure) => emit.call(Error(message: failure.message ?? "")),
            (result) => emit.call(
              Loaded(trivia: result),
            ),
          );
        });
      });
    on<GetTriviaForRandomNumber>((event, emit) async {
      emit.call(Loading());
      final result = await getRandomNumberTrivia.call(NoParams());
      result.fold(
          (failure) => emit.call(Error(message: failure.message ?? "")),
          (result) => emit.call(
            Loaded(trivia: result),
          ),
        );
  
    });
  }

  @override
  void onEvent(NumberTriviaEvent event) {
    super.onEvent(event);
  }
}
