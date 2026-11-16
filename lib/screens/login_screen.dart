import 'package:material_ui/material_ui.dart';

import '../services/auth_service.dart';
import 'cadastro_usuario_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _carregando = false;

  void _entrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _carregando = true;
    });

    String? erro = await _authService.login(
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
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const Icon(Icons.task_alt, size: 80, color: Colors.indigo),
                const SizedBox(height: 8),
                const Text(
                  'Gerenciador de Tarefas',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
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
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _carregando ? null : _entrar,
                    child: _carregando
                        ? const CircularProgressIndicator()
                        : const Text('Entrar'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CadastroUsuarioScreen(),
                      ),
                    );
                  },
                  child: const Text('Não tem conta? Cadastre-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
