import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/tarefa.dart';

class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // as tarefas ficam em tarefas/<uid do usuario>/<id da tarefa>
  DatabaseReference _refTarefas() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return _database.ref('tarefas/$uid');
  }

  // cadastro
  Future<void> adicionarTarefa(Tarefa tarefa) async {
    DatabaseReference novaRef = _refTarefas().push();
    tarefa.id = novaRef.key!;
    await novaRef.set(tarefa.toMap());
  }

  // edicao
  Future<void> atualizarTarefa(Tarefa tarefa) async {
    await _refTarefas().child(tarefa.id).update(tarefa.toMap());
  }

  // exclusao
  Future<void> excluirTarefa(Tarefa tarefa) async {
    await _refTarefas().child(tarefa.id).remove();
  }

  Future<void> alterarSituacao(Tarefa tarefa) async {
    tarefa.concluida = !tarefa.concluida;
    await atualizarTarefa(tarefa);
  }

  // consulta: listener que avisa sempre que as tarefas mudam no banco
  StreamSubscription<DatabaseEvent> ouvirTarefas(
    void Function(List<Tarefa> tarefas) aoMudar,
  ) {
    return _refTarefas().onValue.listen((DatabaseEvent evento) {
      List<Tarefa> lista = [];
      if (evento.snapshot.value != null) {
        Map<dynamic, dynamic> dados =
            evento.snapshot.value as Map<dynamic, dynamic>;
        dados.forEach((id, valor) {
          lista.add(Tarefa.fromMap(id, valor));
        });
      }
      lista.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));
      aoMudar(lista);
    }, onError: (erro) {
      // acontece por exemplo quando o usuario sai e perde a permissao
      print('Erro ao ouvir tarefas: $erro');
    });
  }
}
