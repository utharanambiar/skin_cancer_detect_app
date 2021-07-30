import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transfer_learning_fruit_veggies/routes/pageRoutes.dart';
import 'package:transfer_learning_fruit_veggies/main.dart';

import 'SubPage.dart';
//import 'package:transfer_learning_fruit_veggies/main.dart';

class Home extends StatefulWidget {
  static const String routeName = '/homePage';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;
  final picker = ImagePicker(); //allows us to pick image from gallery or camera

  @override
  void initState() {
    //initS is the first function that is executed by default when this class is called
    super.initState();
    Tflite.loadModel(
        model: 'assets/skin_lads2.tflite', labels: 'assets/labels1.txt').then((
        value) {
      setState(() {});
    });
    Tflite.loadModel(
        model: 'assets/skin_lads2.tflite', labels: 'assets/labels1.txt');
  }

  @override
  void dispose() {
    //dis function disposes and clears our memory
    super.dispose();
    Tflite.close();
  }

  Future classifyImage(File image) async {
    //this function runs the model on the image
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 7,
      //the amout of categories our neural network can predict
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  Future loadModel() async {
    //this function loads our model
    await Tflite.loadModel(
        model: 'assets/skin_lads2.tflite', labels: 'assets/labels1.txt');
  }

  Future pickImage() async {
    //this function to grab the image from camera
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  Future pickGalleryImage() async {
    //this function to grab the image from gallery
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }
  Future navigateToSubPage() async {
    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => SubPage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff).withOpacity(1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(margin: EdgeInsets.only(top: 35.0),),
            Image.asset(
              'assets/logo_transparent2.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF735d78).withOpacity(0.7),
              ),
              child: Text('Hello User!',
                style: TextStyle(fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                //Home();
                Navigator.pushReplacementNamed(context, pageRoutes.homepage);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Read more'),
              onTap: () {
                //navigateToSubPage();
                Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => NewScreen()));
                //Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*Container(
              child: Image.asset('assets/logo_transparent.png'),
              height: 200,
              width: 200,
              //child: Image.asset('assets/logo_transparent.png'),
              //margin: EdgeInsets.fromLTRB(10.0, 60.0, 0.0, 20.0),
            ),*/
          Container(
            //color: Color(0xFFedf2fb).withOpacity(0.5),
            margin: EdgeInsets.only(top: 80.0),
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Color(0xFFd1b3c4).withOpacity(0.25),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                      child: _loading == true
                          ? Container(
                        child: Column(
                          children: [
                            Container(
                              height: 250,
                              width: 250,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset('assets/upload.png'),
                              ),
                            ),
                            Divider(
                              height: 25,
                              thickness: 1,
                            ),
                            Text(
                              'Please upload an image!',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                            Divider(
                              height: 25,
                              thickness: 1,
                            ),
                          ],
                        ),
                      )

                          : Container(
                        child: Column(
                          children: [
                            Container(
                              height: 250,
                              width: 250,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Divider(
                              height: 25,
                              thickness: 1,
                            ),
                            _output != null
                                ? Text(
                              'The type is: ${_output[0]['label']}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            )
                                : Text(
                              'The type is:!',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                            Divider(
                              height: 25,
                              thickness: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: pickGalleryImage,
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 200,
                            alignment: Alignment.center,
                            padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                            margin: EdgeInsets.fromLTRB(0, 60, 0, 10),
                            decoration: BoxDecoration(
                                color: Color(0xFF735d78).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              'Upload Sample',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(margin: EdgeInsets.only(top: 35.0),),
            Image.asset(
              'assets/logo_transparent2.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF735d78).withOpacity(0.7),
              ),
              child: Text('Hello User!',
                style: TextStyle(fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, pageRoutes.homepage);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Read more'),
              onTap: () {
                //Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(margin: EdgeInsets.only(top: 35.0),),
            Image.asset(
              'assets/logo_transparent2.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      body: Center(
    child: Container(
    child: Column(
    children: [
      GestureDetector(
      onTap: () {
      Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => type1()),
      );
      },
      child: Container(

        width: MediaQuery
            .of(context)
            .size
            .width - 200,
        alignment: Alignment.center,
        padding:
        EdgeInsets.symmetric(horizontal: 22, vertical: 17),
        margin: EdgeInsets.fromLTRB(60, 60, 50, 10),
        decoration: BoxDecoration(

            color: Color(0xFF735d78).withOpacity(0.7),
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          'Melanoma',
          style: TextStyle(
              color: Colors.white, fontSize: 16),
        ),
      ),
    ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => type2()),
          );
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width - 200,
          alignment: Alignment.center,
          padding:
          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
          margin: EdgeInsets.fromLTRB(60, 30, 50, 10),
          decoration: BoxDecoration(
              color: Color(0xFF735d78).withOpacity(0.7),
              borderRadius: BorderRadius.circular(15)),
          child: Text(
            'Melanocytic Nevi',
            style: TextStyle(
                color: Colors.white, fontSize: 16),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => type3()),
          );
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width - 200,
          alignment: Alignment.center,
          padding:
          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
          margin: EdgeInsets.fromLTRB(60, 30, 50, 10),
          decoration: BoxDecoration(
              color: Color(0xFF735d78).withOpacity(0.7),
              borderRadius: BorderRadius.circular(15)),
          child: Text(
            'Actinic Keratosis',
            style: TextStyle(
                color: Colors.white, fontSize: 16),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => type4()),
          );
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width - 200,
          alignment: Alignment.center,
          padding:
          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
          margin: EdgeInsets.fromLTRB(60, 30, 50, 10),
          decoration: BoxDecoration(
              color: Color(0xFF735d78).withOpacity(0.7),
              borderRadius: BorderRadius.circular(15)),
          child: Text(
            'Dermatofibroma',
            style: TextStyle(
                color: Colors.white, fontSize: 16),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => type5()),
          );
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width - 200,
          alignment: Alignment.center,
          padding:
          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
          margin: EdgeInsets.fromLTRB(60, 30, 50, 10),
          decoration: BoxDecoration(
              color: Color(0xFF735d78).withOpacity(0.7),
              borderRadius: BorderRadius.circular(15)),
          child: Text(
            'Vascular Lesions',
            style: TextStyle(
                color: Colors.white, fontSize: 16),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => type6()),
          );
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width - 150,
          alignment: Alignment.center,
          padding:
          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
          margin: EdgeInsets.fromLTRB(60, 30, 50, 10),
          decoration: BoxDecoration(
              color: Color(0xFF735d78).withOpacity(0.7),
              borderRadius: BorderRadius.circular(15)),
          child: Text(
            'Basal Cell Carcinoma',
            style: TextStyle(
                color: Colors.white, fontSize: 16),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => type7()),
          );
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width - 150,
          alignment: Alignment.center,
          padding:
          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
          margin: EdgeInsets.fromLTRB(60, 30, 50, 10),
          decoration: BoxDecoration(
              color: Color(0xFF735d78).withOpacity(0.7),
              borderRadius: BorderRadius.circular(15)),
          child: Text(
            'Benign Keratosis-like Lesions',
            style: TextStyle(
                color: Colors.white, fontSize: 16),
          ),
        ),
      ),
        ],
      ),
    ),
    ),
    );
  }
}

class type1 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey),
      title: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(margin: EdgeInsets.only(top: 35.0),),
          Image.asset(
            'assets/logo_transparent2.png',
            fit: BoxFit.contain,
            height: 200,
            width: 200,
          ),
        ],
      ),
    ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.asset('assets/mel.jpg'),
            height: 200,
            width: 300,
            //decoration: BoxDecoration( borderRadius: BorderRadius.circular(30)),
            //child: Image.asset('assets/logo_transparent.png'),
            margin: EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 20.0),
          ),
          Container(
            child: Text("Melanoma", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, color: Colors.black87)),
            margin: EdgeInsets.fromLTRB(30.0, 40.0, 20.0, 10.0),
          ),
          Container(
            //color: Color(0xFFedf2fb).withOpacity(0.5),
            margin: EdgeInsets.only(top: 00.0),
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
    ),
           Container(
             child: Column(
               children: <Widget>[
                 Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFd1b3c4).withOpacity(0.25),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
                    child: Text("Melanoma, the most serious type of skin cancer, develops in the cells (melanocytes) that produce "
                        "melanin — the pigment that gives your skin its color. Exposure to ultraviolet (UV) radiation from "
                        "sunlight or tanning lamps and beds increases your risk of developing melanoma."
                        " Limiting your exposure to UV radiation can help reduce your risk of melanoma.",
                    style: TextStyle(fontSize: 17, height: 1.4)),
    ),

        ],
        ),

      ),
    ],
      ),
    );
  }

}

