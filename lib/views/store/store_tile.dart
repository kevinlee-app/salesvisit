import 'package:flutter/material.dart';
import 'package:salesvisit/models/store.dart';
import 'package:salesvisit/views/store/store_details.dart';

class StoreTile extends StatelessWidget {
  final Store store;
  StoreTile({this.store});

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
          title: Text(store.name),
          subtitle: Text(store.ownerName),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoreDetails(isAdding: false, store: store,))),
        ),
      ),
    );
  }
}
