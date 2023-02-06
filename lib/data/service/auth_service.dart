import 'package:chatapp_firebase/data/db/db_helper.dart';
import 'package:chatapp_firebase/data/service/data_base_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//sign in
  Future signInUserWithEmailAndPassword(
      {required String email,
        required String password}) async {
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .user;

      if (user != null) {

        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e;
    }
  }
// sign up
  Future registerUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String fullName}) async {
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        await DataBaseService(uid: user.uid)
            .updateUserData(fullName: fullName, email: email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e;
    }
  }

// sign out

  Future signOut() async {
    try {
      await DBHelper.setUserEmailSf('');
      await DBHelper.setUserPasswordSf('');
      await DBHelper.setUserNameSf('');
      await DBHelper.setUserAuthStatus(false);
      await firebaseAuth.signOut();
    } catch (e) {}
  }
}
