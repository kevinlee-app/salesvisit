import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/store.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/models/visit.dart';
import 'package:salesvisit/services/database.dart';
import 'package:salesvisit/services/storage.dart';
import 'package:salesvisit/shared/constants.dart';
import 'package:salesvisit/shared/encrypter.dart';
import 'package:salesvisit/shared/loading.dart';
import 'package:salesvisit/extensions/string.dart';
import 'package:salesvisit/views/camera/camera.dart';

class VisitDetails extends StatefulWidget {
  final bool isAdding;
  final String storeCode;
  final UserData userData;
  VisitDetails({this.isAdding, this.storeCode, this.userData});

  @override
  _VisitDetailsState createState() => _VisitDetailsState();
}

class _VisitDetailsState extends State<VisitDetails> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, Marker> _markers = {};

  Visit visit = Visit();
  bool loading = false;
  bool enableEdit;
  bool isButtonHidden = false;
  String title;
  String error = '';
  String imagePath;
  IconData iconEdit = Icons.edit;
  LatLng _center = LatLng(45.521563, -122.677433);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    if (widget.isAdding) {
      _center = await _currentCoordinates();
    } else {
      _center = LatLng(visit.lat, visit.lang);
    }

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("currentLocation"),
        position: LatLng(_center.latitude, _center.longitude),
        infoWindow: InfoWindow(
          title: "Hello",
          snippet: "Snippet Hello",
        ),
      );
      _markers["currentLocation"] = marker;

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _center, zoom: 20.0),
        ),
      );
    });
  }

  Future<LatLng> _currentCoordinates() async {
    Position currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  String validatorAddStore(String type, String value) {
    switch (type) {
      case "description":
        break;
      default:
        return "";
    }
  }

  Widget _imageView(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: imagePath == null
              ? RaisedButton(
                  onPressed: _openCamera,
                  color: Colors.blue,
                  child: Text(
                    'Take a photo',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              : GestureDetector(
                  onTap: _openCamera,
                  child: Image.file(
                    File(imagePath),
                  ),
                ),
        ),
      ),
      Positioned(
        left: 8,
        child: Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          color: Colors.white,
          child: Text(
            'Photo',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    ]);
  }

  void _openCamera() async {
    final path = await Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => CameraScreen()),
    );
    setState(() => imagePath = path);
    print(imagePath);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isAdding) {
      title = "Add Visit";
      enableEdit = true;
      isButtonHidden = false;
    } else {
      title = "Visit Details";
      enableEdit = false;
      isButtonHidden = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Store>(
        stream:
            DatabaseService(uid: SVEncrypter().decrypt(widget.storeCode)).store,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            visit.store = snapshot.data;
            return loading
                ? Loading()
                : Scaffold(
                    resizeToAvoidBottomPadding: false,
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      title: Text(title),
                      actions: <Widget>[
                        widget.isAdding
                            ? Container()
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    isButtonHidden = !isButtonHidden;
                                    enableEdit = !enableEdit;
                                    if (enableEdit) {
                                      iconEdit = Icons.cancel;
                                    } else {
                                      iconEdit = Icons.edit;
                                    }
                                  });
                                },
                                icon: Icon(iconEdit),
                              )
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20),
                              TextFormField(
                                initialValue: visit.store.name ?? '',
                                enabled: false,
                                validator: (val) =>
                                    validatorAddStore("store_name", val),
                                onChanged: (val) {
                                  setState(() {
                                    visit.store.name = val;
                                  });
                                },
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Store Name"),
                                style: TextStyle(fontSize: 20),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: _center,
                                    zoom: 11,
                                  ),
                                  onMapCreated: _onMapCreated,
                                  rotateGesturesEnabled: false,
                                  scrollGesturesEnabled: false,
                                  tiltGesturesEnabled: false,
                                  markers: _markers.values.toSet(),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                maxLines: 10,
                                initialValue: visit.description ?? '',
                                validator: (val) =>
                                    validatorAddStore("description", val),
                                onChanged: (val) {
                                  setState(() {
                                    visit.description = val;
                                  });
                                },
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Description"),
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 20),
                              _imageView(context),
                              SizedBox(height: 30),
                              Visibility(
                                visible: !isButtonHidden,
                                child: RaisedButton(
                                  onPressed: () async {
                                    setState(() => loading = true);
                                    StorageServiceResult resultStorage =
                                        await StorageService().uploadImage(
                                            imageToUpload: File(imagePath),
                                            title: "");
                                    if (resultStorage.success) {
                                      visit.photoPath = imagePath;
                                      visit.lat = _center.latitude;
                                      visit.lang = _center.longitude;

                                      await DatabaseService(
                                              uid: widget.userData.uid)
                                          .insertNewVisit(visit)
                                          .then((value) {
                                            Navigator.pop(context);
                                          })
                                          .timeout(Duration(seconds: 10))
                                          .catchError((error) {
                                            setState(() {
                                              error = "Error";
                                              loading = false;
                                            });
                                          });
                                    }
                                  },
                                  color: Colors.blue,
                                  child: Text(
                                    widget.isAdding ? 'Add' : 'Edit',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                error,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          } else {
            return Loading();
          }
        });
  }
}