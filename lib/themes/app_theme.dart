import 'package:material_ui/material_ui.dart';

class AppTheme {
  // guarda o tema atual, o MaterialApp escuta essa variavel
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
