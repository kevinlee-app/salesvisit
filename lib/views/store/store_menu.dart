import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/store.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/services/auth.dart';
import 'package:salesvisit/services/database.dart';
import 'package:salesvisit/views/store/store_details.dart';
import 'package:salesvisit/views/store/store_list.dart';

class StoreMenu extends StatefulWidget {
  @override
  _StoreMenuState createState() => _StoreMenuState();
}

class _StoreMenuState extends State<StoreMenu> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Store>>.value(
      initialData: List(),
      value: DatabaseService().stores,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Text('Stores'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StoreDetails(isAdding: true)));
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: StoreList(),
      ),
    );
  }
}
