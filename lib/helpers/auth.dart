import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class AuthenticationHelper{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  get user => _firebaseAuth.currentUser;
  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future signOut() async{
    try{
      return await _firebaseAuth.signOut();
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

}