import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salesvisit/models/response.dart';
import 'package:salesvisit/services/auth.dart';
import 'package:salesvisit/shared/animated_background.dart';
import 'package:salesvisit/shared/button_submit.dart';
import 'package:salesvisit/shared/constants.dart';
import 'package:salesvisit/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  String email = '';
  String password = '';
  String error = '';

  void _onLoginPressed() async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
      Response result =
          await _authService.signInWithEmailandPassword(email, password);
      if (!result.success) {
        setState(() {
          loading = false;
          error = result.errorMessage;
        });
      }
    }
  }

  void _onRegisterPressed() {
    widget.toggleView();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Stack(
              children: <Widget>[
                FancyBackground(),
                Positioned(
                  left: 12,
                  right: 12,
                  top: 220,
                  bottom: 50,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                          )
                        ]),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 60),
                            Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 40),
                            TextFormField(
                              validator: (val) =>
                                  val.isEmpty ? "Enter an email" : null,
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              style: textInputStyle,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Email"),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              validator: (val) => val.length < 6
                                  ? "Enter password with 6+ characters"
                                  : null,
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Password"),
                              style: textInputStyle,
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => {print("Forget Password")},
                                child: Text(
                                  'Forget your password?',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blue),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                            CustomButtonSubmit(
                              height: 60,
                              width: 200,
                              text: 'LOGIN',
                              onPressed: _onLoginPressed,
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: _onRegisterPressed,
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: MediaQuery.of(context).size.width - 180,
                                child: Text(
                                  'Don\'t have an account? Sign up',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blue),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return loading
  //       ? Loading()
  //       : Scaffold(
  //           resizeToAvoidBottomPadding: false,
  //           backgroundColor: Colors.white,
  //           // appBar: AppBar(
  //           //   backgroundColor: Colors.blue,
  //           //   elevation: 0,
  //           //   title: Text('Sign In'),
  //           //   actions: <Widget>[
  //           //     FlatButton.icon(
  //           //       onPressed: () {
  //           //         widget.toggleView();
  //           //       },
  //           //       icon: Icon(Icons.person),
  //           //       label: Text('Register'),
  //           //     )
  //           //   ],
  //           // ),
  //           body: Stack (
  //             children: <Widget>[
  //               FancyBackground(),
  //               Positioned(
  //                 left: 12,
  //                 right: 12,
  //                 top: 220,
  //                 bottom: 10,
  //                 child: Container(
  //                   height: MediaQuery.of(context).size.height,
  //                   decoration: BoxDecoration(
  //                       color: Colors.black,
  //                       borderRadius: BorderRadius.circular(20),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black.withOpacity(0.5),
  //                         )
  //                       ]),
  //                 ),
  //               )
  //             ],
  //           ),
  //           // body: Container(
  //           //   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
  //           //   child: Form(
  //           //     key: _formKey,
  //           //     child: Column(
  //           //       children: <Widget>[
  //           //         SizedBox(height: 20),
  //           //         TextFormField(
  //           //           validator: (val) => val.isEmpty ? "Enter an email" : null,
  //           //           onChanged: (val) {
  //           //             setState(() {
  //           //               email = val;
  //           //             });
  //           //           },
  //           //           decoration: textInputDecoration.copyWith(labelText: "Email"),
  //           //           style: TextStyle(fontSize: 20),
  //           //         ),
  //           //         SizedBox(height: 20),
  //           //         TextFormField(
  //           //           validator: (val) =>
  //           //               val.length < 6 ? "Enter password with 6+ characters" : null,
  //           //           onChanged: (val) {
  //           //             setState(() {
  //           //               password = val;
  //           //             });
  //           //           },
  //           //           decoration: textInputDecoration.copyWith(labelText: "Password"),
  //           //           style: TextStyle(fontSize: 20),
  //           //           obscureText: true,
  //           //         ),
  //           //         SizedBox(height: 30),
  //           //         RaisedButton(
  //           //           onPressed: () async {
  //           //             if (_formKey.currentState.validate()) {
  //           //               setState(() => loading = true);
  //           //               Response result = await _authService
  //           //                   .signInWithEmailandPassword(email, password);
  //           //               if (!result.success) {
  //           //                 setState(() {
  //           //                   loading = false;
  //           //                   error = result.errorMessage;
  //           //                 });
  //           //               }
  //           //             }
  //           //           },
  //           //           color: Colors.blue,
  //           //           child: Text(
  //           //             "Sign In",
  //           //             style: TextStyle(color: Colors.white, fontSize: 20),
  //           //           ),
  //           //         ),
  //           //         SizedBox(height: 12),
  //           //         Text(
  //           //           error,
  //           //           style: TextStyle(color: Colors.red, fontSize: 16),
  //           //         ),
  //           //       ],
  //           //     ),
  //           //   ),
  //           // ),
  //         );
  // }
}
