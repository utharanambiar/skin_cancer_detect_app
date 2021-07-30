import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: 'Skin Cancer Recognition',
      theme: ThemeData(fontFamily: 'SF Pro'),
      //home: Home(),
      home: SplashScreenPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0);
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new Home(),
      backgroundColor: Colors.white,
      image: Image.asset('assets/logo_transparent2.png'),

      loadingText: Text("\t\t\tDisclaimer: The Content is not intended to be a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition"),
      photoSize: 150.0,
      loaderColor: Colors.black,

    );
  }
}
