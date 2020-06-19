import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/services/database.dart';
import 'package:salesvisit/views/visit/visit_total_tile.dart';

class VisitTotalList extends StatefulWidget {
  @override
  _VisitTotalListState createState() => _VisitTotalListState();
}

class _VisitTotalListState extends State<VisitTotalList> {
  @override
  Widget build(BuildContext context) {
    final List<UserData> users = Provider.of<List<UserData>>(context);
    return Container(
      height: 110,
      child: ListView.separated(
        itemCount: users.length,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 10),
        itemBuilder: (context, index) {
          return VisitTotalTile(userData: users[index]);
        },
      ),
    );
  }
}
