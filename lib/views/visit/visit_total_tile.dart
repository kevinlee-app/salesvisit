import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/services/database.dart';

class VisitTotalTile extends StatelessWidget {
  final UserData userData;

  VisitTotalTile({this.userData});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<int>.value(
      initialData: 0,
      value: DatabaseService(uid: userData.uid).totalVisit,
      child: Builder(builder: (BuildContext context) {
        final int totalVisit = Provider.of<int>(context);
        return Container(
          width: MediaQuery.of(context).size.width * 0.55,
          child: Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Container(
                  //   width: 76,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5),
                  //     image: DecorationImage(
                  //       image: NetworkImage(
                  //           'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                  //       fit: BoxFit.fill,
                  //     ),
                  //     shape: BoxShape.rectangle,
                  //   ),
                  // ),
                  FlutterLogo(size: 60),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$totalVisit Visit',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          userData.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
