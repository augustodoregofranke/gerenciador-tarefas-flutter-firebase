import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String chaveTemaEscuro = 'tema_escuro';

  Future<void> salvarTemaEscuro(bool escuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(chaveTemaEscuro, escuro);
  }

  Future<bool> carregarTemaEscuro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(chaveTemaEscuro) ?? false;
  }
}
