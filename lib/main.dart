import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salesvisit/models/user.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/services/auth.dart';
import 'package:salesvisit/shared/encrypter.dart';
import 'package:salesvisit/views/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/services/database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom])
    SVEncrypter().encrypt("lusOvYUBtjDolGfz75V6");
    // return StreamProvider<User>.value(
    //   value: AuthService().user,
    //       child: MaterialApp(
    //     home: Wrapper(),
    //   ),
    // );
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
      ],
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
