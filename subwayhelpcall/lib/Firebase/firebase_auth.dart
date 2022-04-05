import 'package:firebase_auth/firebase_auth.dart';

class FirebaseATHelper {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  String setUser;

  Future<bool> signIn(String email, String password) async {
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      setUser = user.uid;
      return true;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<void> signOut() async {
    setUser = null;
    return auth.signOut();
  }
}
