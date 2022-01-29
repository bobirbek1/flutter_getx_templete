import 'package:flutter/material.dart';
import 'package:flutter_template/features/number_trivia/presentation/getx/number_trivia_controller.dart';
import 'package:flutter_template/features/number_trivia/presentation/getx/number_trivia_state.dart';
import 'package:flutter_template/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:flutter_template/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:flutter_template/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

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

  Widget buildBody(BuildContext context) {
    final controller = Get.find<NumberTriviaController>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Obx(
              () {
                print("state is: ${controller.nTState}");
                final state = controller.nTState.value;
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
  bool isTextFieldError = false;
  late NumberTriviaController _controller;

  @override
  void dispose() {
    textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = Get.find();
    super.initState();
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

    _controller.getConcreteNumberTrivia(textController.text);
    textController.clear();
  }

  void dispatchRandom() {
    textController.clear();
    _controller.getRandomNumberTrivia();
  }
}
