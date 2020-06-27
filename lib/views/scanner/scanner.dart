import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/views/visit/visit_details.dart';

class Scanner extends StatelessWidget {
  final UserData userData;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Scanner({this.userData});

  void _onFlash() {
    print('Flash');
    controller.toggleFlash();
  }

  void _onSwitch() {
    print('Switch');
    controller.flipCamera();
  }

  @override
  Widget build(BuildContext context) {
    void _onQRViewCreated(QRViewController controller) {
      this.controller = controller;

      controller.scannedDataStream.listen((scanData) async {
        this.controller.pauseCamera();

        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VisitDetails(storeCode: scanData, isAdding: true, userData: userData,)),
        );

        this.controller.resumeCamera();
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            overlay: QrScannerOverlayShape(
              cutOutSize: 350,
              borderColor: Colors.blue,
              borderRadius: 5,
              borderWidth: 8,
            ),
            onQRViewCreated: _onQRViewCreated,
          ),
          Positioned(
            left: 8,
            top: 30,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 100,
            child: Column(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                  iconSize: 26,
                  onPressed: _onFlash,
                  icon: Icon(
                    Icons.flash_on,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'Flash',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ]),
          ),
          Positioned(
            bottom: 50,
            left: 100,
            child: Column(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                  iconSize: 26,
                  onPressed: _onSwitch,
                  icon: Icon(
                    Icons.switch_camera,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'Switch',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
