import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_template/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:flutter_template/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:flutter_template/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:flutter_template/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter templete'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  print("state is: $state");
                  if (state is Empty) {
                    return const MessageDisplay(message: "Start searching!");
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  }
                  return const MessageDisplay(message: "Start searching!");
                  // We're going to also check for the other states
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final textController = TextEditingController();
  String? inputStr;
  bool isTextFieldError = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Input number",
              errorText: isTextFieldError ? "Biron son kiriting" : null),
          onChanged: (value) => inputStr = value,
          onSubmitted: (value) => dispatchConcrete(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchConcrete,
                child: const Text("Search"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: ElevatedButton(
              onPressed: dispatchRandom,
              child: const Text("get random trivia"),
            )),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    // Clearing the TextField to prepare it for the next inputted number

    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(textController.text));
    textController.clear();
  }

  void dispatchRandom() {
    textController.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
