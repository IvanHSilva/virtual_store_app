import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {

  //usuario atual
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser fbUser;
  Map<String, dynamic> userData = Map();
  
  bool isLoading = false;

  static UserModel of(BuildContext context) =>
    ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }
  
  void signUp({@required Map<String, dynamic> userData, @required String pass, 
               @required VoidCallback onSuccess, @required VoidCallback onFail}){
    isLoading = true;
    notifyListeners();
    
    _auth.createUserWithEmailAndPassword(
        email: userData['email'].trim(), 
        password: pass
    ).then((user) async {
      fbUser = user;
      await _saveUserData(userData);
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn({@required String email, @required String pass, 
    @required VoidCallback onSuccess, @required  VoidCallback onFail}) async {
    
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(
      email: email.trim(), 
      password: pass).then((user) async {
        fbUser = user;
        await _loadCurrentUser();
        onSuccess();
        isLoading = false;
        notifyListeners();
    }).catchError((e){
        onFail();
        isLoading = false;
        notifyListeners();
    });
}

  void signOut() async{
    await _auth.signOut();
    userData = Map();
    fbUser = null;
    notifyListeners();
  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection('users').document(fbUser.uid).setData(userData);
  }

  bool isLoggedIn(){
    return fbUser != null;
  }

  Future<Null> _loadCurrentUser() async {
    if (fbUser == null)
      fbUser = await _auth.currentUser();
    if (fbUser != null){
      if(userData['name'] == null){
        DocumentSnapshot docUser = 
          await Firestore.instance.collection('users').document(fbUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }

}