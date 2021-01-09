import 'package:flutter/material.dart';
import 'signup.dart';
import 'success.dart';
import 'package:sqflite/sqflite.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formState = GlobalKey<FormState>();
  String phoneNumber, password, confirmPass;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  Widget _errorWidget = Container();

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = InputDecoration(
      contentPadding: EdgeInsets.all(0),
      border: OutlineInputBorder(
        gapPadding: 10,
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 1,
          color: Colors.black,
        ),
      ),
    );
    return Scaffold(
      body: Center(
        child: Card(
          child: Form(
            key: _formState,
            autovalidateMode: autovalidateMode,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.green[300],
                    fontSize: 40,
                  ),
                ),
                _errorWidget,
                Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Phone number'),
                          Container(
                            width: 200,
                            child: TextFormField(
                              onChanged: (text) => phoneNumber = text,
                              validator: (val) {
                                if ((val?.length ?? 0) != 10)
                                  return 'Phone number must be 10 digits';
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: decoration,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Password'),
                          Container(
                            width: 200,
                            child: TextFormField(
                              validator: (val) {
                                if ((val?.length ?? 0) == 0)
                                  return 'Password cannot be empty';
                                return null;
                              },
                              onChanged: (text) => password = text,
                              decoration: decoration,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: RaisedButton(
                                color: Colors.green[400],
                                onPressed: _initializeLogin,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: _signUpRoute,
                        child: Text('I don\' have an Account. Sign up'),
                      ),
                    ],
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initializeLogin()  async {
    if (!_formState.currentState.validate()) return;
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });
    var databasesPath = await getDatabasesPath();
    String path = ('$databasesPath/' + 'users.db');
    Database database = await openDatabase(path, version: 1);
    List data = await database.rawQuery(
      'select * from users where phone = ? and password = ?',
      [phoneNumber, password],
    );
    if (data.length == 0) {
      _sendAlert('User does not exist');
      return;
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SuccessPage(
              path: 'login',
            )));
  }

  void _signUpRoute() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  void _sendAlert(String s) {
    setState(() {
      _errorWidget = Container(

        height: 10,
        child: Text(s),
      );
    });
  }
}