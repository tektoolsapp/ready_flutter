//import 'dart:html';
//import 'dart:html';
//import 'dart:html';

import "package:async/async.dart";
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';
import 'package:flutter_ready_prod/components/Loading.dart';
import 'package:flutter_ready_prod/screens/TakePhotoPage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class PhotoScreen extends StatefulWidget {
  @override 
  _PhotoScreenState createState() => _PhotoScreenState(); 
}

class _PhotoScreenState extends State<PhotoScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String _path = null;
  bool _isLoading = false;

  void _showPhotoLibrary() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _path = file.path;
    });

  }

  prepareLoading(_path){
    setState(() {
      _isLoading = true;
    });
    uploadImageToServer(_path);
  }
  
  void uploadImageToServer(String _path) async {
    
    print("LOADING: $_isLoading");
    
    File imageFile = new File(_path);
    String fileName = _path.split('/').last;

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept-Charset': 'UTF-8'
    };

    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    print(imageFile.path);

    var uri = Uri.parse("https://mob.readyresourcesapp.com.au/api/upload/files");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('File', stream, length,
        filename: fileName);

    request.headers.addAll(headers);
    request.fields['user_id'] = '1';

    print(multipartFile.filename);
    print(uri);
    print(multipartFile.length);

    request.files.add(multipartFile);

    print(request.contentLength);

    var response = await request.send();

    print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);

      setState(() {
        _isLoading = false;
      });

      scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Photo was Successfully Uploaded")
            //duration: Duration(seconds: 2),
          ));
    });
  }

  void _showCamera(context) async {

    final cameras = await availableCameras();
    final camera = cameras.first;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePhotoPage(camera: camera)));
  
    setState(() {
      _path = result; 
    });
  
  }
  
  void _showOptions(BuildContext context) {
    
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          child: Column(children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text("Take a picture from camera"),
              onTap: () {
                //Navigator.of(context).pop();
                  // show the camera
                  _showCamera(context);
              },
            ), 
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from photo library"),
              onTap: () => {
                Navigator.pop(context),
                _showPhotoLibrary()
              },
            )
          ])
        );
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {

    final buttonColor = const Color(0xFF27447E);
    //final buttonText = const Color(0xFFFFFFFF);
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
         title: Text("Photos") 
      ),
      //drawer: AppDrawer().build(context),
      //bottomNavigationBar: BottomNav(),
      body: SafeArea(
          child: Column(children: <Widget>[
          _path == null ? FractionallySizedBox(
              alignment: Alignment.topCenter,
              widthFactor: 1.0,
              child: Container(
                height: 50,
              ),
            ) : 

            Container(
            height: 400,
            //alignment: Alignment.center, // This is needed
            child: Image.file(
              File(_path),
              //fit: BoxFit.contain,
              //height: 200,
            ),
          ),
          _path == null ? FractionallySizedBox(
              //alignment: Alignment.topCenter,
              widthFactor: 1.0,
              child: Container(
                height: 0,
              ),
            )
          : Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            child: FlatButton(
              child: Text(
                "Save Photo", 
                style: TextStyle(
                  fontSize: 25, 
                  color: Colors.white
                )
              ),
              color: buttonColor, 
              height: 60,
              onPressed: () => {
                //uploadImageToServer(_path)
                prepareLoading(_path)
              },
            )
          ), 
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            child: FlatButton(
              child: Text(
                "Select Photo", 
                style: TextStyle(
                  fontSize: 25, 
                  color: Colors.white
                )
              ),
              color: buttonColor, 
              //width: double.infinity,
              height: 60,
              onPressed: () => {
                _showOptions(context)
              },
            )
          ),
          SizedBox(height: 40.0,),
          _isLoading ? 
            Loading() :
            FractionallySizedBox(
              alignment: Alignment.topCenter,
              widthFactor: 1.0,
              child: Container(
                height: 50,
              ),
            )  
        ]),
      )
    );
  }

}