import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salesvisit/models/store.dart';
import 'package:salesvisit/models/user.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/models/visit.dart';

class DatabaseService {
  final String uid;
  final String visitID;
  DatabaseService({this.uid, this.visitID});

  final CollectionReference userDataCollection =
      Firestore.instance.collection("userdata");

  final CollectionReference storeCollection =
      Firestore.instance.collection("store");

  final CollectionReference visitCollection =
      Firestore.instance.collection("userdata");

  /* -> User Data */

  Future insertNewUserData(UserData userData) async {
    return await userDataCollection.document(uid).setData({
      'uid': uid,
      'name': userData.name,
      'email': userData.email,
      'phone': userData.phone,
      'type': 1,
      'createdDate': FieldValue.serverTimestamp(),
      'createdBy': uid,
      'modifiedDate': FieldValue.serverTimestamp(),
      'modifiedBy': uid
    });
  }

  Future updateUserData(UserData userData) async {
    return await userDataCollection.document(userData.uid).updateData({
      'name': userData.name,
      'email': userData.email,
      'phone': userData.phone,
      'type': userData.type,
      'modifiedDate': FieldValue.serverTimestamp(),
      'modifiedBy': uid
    });
  }

  List<UserData> _allUsersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((ud) {
      return UserData(
        email: ud.data['email'] ?? '',
        name: ud.data['name'] ?? '',
        phone: ud.data['phone'] ?? '',
        type: ud.data['type'] ?? 1,
      );
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      email: snapshot.data['email'] ?? '',
      name: snapshot.data['name'] ?? '',
      phone: snapshot.data['phone'] ?? '',
      type: snapshot.data['type'] ?? 1,
    );
  }

  Stream<List<UserData>> get allUsers {
    return userDataCollection.snapshots().map(_allUsersFromSnapshot);
  }

  Stream<UserData> get userData {
    return userDataCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  /* User Data  <- */

  /* -> Store */
  Future insertNewStore(Store store) async {
    DocumentReference docRef = storeCollection.document();
    return await docRef.setData({
      'documentID': docRef.documentID,
      'name': store.name,
      'ownerName': store.ownerName,
      'phone': store.phone,
      'email': store.email,
      'lat': store.lat,
      'lang': store.lang,
      'createdDate': FieldValue.serverTimestamp(),
      'createdBy': uid,
      'modifiedDate': FieldValue.serverTimestamp(),
      'modifiedBy': uid,
    });
  }

  Future updateStore(Store store) async {
    return await storeCollection.document(store.storeID).updateData({
      'name': store.name,
      'ownerName': store.ownerName,
      'phone': store.phone,
      'email': store.email,
      'lat': store.lat,
      'lang': store.lang,
      'modifiedDate': FieldValue.serverTimestamp(),
      'modifiedBy': uid,
    });
  }

  List<Store> _allStoreFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((store) {
      return Store(
        storeID: store.data['storeID'] ?? null,
        name: store.data['name'] ?? '',
        ownerName: store.data['ownerName'] ?? '',
        phone: store.data['phone'] ?? '',
        email: store.data['email'] ?? '',
        createdDate: store.data['createdDate'].toString() ?? '',
        createdBy: store.data['createdBy'] ?? '',
        modifiedDate: store.data['modifiedDate'].toString() ?? '',
        modifiedBy: store.data['modifiedBy'] ?? '',
        lat: double.parse(store.data['lat'].toString()) ?? 0,
        lang: double.parse(store.data['lang'].toString()) ?? 0,
      );
    }).toList();
  }

  Store _storeFromSnapshot(DocumentSnapshot snapshot) {
    return Store(
      name: snapshot.data['name'] ?? '',
      ownerName: snapshot.data['ownerName'] ?? '',
      phone: snapshot.data['phone'] ?? '',
      email: snapshot.data['email'] ?? '',
      createdDate: snapshot.data['createdDate'].toString() ?? '',
      createdBy: snapshot.data['createdBy'] ?? '',
      modifiedDate: snapshot.data['modifiedDate'].toString() ?? '',
      modifiedBy: snapshot.data['modifiedBy'] ?? '',
      lat: double.parse(snapshot.data['lat'].toString()) ?? 0,
      lang: double.parse(snapshot.data['lang'].toString()) ?? 0,
    );
  }

  Stream<List<Store>> get stores {
    return storeCollection.snapshots().map(_allStoreFromSnapshot);
  }

  Stream<Store> get store {
    return storeCollection.document(uid).snapshots().map(_storeFromSnapshot);
  }

  /* Store <- */

  /* -> Visit */

  Future<void> insertNewVisit(Visit visit) async {
    DocumentReference docRef =
        userDataCollection.document(uid).collection("visit").document();
    final response = await docRef.setData({
      'visitID': docRef.documentID,
      'storeID': visit.storeID,
      'description': visit.description,
      'photoPath': visit.photoPath,
      'lat': visit.lat,
      'lang': visit.lang,
      'createdDate': FieldValue.serverTimestamp(),
      'createdBy': uid,
      'modifiedDate': FieldValue.serverTimestamp(),
      'modifiedBy': uid,
    });

    return response;
  }

  Future updateVisit(Visit visit) async {
    return await userDataCollection
        .document(uid)
        .collection("visit")
        .document(visit.visitID)
        .updateData({
      'description': visit.description,
      'photoPath': visit.photoPath,
      'lat': visit.lat,
      'lang': visit.lang,
      'modifiedDate': FieldValue.serverTimestamp(),
      'modifiedBy': uid,
    });
  }

  List<Visit> _allVisitFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((visit) {
      return Visit(
        visitID: visit.data['visitID'] ?? null,
        storeID: visit.data['storeID'] ?? null,
        description: visit.data['description'] ?? '',
        photoPath: visit.data['photoPath'] ?? '',
        lat: double.parse(visit.data['lat'].toString()) ?? 0,
        lang: double.parse(visit.data['lang'].toString()) ?? 0,
        createdDate: visit.data['createdDate'].toString() ?? '',
        createdBy: visit.data['createdBy'] ?? '',
        modifiedDate: visit.data['modifiedDate'].toString() ?? '',
        modifiedBy: visit.data['modifiedBy'] ?? '',
      );
    }).toList();
  }

  Visit _visitFromSnapshot(DocumentSnapshot visit) {
    return Visit(
      visitID: visit.data['visitID'] ?? null,
      storeID: visit.data['storeID'] ?? null,
      description: visit.data['description'] ?? '',
      photoPath: visit.data['photoPath'] ?? '',
      lat: double.parse(visit.data['lat'].toString()) ?? 0,
      lang: double.parse(visit.data['lang'].toString()) ?? 0,
      createdDate: visit.data['createdDate'].toString() ?? '',
      createdBy: visit.data['createdBy'] ?? '',
      modifiedDate: visit.data['modifiedDate'].toString() ?? '',
      modifiedBy: visit.data['modifiedBy'] ?? '',
    );
  }

  int _userVisitsCount(QuerySnapshot visit) {
    return visit.documents.length;
  }

  Stream<List<Visit>> get visits {
    return userDataCollection
        .document(uid)
        .collection("visit")
        .snapshots()
        .map(_allVisitFromSnapshot);
  }

  Stream<Visit> get visit {
    return userDataCollection
        .document(uid)
        .collection("visit")
        .document(visitID)
        .snapshots()
        .map(_visitFromSnapshot);
  }

  Stream<int> get totalVisit {
    return userDataCollection
        .document(uid)
        .collection("visit")
        .snapshots()
        .map(_userVisitsCount);
  }

  /* Visit <- */
}
