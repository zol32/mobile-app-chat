import 'package:chat_app/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:chat_app/services/auth/cloud_service.dart';
import 'dart:developer' show log;
import '../models/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final CloudService _cloudService = CloudService();

  late final TextEditingController _username;
  late final TextEditingController _fullName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _fullName = TextEditingController();
    _lastName = TextEditingController();
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _fullName.dispose();
    _lastName.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                controller: _fullName,
                enableSuggestions: false,
                style: const TextStyle(color: Colors.white),
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Enter your full name here',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _username,
                enableSuggestions: false,
                style: const TextStyle(color: Colors.white),
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Enter your username here',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _email,
                enableSuggestions: false,
                style: const TextStyle(color: Colors.white),
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
                final username = _username.text;
                final fullName = _fullName.text;
                final password = _password.text;
                await _auth.registerWithEmailAndPassword(
                  email,
                  password,
                  username,
                );

                await _cloudService.addUser(
                  username,
                  fullName,
                  email,
                );

                log('HelperFunctions SIGNUP 1');
                HelperFunctions.saveUserLoggedInSharedPreference(true);
                HelperFunctions.saveUserNameSharedPreference(username);
                HelperFunctions.saveUserEmailSharedPreference(email);
                log('HelperFunctions SIGNUP 2');

                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text(
                'Already registered? Login here!',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