class type2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(margin: EdgeInsets.only(top: 35.0),),
            Image.asset(
              'assets/logo_transparent2.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.asset('assets/mn.jpg'),
            height: 200,
            width: 300,
            //decoration: BoxDecoration( borderRadius: BorderRadius.circular(30)),
            //child: Image.asset('assets/logo_transparent.png'),
            margin: EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 20.0),
          ),
          Container(
            child: Text("Melanocytic Nevi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, color: Colors.black87)),
            margin: EdgeInsets.fromLTRB(30.0, 40.0, 20.0, 10.0),
          ),
          Container(
            //color: Color(0xFFedf2fb).withOpacity(0.5),
            margin: EdgeInsets.only(top: 00.0),
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFd1b3c4).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text("A usually non-cancerous disorder of pigment-producing skin cells commonly "
                      "called birth marks or moles. This type of mole is often large and caused "
                      "by a disorder involving melanocytes, cells that produce pigment (melanin)."
                      "Most cases don't require treatment, but some cases require removal of the mole.",
                      style: TextStyle(fontSize: 17, height: 1.4)),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }

}

class type3 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(margin: EdgeInsets.only(top: 35.0),),
            Image.asset(
              'assets/logo_transparent2.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.asset('assets/ak.jpg'),
            height: 200,
            width: 300,
            //decoration: BoxDecoration( borderRadius: BorderRadius.circular(30)),
            //child: Image.asset('assets/logo_transparent.png'),
            margin: EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 20.0),
          ),
          Container(
            child: Text("Actinic Keratosis", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, color: Colors.black87)),
            margin: EdgeInsets.fromLTRB(30.0, 40.0, 20.0, 10.0),
          ),
          Container(
            //color: Color(0xFFedf2fb).withOpacity(0.5),
            margin: EdgeInsets.only(top: 00.0),
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFd1b3c4).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text("It is a rough, scaly patch on the skin that develops from years of sun"
                      " exposure. It's often found on the face, lips, ears, forearms, scalp, neck "
                      "or back of the hands. The rough, scaly skin patch enlarges slowly and usually "
                      "causes no other signs or symptoms. A lesion may take years to develop."
                      " Because it can become cancerous, it's usually removed as a precaution.",
                      style: TextStyle(fontSize: 17, height: 1.4)),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }

}

