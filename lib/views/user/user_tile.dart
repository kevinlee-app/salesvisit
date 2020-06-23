import 'package:flutter/material.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/views/user/user_details.dart';

class UserTile extends StatelessWidget {
  final UserData userData;
  UserTile({this.userData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
          ),
          title: Text(userData.name),
          subtitle: Text(userData.phone),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserDetails(userData: userData,))),
        ),
      ),
    );
  }
}
