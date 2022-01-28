import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_template/app/app_constants.dart';
import 'package:flutter_template/core/platform/network_info.dart';
import 'package:flutter_template/core/utils/input_converter.dart';
import 'package:flutter_template/features/number_trivia/data/datasources/number_trivia_local_data_surce.dart';
import 'package:flutter_template/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_template/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_template/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_template/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_template/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_template/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Dependency injection file

final sl = GetIt.instance;

Future<void> init() async {
  final options = BaseOptions(
    baseUrl: BASE_URL,
    connectTimeout: CONNECT_TIME_OUT,
    receiveTimeout: RECEIVE_TIME_OUT,
    sendTimeout: SEND_TIME_OUT,
    contentType: Headers.jsonContentType,
  );

  await Hive.initFlutter();
  final Box<dynamic> hiveBox = await Hive.openBox("myBox");

  // // External
  sl.registerLazySingleton(() => hiveBox);
  sl.registerLazySingleton(() => Dio(options));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
        connectivity: sl(),
        dataChecker: sl(),
      ));

  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        getConcreteNumberTrivia: sl(),
        getRandomNumberTrivia: sl(),
        inputConverter: sl(),
      ));

  // use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(repository: sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(repository: sl()));

  // data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(
            dioClient: sl(),
          ));

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(box: sl()),
  );

  // core
  sl.registerLazySingleton(() => InputConverter());

  // repository
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));
}
