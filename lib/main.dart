import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:material_ui/material_ui.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/preferences_service.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // carrega o tema salvo no SharedPreferences
  bool temaEscuro = await PreferencesService().carregarTemaEscuro();
  if (temaEscuro) {
    AppTheme.themeMode.value = ThemeMode.dark;
  } else {
    AppTheme.themeMode.value = ThemeMode.light;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeMode,
      builder: (context, modo, child) {
        return MaterialApp(
          title: 'Gerenciador de Tarefas',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: modo,
          // o Firebase guarda a sessao, entao se o usuario ja estiver
          // logado vai direto para a tela inicial
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.data != null) {
                // sem const para atualizar o nome quando o perfil mudar
                return HomeScreen();
              }
              return const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
