import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memento/functionalities/app/app.dart';

import 'bloc_observer.dart';
import 'bootstrap.dart';
import 'dependencies.dart';

/// The main entry point for the application.
///
/// Initializes Flutter bindings, configures the global [BlocObserver],
/// bootstraps local preferences and dependencies, and launches the root [App] widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  final bootstrap = await AppBootstrap.initialize();
  final deps = await AppDependencies.create(bootstrap);

  runApp(
    App(
      languageRepository: deps.languageRepository,
      booksRepository: deps.booksRepository,
    ),
  );
}