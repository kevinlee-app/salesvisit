import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:salesvisit/models/store.dart';
import 'package:salesvisit/shared/encrypter.dart';
import 'dart:ui' as ui;

import 'package:wc_flutter_share/wc_flutter_share.dart';

class StoreDetailsQR extends StatefulWidget {
  final Store store;
  StoreDetailsQR({this.store});

  @override
  _StoreDetailsQRState createState() => _StoreDetailsQRState();
}

class _StoreDetailsQRState extends State<StoreDetailsQR> {
  GlobalKey globalKey = GlobalKey();

  void _onShare() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    await WcFlutterShare.share(
        sharePopupTitle: "Store QR Code",
        subject: widget.store.name,
        text: widget.store.name,
        fileName: 'qrshare.png',
        mimeType: 'image/png',
        bytesOfFile: byteData.buffer.asUint8List());
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.all(12),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           width: 300,
  //           height: 350,
  //           child: RepaintBoundary(
  //             key: this.globalKey,
  //             child: Container(
  //               child: Column(
  //                 children: [
  //                   QrImage(
  //                     data: SVEncrypter().encrypt(widget.store.storeID),
  //                     gapless: false,
  //                     version: QrVersions.auto,
  //                   ),
  //                   SizedBox(height: 20),
  //                   Text(widget.store.name),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 30),
  //         RaisedButton(
  //           color: Colors.blue,
  //           onPressed: _onShare,
  //           child: Text(
  //             'Share',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //         SizedBox(height: 50)
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            width: 300,
            height: 330,
            top: 30,
            child: RepaintBoundary(
              key: this.globalKey,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(3, 3),
                    )
                  ],
                  color: Colors.white,
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(children: [
                  QrImage(
                    data:  SVEncrypter().encrypt(widget.store.storeID),
                    gapless: false,
                    version: QrVersions.auto,
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.store.name,
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
            ),
          ),
          Positioned(
            top: 380,
            child: RaisedButton(
              color: Colors.blue,
              onPressed: _onShare,
              child: Text(
                'Share',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
