import 'package:chat_app/Widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading=true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({'username': username, 'email': email});
      }
      setState(() {
        _isLoading=false;
      });
    } on PlatformException catch (e) {
      var msg = "An error occured,please check you credentials!";
      if (e.message != null) {
        msg = e.message;
      }
      setState(() {
        _isLoading=false;
      });
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    } catch (e) {
      setState(() {
        _isLoading=false;
      });
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_isLoading,_submitAuthForm),
    );
  }
}
