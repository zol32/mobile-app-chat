import 'dart:developer';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/services/auth/cloud_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseUser show User;

import '../models/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final CloudService _cloudService = CloudService();

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/logo.png',
                  height: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _email,
                  style: const TextStyle(color: Colors.white),
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email here',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _password,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password here',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  User? user = await _auth.logInWithEmailAndPassword(
                    email,
                    password,
                  );

                  QuerySnapshot userInfoSnapshot =
                      await _cloudService.getUserInfo(email);

                  HelperFunctions.saveUserLoggedInSharedPreference(true);
                  HelperFunctions.saveUserNameSharedPreference(
                      userInfoSnapshot.docs[0]['username']);
                  HelperFunctions.saveUserEmailSharedPreference(
                      userInfoSnapshot.docs[0]["email"]);

                  if (user != null) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      chatPageRoute,
                      (route) => false,
                    );
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false,
                  );
                },
                child: const Text(
                  'Not registered yet? Register here!',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
