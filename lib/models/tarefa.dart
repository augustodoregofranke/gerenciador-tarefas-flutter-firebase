class Tarefa {
  String id;
  String titulo;
  String descricao;
  DateTime dataVencimento;
  String prioridade; // Baixa, Média ou Alta
  bool concluida;

  Tarefa({
    this.id = '',
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    required this.prioridade,
    this.concluida = false,
  });

  // converte a tarefa para salvar no Firebase
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'dataVencimento': dataVencimento.toIso8601String(),
      'prioridade': prioridade,
      'concluida': concluida,
    };
  }

  // cria uma tarefa a partir dos dados do Firebase
  factory Tarefa.fromMap(String id, Map<dynamic, dynamic> map) {
    return Tarefa(
      id: id,
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      dataVencimento: DateTime.parse(map['dataVencimento']),
      prioridade: map['prioridade'] ?? 'Baixa',
      concluida: map['concluida'] ?? false,
    );
  }

  String get situacao {
    if (concluida) {
      return 'Concluída';
    }
    return 'Pendente';
  }

  String get dataFormatada {
    String dia = dataVencimento.day.toString().padLeft(2, '0');
    String mes = dataVencimento.month.toString().padLeft(2, '0');
    return '$dia/$mes/${dataVencimento.year}';
  }
}
