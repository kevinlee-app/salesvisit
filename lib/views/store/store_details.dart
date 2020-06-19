import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/store.dart';
import 'package:salesvisit/services/database.dart';
import 'package:salesvisit/shared/constants.dart';
import 'package:salesvisit/shared/loading.dart';
import 'package:salesvisit/extensions/string.dart';
import 'package:salesvisit/models/user.dart';
import 'package:geolocator/geolocator.dart';

class StoreDetails extends StatefulWidget {
  final bool isAdding;
  final Store store;
  StoreDetails({this.isAdding, this.store});

  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, Marker> _markers = {};

  Store store = Store();
  bool loading = false;
  bool enableEdit = false;
  bool isButtonHidden = true;
  String title = '';
  String error = '';
  IconData iconEdit = Icons.edit;
  LatLng _center = LatLng(45.521563, -122.677433);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    if (widget.isAdding) {
      _center = await _currentCoordinates();
    } else {
      _center = LatLng(store.lat, store.lang);
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
      case "email":
        if (!value.isValidEmail()) {
          return "Please enter an valid email address";
        }
        break;
      case "owner_name":
        if (value.isEmpty) {
          return "Please enter owner name";
        }
        break;
      case "phone":
        if (!value.isValidPhone()) {
          return "Please enter valid phone number";
        }
        break;
      case "name":
        if (value.isEmpty) {
          return "Please enter name";
        }
        break;
      default:
        return "";
    }
  }

  @override
  initState() {
    super.initState();

    if (widget.isAdding) {
      title = "Add New Store";
      enableEdit = true;
      isButtonHidden = false;
    } else {
      title = "Store Details";
      enableEdit = false;
      isButtonHidden = true;
      store = widget.store;
    }
  }

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

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
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: store.name ?? '',
                        enabled: enableEdit,
                        validator: (val) => validatorAddStore("name", val),
                        onChanged: (val) {
                          setState(() {
                            store.name = val;
                          });
                        },
                        decoration:
                            textInputDecoration.copyWith(labelText: "Name"),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: store.ownerName ?? '',
                        enabled: enableEdit,
                        validator: (val) =>
                            validatorAddStore("owner_name", val),
                        onChanged: (val) {
                          setState(() {
                            store.ownerName = val;
                          });
                        },
                        decoration: textInputDecoration.copyWith(
                            labelText: "Owner Name"),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: store.phone,
                        enabled: enableEdit,
                        validator: (val) => validatorAddStore("phone", val),
                        onChanged: (val) {
                          setState(() {
                            store.phone = val;
                          });
                        },
                        decoration:
                            textInputDecoration.copyWith(labelText: "Phone"),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: store.email,
                        enabled: enableEdit,
                        validator: (val) => validatorAddStore("email", val),
                        onChanged: (val) {
                          setState(() {
                            store.email = val;
                          });
                        },
                        decoration:
                            textInputDecoration.copyWith(labelText: "Email"),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
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
                          myLocationButtonEnabled: true,
                          markers: _markers.values.toSet(),
                        ),
                      ),
                      SizedBox(height: 30),
                      Visibility(
                        visible: !isButtonHidden,
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              LatLng currentCoordinate =
                                  await _currentCoordinates();
                              store.lat = currentCoordinate.latitude;
                              store.lang = currentCoordinate.longitude;

                              dynamic result;
                              if(widget.isAdding){
                                result = await DatabaseService(uid: user.uid)
                                      .insertNewStore(store);
                              } else {
                                result = await DatabaseService(uid: user.uid).updateStore(store);
                              }
                              
                              if (result == null) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          color: Colors.blue,
                          child: Text(
                            widget.isAdding ? 'Add' : 'Edit',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
