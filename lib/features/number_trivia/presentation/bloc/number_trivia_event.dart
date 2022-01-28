part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  final List properties;

  const NumberTriviaEvent({this.properties = const []});

  @override
  List<Object?> get props => properties;
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString) : super(properties: [numberString]);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}