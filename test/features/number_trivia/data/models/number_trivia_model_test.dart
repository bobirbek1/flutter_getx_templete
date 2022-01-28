import 'dart:convert';

import 'package:flutter_template/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(text: "Test", number: 1);

  group("fromJson", () {
    test("should be a subclass of NumberTrivia entity", () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture("trivia.json"));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });

    test(
      'should return a valid model when the JSON number is regarded as a double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group("toJson", () {
    test(
    'should return a JSON map containing the proper data',
    () async {
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      final expectedJsonMap = {
        "text": "Test",
        "number": 1,
      };
      expect(result, expectedJsonMap);
    },
  );
  });
}
