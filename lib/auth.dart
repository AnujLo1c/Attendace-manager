import 'package:firebase_auth/firebase_auth.dart';

import 'connections/Cloudfirestorefunc.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // await credential.user!.getIdToken()
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Future<void> signInWithEandP(String email, String pass) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: pass);
  }

  Future<void> signUpWithEandP(String email, String pass) async {
    print("asdf");
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: pass);

    print("asdf");
    }
    catch(e){
      print(e);
    }
    }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
