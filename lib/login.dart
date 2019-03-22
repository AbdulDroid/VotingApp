import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'idea_list.dart';
import 'sign_up.dart';
import 'user.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username, _password;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  void _login() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      _doLogin();
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Do you really want to close the Voting app"),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("No"),
            ),
            FlatButton(
              onPressed: () {
                SystemChannels.platform
                    .invokeMethod('SystemNavigator.pop');
              },
              child: Text("Yes"),
            )
          ],
        ));
  }

  void _doLogin() {
    UserProvider provider = UserProvider();
    provider.getUser(_username.toLowerCase()).then((user) {
      if (user == null) {
        final snackbar = SnackBar(
          content: Text("User does not exist! Please SIGN UP first."),
          duration: Duration(seconds: 5),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);
      } else {
        if (user.password == _password) {
          _persist();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IdeaListPage()),
          );
        } else {
          final snackbar = SnackBar(
            content: Text("Incorrect password, Please try again"),
            duration: Duration(seconds: 5),
          );
          scaffoldKey.currentState.showSnackBar(snackbar);
        }
      }
    }, onError: (e) {
      final snackbar = SnackBar(
        content: Text("An error occurred"),
        duration: Duration(seconds: 5),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
      print(e);
    });
    print("User entered: \n username: $_username and password: $_password");
  }

  void _persist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("login", true).then((onValue) {
      if (onValue) {
        print("So it happened I guess: $onValue");
      } else {
        print("So it didn't happen, sighs: $onValue");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /* Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display1,
                ),*/
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Voting App",
                    style:
                        new TextStyle(color: Color(0xFF3E4A59), fontSize: 28.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 80.0,
                  bottom: 16.0,
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style:
                        new TextStyle(color: Color(0xFF3E4A59), fontSize: 22.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: new InputDecoration(
                            labelText: "Username",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide())),
                        validator: (val) =>
                            val.length == 0 ? "Username cannot be empty" : null,
                        onSaved: (val) => _username = val,
                        keyboardType: TextInputType.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextFormField(
                          decoration: new InputDecoration(
                              labelText: "Password",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide())),
                          validator: (val) => val.length < 6
                              ? "Password is too short, miLength==6"
                              : null,
                          onSaved: (val) => _password = val,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 40.0,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56.0,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Color(0xFF0857AB),
                            splashColor: Colors.white,
                            onPressed: _login,
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: RichText(
                      text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          style: Theme.of(context).textTheme.body1,
                          text: "Don\'t have an account?  "),
                      TextSpan(
                          style: Theme.of(context).textTheme.body2.copyWith(
                                color: Theme.of(context).accentColor,
                              ),
                          text: "Register",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                              print("Register clicked oooo");
                            })
                    ],
                  )))
            ],
          ),
        ),
        /*floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), */ // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
