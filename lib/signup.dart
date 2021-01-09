import 'package:flutter/material.dart';
import 'login.dart';
import 'success.dart';
import 'package:sqflite/sqflite.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                  'SignUp',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 50,
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Confirm Password'),
                          Container(
                            width: 200,
                            child: TextFormField(
                              validator: (val) {
                                if ((val ?? '') != password)
                                  return 'Passwords doesn\'t match';
                                return null;
                              },
                              onChanged: (text) => confirmPass = text,
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
                                color: Colors.blueGrey,
                                onPressed: _initializeSignUp,
                                child: Text(
                                  'SignUp',
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
                        onPressed: _loginRoute,
                        child: Text('Login'),
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

  Future<void> _initializeSignUp() async {
    if (!_formState.currentState.validate()) return;
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });
    var databasesPath = await getDatabasesPath();
    String path = ('$databasesPath/' + 'users.db');
    Database database = await openDatabase(path, version: 1);
    List data = await database.rawQuery(
      'select * from users where phone = ?',
      [phoneNumber],
    );
    if (data.length != 0) {
      _sendAlert('User already exist');
      return;
    } else {
      await database.rawQuery(
        'insert into users(phone,password) values(?,?)',
        [phoneNumber, password],
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SuccessPage(
                path: 'signup',
              )));
    }
  }

  void _loginRoute() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  void _sendAlert(String s) {
    setState(() {
      _errorWidget = Container(
        height: 20,
        child: Text(
          s,
          style: TextStyle(color: Colors.red, fontSize: 10),
        ),
      );
    });
  }
}