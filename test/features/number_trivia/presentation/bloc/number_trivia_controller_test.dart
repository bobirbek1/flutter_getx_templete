import 'package:dartz/dartz.dart';
import 'package:flutter_template/app/app_constants.dart';
import 'package:flutter_template/core/utils/input_converter.dart';
import 'package:flutter_template/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_template/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_template/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_template/features/number_trivia/presentation/getx/number_trivia_controller.dart';
import 'package:flutter_template/features/number_trivia/presentation/getx/number_trivia_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_controller_test.mocks.dart';


@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaController controller;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    controller = NumberTriviaController(
      mockGetConcreteNumberTrivia,
      mockGetRandomNumberTrivia,
      mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(controller.nTState.value, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInt(any))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia.call(any)).thenAnswer((_) async => Right(tNumberTrivia));
        // act
        controller.getConcreteNumberTrivia(tNumberString);
        await untilCalled(mockInputConverter.stringToUnsignedInt(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInt(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInt(any))
            .thenReturn(Left(InvalidInputFailure(message: INVALID_INPUT_FAILURE_MESSAGE)));
        // assert later
        final expected = [
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(controller.nTState.stream, emitsInOrder(expected));
        // act
        controller.getConcreteNumberTrivia(tNumberString);
      },
    );
  });
}
