part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  final List property;

  const NumberTriviaState({this.property = const []});

  @override
  List<Object?> get props => property;
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({required this.trivia}) : super(property: [trivia]);
}

class Error extends NumberTriviaState {
  final String message;

  Error({required this.message}) : super(property: [message]);

  
}