class type4 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(margin: EdgeInsets.only(top: 35.0),),
            Image.asset(
              'assets/logo_transparent2.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.asset('assets/df.jpg'),
            height: 200,
            width: 300,
            //decoration: BoxDecoration( borderRadius: BorderRadius.circular(30)),
            //child: Image.asset('assets/logo_transparent.png'),
            margin: EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 20.0),
          ),
          Container(
            child: Text("Dermatofibroma", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, color: Colors.black87)),
            margin: EdgeInsets.fromLTRB(30.0, 40.0, 20.0, 10.0),
          ),
          Container(
            //color: Color(0xFFedf2fb).withOpacity(0.5),
            margin: EdgeInsets.only(top: 00.0),
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFd1b3c4).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text("Dermatofibroma (superficial benign fibrous histiocytoma) is a common "
                      "cutaneous nodule of unknown etiology that occurs more often in women. "
                      "Dermatofibroma frequently develops on the extremities (mostly the lower legs)"
                      " and is usually asymptomatic, although pruritus and tenderness can be present."
                      "Unless they are removed surgically, the nodules will remain within the skin.",
                      style: TextStyle(fontSize: 17, height: 1.4)),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }

}

class type5 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(margin: EdgeInsets.only(top: 35.0),),
            Image.asset(
              'assets/logo_transparent2.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.asset('assets/vl.jpg'),
            height: 200,
            width: 300,
            //decoration: BoxDecoration( borderRadius: BorderRadius.circular(30)),
            //child: Image.asset('assets/logo_transparent.png'),
            margin: EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 20.0),
          ),
          Container(
            child: Text("Vascular lesions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, color: Colors.black87)),
            margin: EdgeInsets.fromLTRB(30.0, 40.0, 20.0, 10.0),
          ),
          Container(
            //color: Color(0xFFedf2fb).withOpacity(0.5),
            margin: EdgeInsets.only(top: 00.0),
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFd1b3c4).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text("Vascular lesions are relatively common abnormalities"
                      " of the skin and underlying tissues, more commonly known as birthmarks."
                      "Laser treatment is usually the best option for vascular lesions of the face. "
                      "Deeper veins may need treatment with surgery "
                      "or very small lasers that are inserted into larger blood vessels.",
                      style: TextStyle(fontSize: 17, height: 1.4)),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }

}

