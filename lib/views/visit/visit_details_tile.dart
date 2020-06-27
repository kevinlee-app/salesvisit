import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/store.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/models/visit.dart';
import 'package:salesvisit/views/visit/visit_details.dart';

class VisitDetailsTile extends StatefulWidget {
  final Visit visit;
  VisitDetailsTile({this.visit});

  @override
  _VisitDetailsTileState createState() => _VisitDetailsTileState();
}

class _VisitDetailsTileState extends State<VisitDetailsTile> {
  @override
  Widget build(BuildContext context) {
    final Store store = Provider.of<Store>(context);
    final UserData userData = Provider.of<UserData>(context);

    void _viewDetails() async {
      Visit visit = widget.visit;
      visit.store = store;
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VisitDetails(visit: visit, isAdding: false)),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Card(
        child: ListTile(
          onTap: _viewDetails,
          leading: Container(
            width: 76,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(widget.visit.photoPath),
                fit: BoxFit.contain,
              ),
              shape: BoxShape.rectangle,
            ),
          ),
          title: Text(store == null || userData == null ? "" : "Salesman : " + userData.name + "\nStore : " + store.name + "\n"),
          subtitle: Text(store == null || userData == null
              ? ""
              : '${DateFormat('MMM d yyyy, HH:mm:ss').format(widget.visit.createdDate)}'),
          trailing: Icon(Icons.more_vert),
          isThreeLine: true,
        ),
      ),
    );
  }
}
