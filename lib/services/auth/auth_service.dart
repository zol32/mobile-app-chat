import 'dart:developer';
import 'package:chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart' as FirebaseUser show User;
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/services/auth/cloud_service.dart';
import '../../firebase_options.dart';

class AuthService {
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudService _cloudService = CloudService();

  User? _userFromFirebaseUser(FirebaseUser.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  FirebaseUser.User? get currentUser => _auth.currentUser;

  Future<dynamic> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('HERE 1');
      FirebaseUser.User? user = userCredential.user;
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> logInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser.User? user = userCredential.user;
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException {
      throw FirebaseAuthException;
    } catch (e) {
      print(e.toString());
    }
  }

  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
