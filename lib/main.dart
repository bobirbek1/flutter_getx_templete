import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app.dart';
import 'package:flutter_template/bloc_observer.dart';

import 'injection_container.dart' as di;

void main(List<String> args) async {
  // Initialize the injection container
  await di.init();

  print("main function worked after init");

  // Run the app
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}
