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
import 'package:flutter_template/features/number_trivia/presentation/getx/number_trivia_controller.dart';
import 'package:get/instance_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
  Get.put(hiveBox, permanent: true);
  Get.put(Dio(options), permanent: true);
  Get.put(InternetConnectionChecker(), permanent: true);
  Get.put(Connectivity(), permanent: true);
  Get.put<NetworkInfo>(
      NetworkInfoImpl(connectivity: Get.find(), dataChecker: Get.find()),
      permanent: true);

  // data sources
  Get.lazyPut<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(dioClient: Get.find()));
  Get.lazyPut<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(box: Get.find()));

  // repository
  Get.lazyPut<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
      remoteDataSource: Get.find(),
      localDataSource: Get.find(),
      networkInfo: Get.find()));

  // use cases
  Get.lazyPut(() => GetConcreteNumberTrivia(repository: Get.find()));
  Get.lazyPut(() => GetRandomNumberTrivia(repository: Get.find()));

  // core
  Get.lazyPut(() => InputConverter());

  // GetX Controller
  Get.lazyPut(() => NumberTriviaController(Get.find(), Get.find(), Get.find()));
 
}
