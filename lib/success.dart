import 'package:flutter/material.dart';

import 'login.dart';

class SuccessPage extends StatelessWidget {
  final String path;

  const SuccessPage({Key key, this.path}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (path == 'signup') ? SignUpSuccess() : LoginSuccess(),
      ),
    );
  }
}

class SignUpSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('SuccessFully Signed Up'),
        FlatButton(
          child: Text('Continue to login'),
          onPressed: () => _loginRoute(context),
        )
      ],
    );
  }

  void _loginRoute(context) => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Login()));
}

class LoginSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text('SuccessFully Logged in'),
    );
  }
}