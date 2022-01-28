import 'dart:convert';

import 'package:flutter_template/core/error/exceptions.dart';
import 'package:flutter_template/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:hive/hive.dart';

const String CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl extends NumberTriviaLocalDataSource {
  final Box<dynamic> box;

  NumberTriviaLocalDataSourceImpl({required this.box});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    return box.put(
        CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = box.get(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
