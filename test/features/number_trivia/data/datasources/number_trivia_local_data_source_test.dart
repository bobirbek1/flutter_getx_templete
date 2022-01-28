

import 'dart:convert';

import 'package:flutter_template/core/error/exceptions.dart';
import 'package:flutter_template/features/number_trivia/data/datasources/number_trivia_local_data_surce.dart';
import 'package:flutter_template/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  late Box<dynamic> mockBox;
  late NumberTriviaLocalDataSourceImpl localDataSource;

  setUp(() {
    mockBox = MockBox();
    localDataSource =
        NumberTriviaLocalDataSourceImpl(box: mockBox);
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        "should return NumberTrivia from SharedPreferences when there is one in the cache",
        () async {
      when(mockBox.get(CACHED_NUMBER_TRIVIA))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await localDataSource.getLastNumberTrivia();

      verify(mockBox.get(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });
    test("should throw a CacheException when there is not a cached value", () {
      when(mockBox.get(CACHED_NUMBER_TRIVIA)).thenReturn(null);

      final call = localDataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');

      test(
        'should call SharedPreferences to cache the data',
        () async {
          // assert
          final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
          // act
          when(mockBox.put(
              CACHED_NUMBER_TRIVIA, expectedJsonString)).thenAnswer((_) async => true);

              localDataSource.cacheNumberTrivia(tNumberTriviaModel);

          verify(mockBox.put(
            CACHED_NUMBER_TRIVIA,
            expectedJsonString,
          ));
        },
      );
  });
}

