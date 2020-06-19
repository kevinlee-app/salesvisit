import 'package:flutter/material.dart';

class CustomButtonSubmit extends StatelessWidget {
  final Function onPressed;
  final double width;
  final double height;
  final String text;

  CustomButtonSubmit({this.onPressed, this.width, this.height, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), side: BorderSide.none),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.blue[300],
                Colors.lightBlue[200],
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            constraints: BoxConstraints(minWidth: 88.0, minHeight: 36.0),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
