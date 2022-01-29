import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app.dart';

import 'injection_container.dart' as di;

void main(List<String> args) async {
  // Initialize the injection container
  await di.init();

  // Run the app
  runApp(const MyApp());
}
