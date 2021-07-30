import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class type1 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Activity Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {goBackToPreviousScreen(context);},
          color: Colors.lightBlue,
          textColor: Colors.white,
          child: Text('Go Back To Previous Screen'),
        ),
      ),
    );
  }
  void goBackToPreviousScreen(BuildContext context){

    Navigator.pop(context);

  }

}
