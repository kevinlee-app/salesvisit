import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/services/database.dart';
import 'package:salesvisit/views/authenticate/authenticate.dart';
import 'package:salesvisit/views/authenticate/verify.dart';
import 'package:salesvisit/models/user.dart';
import 'package:salesvisit/views/home/wrapper_home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    // } else if (!user.isEmailVerified) {
      // return Verify();
    } else {
      return StreamProvider<UserData>.value(
        initialData: UserData(),
        value: DatabaseService(uid: user.uid).userData,
        child: WrapperHome(),
      );
    }
  }
}
