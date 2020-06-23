import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/store.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/services/database.dart';
import 'package:salesvisit/shared/constants.dart';
import 'package:salesvisit/shared/loading.dart';
import 'package:salesvisit/extensions/string.dart';
import 'package:salesvisit/models/user.dart';
import 'package:geolocator/geolocator.dart';

class UserDetails extends StatefulWidget {
  final UserData userData;
  UserDetails({this.userData});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final _formKey = GlobalKey<FormState>();

  UserData userData = UserData();
  bool loading = false;
  bool enableEdit = false;
  bool isButtonHidden = true;
  String title = '';
  String error = '';
  IconData iconEdit = Icons.edit;

  String validatorAddUser(String type, String value) {
    switch (type) {
      case "email":
        if (!value.isValidEmail()) {
          return "Please enter an valid email address";
        }
        break;
      case "owner_name":
        if (value.isEmpty) {
          return "Please enter owner name";
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

  @override
  initState() {
    super.initState();

    userData = widget.userData;
  }

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    title = enableEdit ? "Edit User" : "User Details";
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0,
              title: Text(title),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      isButtonHidden = !isButtonHidden;
                      enableEdit = !enableEdit;
                      if (enableEdit) {
                        iconEdit = Icons.cancel;
                      } else {
                        iconEdit = Icons.edit;
                      }
                    });
                  },
                  icon: Icon(iconEdit),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: userData.email ?? '',
                        enabled: enableEdit,
                        validator: (val) => validatorAddUser("email", val),
                        onChanged: (val) {
                          setState(() {
                            userData.name = val;
                          });
                        },
                        decoration:
                            textInputDecoration.copyWith(labelText: "Email"),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: userData.name ?? '',
                        enabled: enableEdit,
                        validator: (val) => validatorAddUser("name", val),
                        onChanged: (val) {
                          setState(() {
                            userData.name = val;
                          });
                        },
                        decoration:
                            textInputDecoration.copyWith(labelText: "Name"),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: userData.phone,
                        enabled: enableEdit,
                        validator: (val) => validatorAddUser("phone", val),
                        onChanged: (val) {
                          setState(() {
                            userData.phone = val;
                          });
                        },
                        decoration:
                            textInputDecoration.copyWith(labelText: "Phone"),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 30),
                      Visibility(
                        visible: !isButtonHidden,
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);

                              dynamic result =
                                  await DatabaseService(uid: user.uid)
                                      .updateUserData(userData);

                              if (result == null) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          color: Colors.blue,
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
