import 'package:material_ui/material_ui.dart';

import '../models/tarefa.dart';
import '../services/firebase_service.dart';

class CadastroTarefaScreen extends StatefulWidget {
  // se vier uma tarefa e edicao, se nao e cadastro
  final Tarefa? tarefa;

  const CadastroTarefaScreen({super.key, this.tarefa});

  @override
  State<CadastroTarefaScreen> createState() => _CadastroTarefaScreenState();
}

class _CadastroTarefaScreenState extends State<CadastroTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  DateTime? _dataVencimento;
  String _prioridade = 'Baixa';
  String _situacao = 'Pendente';
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      _tituloController.text = widget.tarefa!.titulo;
      _descricaoController.text = widget.tarefa!.descricao;
      _dataVencimento = widget.tarefa!.dataVencimento;
      _prioridade = widget.tarefa!.prioridade;
      _situacao = widget.tarefa!.situacao;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _escolherData() async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dataVencimento ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (data != null) {
      setState(() {
        _dataVencimento = data;
      });
    }
  }

  String _textoData() {
    if (_dataVencimento == null) {
      return 'Selecione a data de vencimento';
    }
    String dia = _dataVencimento!.day.toString().padLeft(2, '0');
    String mes = _dataVencimento!.month.toString().padLeft(2, '0');
    return 'Vencimento: $dia/$mes/${_dataVencimento!.year}';
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_dataVencimento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data de vencimento')),
      );
      return;
    }

    setState(() {
      _salvando = true;
    });

    Tarefa tarefa = Tarefa(
      titulo: _tituloController.text.trim(),
      descricao: _descricaoController.text.trim(),
      dataVencimento: _dataVencimento!,
      prioridade: _prioridade,
      concluida: _situacao == 'Concluída',
    );

    if (widget.tarefa == null) {
      await _firebaseService.adicionarTarefa(tarefa);
    } else {
      tarefa.id = widget.tarefa!.id;
      await _firebaseService.atualizarTarefa(tarefa);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa salva com sucesso')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String titulo = widget.tarefa == null ? 'Nova tarefa' : 'Editar tarefa';

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe a descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _escolherData,
                icon: const Icon(Icons.calendar_today),
                label: Text(_textoData()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _prioridade,
                decoration: const InputDecoration(labelText: 'Prioridade'),
                items: const [
                  DropdownMenuItem(value: 'Baixa', child: Text('Baixa')),
                  DropdownMenuItem(value: 'Média', child: Text('Média')),
                  DropdownMenuItem(value: 'Alta', child: Text('Alta')),
                ],
                onChanged: (valor) {
                  setState(() {
                    _prioridade = valor!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _situacao,
                decoration: const InputDecoration(labelText: 'Situação'),
                items: const [
                  DropdownMenuItem(value: 'Pendente', child: Text('Pendente')),
                  DropdownMenuItem(
                    value: 'Concluída',
                    child: Text('Concluída'),
                  ),
                ],
                onChanged: (valor) {
                  setState(() {
                    _situacao = valor!;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _salvar,
                  child: _salvando
                      ? const CircularProgressIndicator()
                      : const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
