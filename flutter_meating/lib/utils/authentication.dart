// Class used to Authenticate a User through Firebase Authentication service.

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Authentication implements BaseAuth {
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _fbAuth.signInWithEmailAndPassword(email: email, password: password);
    _intoDatabase(user);
    return user.uid;
  }
  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _fbAuth.createUserWithEmailAndPassword(email: email, password: password);
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

  _intoDatabase(FirebaseUser user) async {
    final QuerySnapshot result = await Firestore.instance.collection('users').where('id', isEqualTo: user.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      Firestore.instance.collection('users').document(user.uid).setData({'id': user.uid});
    }
  }
}