import 'package:firebase_tutorial/constants/imports.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AppUser _userFromFirebaseUser(User user) {
    return (user != null ? AppUser(uid: user.uid) : null) as AppUser;
  }

  Stream<AppUser> get user {
    return _auth
        .authStateChanges()
        .map((user) => _userFromFirebaseUser(user as User));
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user as User;
      return _userFromFirebaseUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user as User;
      return user;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user as User;
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(user.uid, name,
          'nick', 'imageUrl', 'dob', 150, 50, false, false, false, false, 0);
      return _userFromFirebaseUser(user);
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
