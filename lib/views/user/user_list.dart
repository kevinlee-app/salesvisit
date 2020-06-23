import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/views/user/user_tile.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>>(context);
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 12.0),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserTile(userData: users[index]);
      },
    );
  }
}
