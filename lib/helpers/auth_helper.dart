import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  AuthHelper._();
  static final AuthHelper authHelper = AuthHelper._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailPassword(
      {required String email, required String password}) async {
    UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  Future<User?> loginWithEmailPassword(
      {required String email, required String password}) async {
    UserCredential userCredential =
        await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  Future<User?> loginWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);

    return userCredential.user;
  }

  Future logOut() async {
    await firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }
}
