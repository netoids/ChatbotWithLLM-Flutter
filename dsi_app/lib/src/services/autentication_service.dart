import 'package:firebase_auth/firebase_auth.dart';

class AutenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> registerUser({
    required String nome,
    required String email,
    required String senha, 
  }) async {
    try {
  UserCredential userCredential =  await _firebaseAuth.createUserWithEmailAndPassword(
    email: email,
    password: senha,
  );
  userCredential.user!.updateDisplayName(nome);

  return null;
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    return 'A senha é muito fraca.';
  } 
  if (e.code == 'email-already-in-use') {
    return 'O email já está em uso.';
  }
  return 'Erro desconhecido.';
  }
}
  Future<String?> loginUser({
  required String email,
  required String senha,
}) async {
  try {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'invalid-email') {
      return 'Email inválido.';
    } 
    if (e.code == 'invalid-credential') {
      return 'Credenciais inválidas.';
    }
    return 'Erro desconhecido.';
  }
}
}