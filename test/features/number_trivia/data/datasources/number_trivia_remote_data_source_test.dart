import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_template/core/error/exceptions.dart';
import 'package:flutter_template/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_template/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockDio dioClient;

  setUp(() {
    dioClient = MockDio();
    dataSource = NumberTriviaRemoteDataSourceImpl(dioClient: dioClient);
  });

  final tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

  void setUpMockDioClientSuccess200(String url) {
    when(dioClient.get(url))
        .thenAnswer((_) async => Response<String>(
              requestOptions: RequestOptions(
                path: url,
              ),
              data: fixture('trivia.json'),
              statusCode: 200,
            ));
  }

  void setUpMockDioClientFailure404(String url) {
    when(dioClient.get(url)).thenThrow(DioError(
        requestOptions: RequestOptions(path: url),
        response: Response(
          requestOptions:
              RequestOptions(path: url),
          statusCode: 404,
        )));
  }

  group("getConcreteNumberTrivia", () {
    test(
        "should preform a GET request on a URL with number being the endpoint and with application/json header",
        () async {
      setUpMockDioClientSuccess200('http://numbersapi.com/$tNumber');
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      verify(dioClient.get('http://numbersapi.com/$tNumber'));
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        "should throw a ServerException when the response code is 404 or other",
        () async {
      setUpMockDioClientFailure404('http://numbersapi.com/$tNumber');
      final call = dataSource.getConcreteNumberTrivia;

      expect(() async => await call(tNumber),
          throwsA(const TypeMatcher<DioError>()));
    });
  });

  group("getRandomNumberTrivia", () {
    test(
        "should preform a GET request on a URL with number being the endpoint and with application/json header",
        () async {
      setUpMockDioClientSuccess200('http://numbersapi.com/random');
      final result = await dataSource.getRandomNumberTrivia();

      verify(dioClient.get('http://numbersapi.com/random'));
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        "should throw a ServerException when the response code is 404 or other",
        () async {
      setUpMockDioClientFailure404('http://numbersapi.com/random');
      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<DioError>()));
    });
  });
}
