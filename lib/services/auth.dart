import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:salesvisit/models/response.dart';
import 'package:salesvisit/models/user.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/services/database.dart';
import 'package:salesvisit/shared/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _user(FirebaseUser user) {

    return user != null ? User(uid: user.uid, isEmailVerified: user.isEmailVerified) : null;
  }

  Stream<User> get user {

    return _auth.onAuthStateChanged
      .map(_user);
  }

  Future signOut() async {
    try {

      return await _auth.signOut();
    } catch (e) {
      print(e.toString());

      return null;
    }
  }

  Future registerWithEmailandPassword(UserData userData) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: userData.email, password: userData.password);
      FirebaseUser user = result.user;
      user.sendEmailVerification();
      await DatabaseService(uid: user.uid).insertNewUserData(userData);
      
      return _user(user);
    } catch (e) {
      print(e.toString());

      return null;
    }
  }

  Future<Response> signInWithEmailandPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      return Response(errorMessage: "");
    } on PlatformException catch (e) {
      print(e.toString());

      return Response(errorMessage: errorMessageFromFirebase(e.code));
    }
  }
}