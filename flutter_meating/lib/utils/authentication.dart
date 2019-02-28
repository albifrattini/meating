// Class used to Authenticate a User through Firebase Authentication service.

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password, String name, String surname);
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Authentication implements BaseAuth {
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _fbAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }
  Future<String> signUp(String email, String password, String name, String surname) async {
    FirebaseUser user = await _fbAuth.createUserWithEmailAndPassword(email: email, password: password);
    print(user);
    if (user.uid.length > 0) {
      _intoDatabase(user, email, password, name, surname);
    }
    return user.uid;
  }
  Future<String> getCurrentUser() async {
    try {
      FirebaseUser user = await _fbAuth.currentUser();
      return user.uid;
    } catch(e) {
      return null;
    }
  }
  Future<void> signOut() async {
    return _fbAuth.signOut();
  }

  _intoDatabase(FirebaseUser user, String email, String password, String name, String surname) {
    Firestore.instance.collection('users').document(user.uid).
          setData({
            'userId': user.uid,
            'password': password,
            'name': name,
            'surname': surname,
            'photoURL': '',
            'biography': ''
          });
  }
}