import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/store.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/models/visit.dart';
import 'package:salesvisit/services/database.dart';
import 'package:salesvisit/views/visit/visit_details_tile.dart';

class VisitDetailsList extends StatefulWidget {
  @override
  _VisitDetailsListState createState() => _VisitDetailsListState();
}

class _VisitDetailsListState extends State<VisitDetailsList> {
  @override
  Widget build(BuildContext context) {
    final List<Visit> visits = Provider.of<List<Visit>>(context);
    return ListView.builder(
      itemCount: visits.length,
      itemBuilder: (context, index) {
        return MultiProvider(providers: [
          StreamProvider<Store>.value(
              value: DatabaseService(storeID: visits[index].storeID).store),
          StreamProvider<UserData>.value(
              value: DatabaseService(uid: visits[index].createdBy).userData)
        ], child: VisitDetailsTile(visit: visits[index]));
      },
    );
  }
}
