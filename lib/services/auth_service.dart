import 'package:firebase_auth/firebase_auth.dart';

import '../models/usuario.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Usuario? usuarioAtual() {
    User? user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    return Usuario(
      uid: user.uid,
      nome: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  // retorna null se deu certo, ou a mensagem de erro
  Future<String?> cadastrar(String nome, String email, String senha) async {
    try {
      UserCredential credencial = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      await credencial.user!.updateDisplayName(nome);
      await credencial.user!.reload();
      return null;
    } on FirebaseAuthException catch (e) {
      return mensagemErro(e.code);
    }
  }

  Future<String?> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      return mensagemErro(e.code);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String mensagemErro(String codigo) {
    switch (codigo) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'user-disabled':
        return 'Usuário desativado.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      default:
        return 'Erro na autenticação: $codigo';
    }
  }
}
