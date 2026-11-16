import 'package:material_ui/material_ui.dart';

import '../models/usuario.dart';
import '../screens/configuracoes_screen.dart';
import '../screens/tarefas_screen.dart';
import '../services/auth_service.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  // volta para a primeira tela (inicio) antes de abrir outra
  void _abrirTela(BuildContext context, Widget tela) {
    NavigatorState navegador = Navigator.of(context);
    navegador.pop();
    navegador.popUntil((route) => route.isFirst);
    navegador.push(MaterialPageRoute(builder: (context) => tela));
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    Usuario? usuario = authService.usuarioAtual();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(usuario?.nome ?? ''),
            accountEmail: Text(usuario?.email ?? ''),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              NavigatorState navegador = Navigator.of(context);
              navegador.pop();
              navegador.popUntil((route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Minhas tarefas'),
            onTap: () {
              _abrirTela(context, const TarefasScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              _abrirTela(context, const ConfiguracoesScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre o aplicativo'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Gerenciador de Tarefas',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.check_circle, size: 40),
                children: const [
                  Text(
                    'Aplicativo para gerenciar tarefas pessoais, feito com '
                    'Flutter e Firebase para a P2 de Programação Mobile.',
                  ),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              NavigatorState navegador = Navigator.of(context);
              navegador.pop();
              navegador.popUntil((route) => route.isFirst);
              await authService.logout();
            },
          ),
        ],
      ),
    );
  }
}