class type6 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(margin: EdgeInsets.only(top: 35.0),),
            Image.asset(
              'assets/logo_transparent2.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.asset('assets/bcc.jpg'),
            height: 200,
            width: 300,
            //decoration: BoxDecoration( borderRadius: BorderRadius.circular(30)),
            //child: Image.asset('assets/logo_transparent.png'),
            margin: EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 20.0),
          ),
          Container(
            child: Text("Basal Cell Carcinoma", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, color: Colors.black87)),
            margin: EdgeInsets.fromLTRB(30.0, 40.0, 20.0, 10.0),
          ),
          Container(
            //color: Color(0xFFedf2fb).withOpacity(0.5),
            margin: EdgeInsets.only(top: 00.0),
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFd1b3c4).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text("A type of skin cancer that begins in the basal cells."
                      "Basal cells produce new skin cells as old ones die. "
                      "Limiting sun exposure can help prevent these cells from becoming cancerous."
                      "This cancer typically appears as a white, waxy lump or a brown, scaly patch "
                      "on sun-exposed areas, such as the face and neck.",
                      style: TextStyle(fontSize: 17, height: 1.4)),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }

}

class type7 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(margin: EdgeInsets.only(top: 35.0),),
            Image.asset(
              'assets/logo_transparent2.png',
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.asset('assets/bkl.jpg'),
            height: 200,
            width: 300,
            //decoration: BoxDecoration( borderRadius: BorderRadius.circular(30)),
            //child: Image.asset('assets/logo_transparent.png'),
            margin: EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 20.0),
          ),
          Container(
            child: Text("Benign Keratosis-like Lesions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic, color: Colors.black87)),
            margin: EdgeInsets.fromLTRB(30.0, 40.0, 20.0, 10.0),
          ),
          Container(
            //color: Color(0xFFedf2fb).withOpacity(0.5),
            margin: EdgeInsets.only(top: 00.0),
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFd1b3c4).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text("A seborrhoeic keratosis is one of the most common non-cancerous skin growths in older adults. "
                      "While it's possible for one to appear on its own, multiple growths are more common."
                      "Seborrheic keratosis often appears on the face, chest, shoulders or back. It has a waxy, scaly, slightly elevated appearance."
                      "No treatment is necessary.",
                      style: TextStyle(fontSize: 17, height: 1.4)),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }

}



