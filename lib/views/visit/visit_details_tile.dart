import 'package:flutter/material.dart';

class VisitDetailsTile extends StatefulWidget {
  @override
  _VisitDetailsTileState createState() => _VisitDetailsTileState();
}

class _VisitDetailsTileState extends State<VisitDetailsTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FlutterLogo(size: 72.0),
      title: Text('Three-line ListTile'),
      subtitle: Text('A sufficiently long subtitle warrants three lines.'),
      trailing: Icon(Icons.more_vert),
      isThreeLine: true,
    );
  }
}
