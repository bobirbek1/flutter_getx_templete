import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/error/exceptions.dart';
import 'package:flutter_template/core/error/failure.dart';
import 'package:flutter_template/core/platform/network_info.dart';
import 'package:flutter_template/features/number_trivia/data/datasources/number_trivia_local_data_surce.dart';
import 'package:flutter_template/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_template/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_template/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';



@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
void main() {
  NumberTriviaRepositoryImpl? repositoryImpl;
  MockNumberTriviaLocalDataSource? mockLocalDataSource;
  MockNumberTriviaRemoteDataSource? mockRemoteDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource!,
      localDataSource: mockLocalDataSource!,
      networkInfo: mockNetworkInfo!,
    );
  });

  void runTestsOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  final tNumber = 1;
  final tNumberTriviaModel = NumberTriviaModel(text: "Test", number: 1);
  final tNumberTrivia = tNumberTriviaModel;

  group("getConcreteNumberTrivia", () {

    setUp(() {
      when(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
    });
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImpl!.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo!.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repositoryImpl!.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
          "Should cache the data locally when the call to remote data source successful",
          () async {
        when(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        await repositoryImpl!.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTrivia));
      });

      test(
          "Should return server filure when the call to the remote data source is unsuccessful",
          () async {
        when(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerUnknownException());

        final result = await repositoryImpl!.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerUnknownFailure())));
      });
    });
    runTestsOffline(() {
      test(
          "should return last locally cached data when the cached data is present",
          () async {
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repositoryImpl!.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should return CacheFailure when there is no cached data present",
          () async {
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repositoryImpl!.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group("getRandomTrivia", () {
    setUp(() {
      when(mockRemoteDataSource!.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
    });
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImpl!.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo!.isConnected);
    });
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource!.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repositoryImpl!.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource!.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
          "Should cache the data locally when the call to remote data source successful",
          () async {
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        await repositoryImpl!.getRandomNumberTrivia();

        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTrivia));
      });

      test(
          "Should return server filure when the call to the remote data source is unsuccessful",
          () async {
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenThrow(ServerUnknownException());

        final result = await repositoryImpl!.getRandomNumberTrivia();

        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerUnknownFailure())));
      });
    });
    runTestsOffline(() {
      test(
          "should return last locally cached data when the cached data is present",
          () async {
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repositoryImpl!.getRandomNumberTrivia();
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should return CacheFailure when there is no cached data present",
          () async {
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repositoryImpl!.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
