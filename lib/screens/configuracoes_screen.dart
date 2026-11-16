import 'package:material_ui/material_ui.dart';

import '../services/preferences_service.dart';
import '../themes/app_theme.dart';
import '../widgets/drawer_menu.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final PreferencesService _preferencesService = PreferencesService();

  void _alterarTema(bool escuro) async {
    if (escuro) {
      AppTheme.themeMode.value = ThemeMode.dark;
    } else {
      AppTheme.themeMode.value = ThemeMode.light;
    }
    // salva a escolha para quando abrir o app de novo
    await _preferencesService.salvarTemaEscuro(escuro);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool escuro = AppTheme.themeMode.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      drawer: const DrawerMenu(),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Tema escuro'),
            subtitle: Text(escuro ? 'Ativado' : 'Desativado'),
            secondary: Icon(escuro ? Icons.dark_mode : Icons.light_mode),
            value: escuro,
            onChanged: _alterarTema,
          ),
        ],
      ),
    );
  }
}
