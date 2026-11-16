import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:material_ui/material_ui.dart';

import '../models/tarefa.dart';
import '../services/firebase_service.dart';
import '../widgets/drawer_menu.dart';
import 'cadastro_tarefa_screen.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  StreamSubscription<DatabaseEvent>? _listener;
  List<Tarefa> _tarefas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    // listener: a lista atualiza sozinha quando muda algo no Firebase
    _listener = _firebaseService.ouvirTarefas((tarefas) {
      setState(() {
        _tarefas = tarefas;
        _carregando = false;
      });
    });
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }

  Color _corPrioridade(String prioridade) {
    if (prioridade == 'Alta') {
      return Colors.red;
    } else if (prioridade == 'Média') {
      return Colors.orange;
    }
    return Colors.green;
  }

  void _abrirCadastro(Tarefa? tarefa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroTarefaScreen(tarefa: tarefa),
      ),
    );
  }

  void _confirmarExclusao(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir tarefa'),
          content: Text('Deseja excluir a tarefa "${tarefa.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _firebaseService.excluirTarefa(tarefa);
                if (!mounted) return;
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Tarefa excluída')),
                );
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // mostra os detalhes da tarefa selecionada
  void _mostrarDetalhes(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(tarefa.titulo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descrição: ${tarefa.descricao}'),
              const SizedBox(height: 8),
              Text('Vencimento: ${tarefa.dataFormatada}'),
              const SizedBox(height: 8),
              Text(
                'Prioridade: ${tarefa.prioridade}',
                style: TextStyle(color: _corPrioridade(tarefa.prioridade)),
              ),
              const SizedBox(height: 8),
              Text('Situação: ${tarefa.situacao}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmarExclusao(tarefa);
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _abrirCadastro(tarefa);
              },
              child: const Text('Editar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget corpo;

    if (_carregando) {
      corpo = const Center(child: CircularProgressIndicator());
    } else if (_tarefas.isEmpty) {
      corpo = const Center(child: Text('Nenhuma tarefa cadastrada.'));
    } else {
      corpo = ListView.builder(
        itemCount: _tarefas.length,
        itemBuilder: (context, index) {
          Tarefa tarefa = _tarefas[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Icon(
                Icons.flag,
                color: _corPrioridade(tarefa.prioridade),
                size: 32,
              ),
              title: Text(
                tarefa.titulo,
                style: TextStyle(
                  decoration: tarefa.concluida
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                'Vence em: ${tarefa.dataFormatada}\n'
                'Prioridade: ${tarefa.prioridade} - ${tarefa.situacao}',
              ),
              isThreeLine: true,
              trailing: Checkbox(
                value: tarefa.concluida,
                onChanged: (valor) {
                  _firebaseService.alterarSituacao(tarefa);
                },
              ),
              onTap: () {
                _mostrarDetalhes(tarefa);
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas tarefas')),
      drawer: const DrawerMenu(),
      body: corpo,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abrirCadastro(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
