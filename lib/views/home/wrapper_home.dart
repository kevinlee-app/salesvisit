import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/user.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/views/home/admin_home.dart';
import 'package:salesvisit/views/home/user_home.dart';

class WrapperHome extends StatefulWidget {
  @override
  _WrapperHomeState createState() => _WrapperHomeState();
}

class _WrapperHomeState extends State<WrapperHome> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    if(userData!= null) {
      if(userData.isAdmin) {
        return AdminHome();
      } else {
        return UserHome();
      }
    }
  }
}