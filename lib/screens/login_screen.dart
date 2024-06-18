import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  bool _isLogin = true;
  bool _isLoading = false;

  void _switchAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_isLogin) {
        await _auth.signInWithEmailAndPassword(email: _email, password: _password);
      } else {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
    );
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': _email,
          'createdAt': Timestamp.now(),
        });
  }
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
      setState(() {
        _isLoading = false;
      });
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                _email = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                _password = value;
              },
            ),
            SizedBox(height: 20),
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading)
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Login' : 'Sign Up'),
              ),
            if (!_isLoading)
              TextButton(
                onPressed: _switchAuthMode,
                child: Text('${_isLogin ? 'Create new account' : 'I already have an account'}'),
              ),
          ],
        ),
      ),
    );
  }
}
