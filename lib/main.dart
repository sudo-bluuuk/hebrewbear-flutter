import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hebrewbear/data/dbmanager.dart';
import 'package:hebrewbear/layouts/wordslist/wordslist.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

const Set<TargetPlatform> _desktopPlatforms = {
  TargetPlatform.linux,
  TargetPlatform.macOS,
  TargetPlatform.windows,
};

bool get _isDesktop =>
    !kIsWeb && _desktopPlatforms.contains(defaultTargetPlatform);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_isDesktop) {
    await windowManager.ensureInitialized();
    // Width only — a zero height leaves the vertical size unconstrained.
    await windowManager.setMinimumSize(const Size(360, 0));
  }

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
