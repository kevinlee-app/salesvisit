import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/services/auth.dart';
import 'package:salesvisit/services/database.dart';
import 'package:salesvisit/views/user/user_list.dart';

class UserMenu extends StatefulWidget {
  @override
  _UserMenuState createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserData>>.value(
      initialData: List(),
      value: DatabaseService().allUsers,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Text('Users'),
          // actions: <Widget>[
          //   FlatButton.icon(
          //     onPressed: () async {
          //       await _authService.signOut();
          //     },
          //     icon: Icon(Icons.person),
          //     label: Text('Sign Out'),
          //   )
          // ],
        ),
        body: UserList(),
      ),
    );
  }
}