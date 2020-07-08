import 'dart:async';

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
import 'package:salesvisit/views/store/store_details_qr.dart';

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
  Completer<GoogleMapController> _controller = Completer();

  Store store = Store();
  bool loading = false;
  bool enableEdit = false;
  bool isButtonHidden = true;
  String title = '';
  String error = '';
  IconData iconEdit = Icons.edit;
  LatLng _center = LatLng(45.521563, -122.677433);
  String search = '';

  Future<void> _onMapCreated(GoogleMapController controller) async {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }

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

  void _searchLocation() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    var splitted = search.split(", ");
    if(splitted.length < 2) {
      splitted = search.split(",");
    }
    
    if (splitted.length > 1) {
      double lat = double.tryParse(splitted[0]) ?? 0;
      double lang = double.tryParse(splitted[1]) ?? 0;
      LatLng coordinate = LatLng(lat, lang);

      final GoogleMapController controller = await _controller.future;
      setState(() {
        _center = coordinate;
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
  }

  Widget _detailsBody(User user) {
    return SingleChildScrollView(
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
                decoration: textInputDecoration.copyWith(labelText: "Name"),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: store.ownerName ?? '',
                enabled: enableEdit,
                validator: (val) => validatorAddStore("owner_name", val),
                onChanged: (val) {
                  setState(() {
                    store.ownerName = val;
                  });
                },
                decoration:
                    textInputDecoration.copyWith(labelText: "Owner Name"),
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
                decoration: textInputDecoration.copyWith(labelText: "Phone"),
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
                decoration: textInputDecoration.copyWith(labelText: "Email"),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              widget.isAdding ? _searchWidget() : Container(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 10,
                  ),
                  onMapCreated: _onMapCreated,
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: true,
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
                      store.lat = _center.latitude;
                      store.lang = _center.longitude;

                      dynamic result;
                      if (widget.isAdding) {
                        result = await DatabaseService(uid: user.uid)
                            .insertNewStore(store);
                      } else {
                        result = await DatabaseService(uid: user.uid)
                            .updateStore(store);
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
    );
  }

  Widget _detailsView(User user) {
    return loading
        ? Loading()
        : DefaultTabController(
            length: 2,
            child: Scaffold(
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
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.list)),
                    Tab(icon: Icon(Icons.center_focus_strong))
                  ],
                ),
              ),
              body: TabBarView(children: [
                _detailsBody(user),
                StoreDetailsQR(store: widget.store),
              ]),
            ),
          );
  }

  Widget _addingView(User user) {
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
            body: _detailsBody(user),
          );
  }

  Widget _searchWidget() {
    return Row(children: [
      Expanded(
        child: TextField(
          decoration: textInputDecoration.copyWith(
              labelText: "Search Location",
              hintText: "ex: -6.169097, 106.636442"),
          style: TextStyle(fontSize: 20),
          onChanged: (val) {
            setState(() {
              search = val;
            });
          },
        ),
      ),
      SizedBox(width: 20),
      Padding(
        padding: EdgeInsets.only(top: 14),
        child: RaisedButton(
          onPressed: _searchLocation,
          color: Colors.blue,
          child: Text('Search', style: TextStyle(color: Colors.white)),
        ),
      )
    ]);
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

    return widget.isAdding ? _addingView(user) : _detailsView(user);
  }
}
