import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'database.dart';

abstract class AuthClass {
  Future<User> signInWithGoogle();
  Future<void> signOut();
}

class FirebaseAuthService implements AuthClass {
  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instanceFor(app: Firebase.app());
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Future<User> signInWithGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));

        if (userCredential.additionalUserInfo.isNewUser)
          await Database.addUser(userCredential.user);
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: "ERROR_MISSING_GOOGLE_ID_TOKEN",
            message: "Missing Google Id Token");
      }
    } else {
      throw FirebaseAuthException(
        code: "ERROR_ABORTED_BY_USER",
        message: "Sign in aborted by user",
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
