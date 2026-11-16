import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:material_ui/material_ui.dart';

import '../models/tarefa.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../widgets/drawer_menu.dart';
import 'cadastro_tarefa_screen.dart';
import 'tarefas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  StreamSubscription<DatabaseEvent>? _listener;
  List<Tarefa> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _listener = _firebaseService.ouvirTarefas((tarefas) {
      setState(() {
        _tarefas = tarefas;
      });
    });
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }

  Widget _cardContador(String titulo, int valor, Color cor, IconData icone) {
    return Card(
      child: ListTile(
        leading: Icon(icone, color: cor, size: 32),
        title: Text(titulo),
        trailing: Text(
          valor.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Usuario? usuario = AuthService().usuarioAtual();

    int pendentes = 0;
    int concluidas = 0;
    for (Tarefa t in _tarefas) {
      if (t.concluida) {
        concluidas++;
      } else {
        pendentes++;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      drawer: const DrawerMenu(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Olá, ${usuario?.nome ?? ''}!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _cardContador(
            'Tarefas cadastradas',
            _tarefas.length,
            Colors.indigo,
            Icons.list_alt,
          ),
          _cardContador('Pendentes', pendentes, Colors.orange, Icons.schedule),
          _cardContador(
            'Concluídas',
            concluidas,
            Colors.green,
            Icons.check_circle,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TarefasScreen()),
              );
            },
            icon: const Icon(Icons.list),
            label: const Text('Minhas tarefas'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroTarefaScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Nova tarefa'),
          ),
        ],
      ),
    );
  }
}
