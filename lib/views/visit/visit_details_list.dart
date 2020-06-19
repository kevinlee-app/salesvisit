import 'package:flutter/material.dart';
import 'package:salesvisit/views/visit/visit_details_tile.dart';

class VisitDetailsList extends StatefulWidget {
  @override
  _VisitDetailsListState createState() => _VisitDetailsListState();
}

class _VisitDetailsListState extends State<VisitDetailsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return VisitDetailsTile();
        },
      ),
    );
  }
}
