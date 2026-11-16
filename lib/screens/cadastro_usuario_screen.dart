import 'package:material_ui/material_ui.dart';

import '../services/auth_service.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _carregando = false;

  void _cadastrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _carregando = true;
    });

    String? erro = await _authService.cadastrar(
      _nomeController.text.trim(),
      _emailController.text.trim(),
      _senhaController.text,
    );

    if (!mounted) return;

    setState(() {
      _carregando = false;
    });

    if (erro != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(erro)));
    } else {
      // usuario ja fica logado depois do cadastro
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de usuário')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o e-mail';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Informe a senha';
                  }
                  if (valor.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _cadastrar,
                  child: _carregando
                      ? const CircularProgressIndicator()
                      : const Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
