import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/usecases/usecase.dart';
import 'package:flutter_template/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_template/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_template/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

void main() {
  GetRandomNumberTrivia? usecase;
  NumberTriviaRepository? repository;

  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository: repository!);
  });

  final tNumberTrivia = NumberTrivia(text: "test", number: 1);

  test("Should get trivia from repository.", () async {
    when(repository!.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    final result = await usecase!(NoParams());
    expect(result, Right(tNumberTrivia));
    verify(repository!.getRandomNumberTrivia());
    verifyNoMoreInteractions(repository);
  });
}
