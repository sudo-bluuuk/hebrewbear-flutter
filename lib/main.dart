import 'package:flutter/material.dart';
import 'package:hebrewbear/data/dbmanager.dart';
import 'package:hebrewbear/layouts/wordslist/wordslist.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    Provider<WordsDB>(
      create: (_) => WordsDB(),
      dispose: (_, db) => db.close(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hebrew Bear',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const WordsList(),
    );
  }
}
