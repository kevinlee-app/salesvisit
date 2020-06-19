import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/views/store/store_tile.dart';
import 'package:salesvisit/views/user/user_tile.dart';
import 'package:salesvisit/models/store.dart';

class StoreList extends StatefulWidget {
  @override
  _StoreListState createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  @override
  Widget build(BuildContext context) {
    final stores = Provider.of<List<Store>>(context);
    return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, index) {
        return StoreTile(store: stores[index]);
      },
    );
  }
}