import 'package:flutter/material.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/services/auth.dart';
import 'package:salesvisit/services/functions.dart';
import 'package:salesvisit/shared/button_submit.dart';
import 'package:salesvisit/shared/constants.dart';
import 'package:salesvisit/extensions/string.dart';
import 'package:salesvisit/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FunctionsService _funcService = FunctionsService();
  final _formKey = GlobalKey<FormState>();

  bool isAnimated = false;
  bool loading = false;
  UserData userData = UserData();
  String error = '';

  void _onRegisterPressed() async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
      dynamic result =
          await _funcService.registerWithEmailandPassword(userData);
      if (result == null) {
        setState(() {
          error = "Error";
          loading = false;
        });
      } else {
        // widget.toggleView();
        Navigator.pop(context);
      }
    }
  }

  @override
  initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isAnimated = true;
      });
    });
  }

  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Register User'),
              backgroundColor: Colors.blue,
              elevation: 0,
              // leading: IconButton(
              //   onPressed: widget.toggleView,
              //   icon: Icon(
              //     Icons.arrow_back,
              //     color: Colors.white,
              //   ),
              // ),
            ),
            body: AnimatedOpacity(
              opacity: isAnimated ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Stack(
                children: [
                  Positioned(
                    left: 12,
                    right: 12,
                    top: 20,
                    bottom: 20,
                    child: Container(
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
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 60),
                            Text(
                              'REGISTER',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 40),
                            TextFormField(
                              validator: (val) =>
                                  validatorRegister("email", val),
                              onChanged: (val) {
                                setState(() {
                                  userData.email = val;
                                });
                              },
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Email"),
                              style: textInputStyle
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              validator: (val) =>
                                  validatorRegister("password", val),
                              onChanged: (val) {
                                setState(() {
                                  userData.password = val;
                                });
                              },
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Password"),
                              style: textInputStyle,
                              obscureText: true,
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              validator: (val) =>
                                  validatorRegister("name", val),
                              onChanged: (val) {
                                setState(() {
                                  userData.name = val;
                                });
                              },
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Name"),
                              style: textInputStyle,
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              validator: (val) =>
                                  validatorRegister("phone", val),
                              onChanged: (val) {
                                setState(() {
                                  userData.phone = val;
                                });
                              },
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Phone"),
                              style: textInputStyle,
                            ),
                            SizedBox(height: 50),
                            CustomButtonSubmit(
                              onPressed: _onRegisterPressed,
                              text: "REGISTER",
                              width: 200,
                              height: 60,
                            ),
                            SizedBox(height: 30),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  String validatorRegister(String type, String value) {
    switch (type) {
      case "email":
        if (!value.isValidEmail()) {
          return "Please enter an valid email address";
        }
        break;
      case "password":
        if (value.length < 6) {
          return "Please enter password with at least 6 characters";
        }
        break;
      case "phone":
        if (!value.isValidPhone()) {
          return "Please enter valid phone number";
        }
        break;
      case "name":
        if (value.isEmpty) {
          return "Please enter name";
        }
        break;
      default:
        return "";
    }
  }
}
