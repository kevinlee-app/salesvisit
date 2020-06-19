import 'package:flutter/material.dart';
import 'package:salesvisit/shared/arc_clipper.dart';
import 'package:salesvisit/shared/constants.dart';

class ClipBackground extends StatelessWidget {
  Widget topHalf(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Flexible(
      flex: 2,
      child: ClipPath(
        clipper: ArcClipper(),
        child: Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                colors: kitGradients,
              )),
            ),
            // Center(
            //   child: SizedBox(
            //       height: deviceSize.height / 8,
            //       width: deviceSize.width / 2,
            //       child: FlutterLogo(
            //         colors: Colors.yellow,
            //       )),
            // )
          ],
        ),
      ),
    );
  }

  final bottomHalf = new Flexible(
    flex: 3,
    child: new Container(),
  );

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[topHalf(context), bottomHalf],
    );
  }
}
