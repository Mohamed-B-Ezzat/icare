import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:icare/HomePage.dart';
import 'package:icare/RegisterScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum ImageSourceType { gallery, camera }

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  String TypePath;
  //ImageFromGalleryEx(this.type);

  final ImageStorage storage;

  ImageFromGalleryEx(this.TypePath,this.type, {Key? key, required this.storage}) : super(key: key);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type,this.TypePath);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;
  var TypePath;
  ImageFromGalleryExState(this.type,this.TypePath);


  Future<void> _getDirPath() async {
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile imagefile = await imagePicker.pickImage(
        source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = imagefile;
    });
  }


  @override
  void initState() {
    imagePicker = new ImagePicker();
    _getDirPath();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from Camera"
              : "Image from Gallery"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color.fromRGBO(47, 150, 185, 1), Color.fromRGBO(84, 199, 212, 1),Color.fromRGBO(47, 150, 185, 1)])
          ),
        ),
        elevation: 0,

      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 52,
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // GestureDetector(
                //   onTap: () async {
                //     var source = type == ImageSourceType.camera
                //         ? ImageSource.camera
                //         : ImageSource.gallery;
                //     XFile imagefile = await imagePicker.pickImage(
                //         source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                //     setState(() {
                //       _image = imagefile;
                //     });
                //     // widget.storage._writeData(_image!.path, "icare_picture");
                //     // Navigator.pop(context);
                //   },
                  //child:
                  Container(
                    alignment: Alignment.center,
                    margin:const EdgeInsets.fromLTRB(70, 20, 70, 20),
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                        color: Colors.transparent),
                    child: _image != null
                        ? Image.file(
                      File(_image.path),
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      // decoration: const BoxDecoration(
                      //     color: Colors.transparent,
                      // borderRadius: BorderRadius.all(Radius.circular(20)),),
                      width: 200,
                      height: 200,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 100,
                        color: Color.fromRGBO(32, 116, 150, 1.0),
                      ),
                    ),
                  ),
                //),
                Container(
                    height: 50,
                    width: 200.0,
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: ElevatedButton.icon(
                      onPressed: () async{
                        if(TypePath!= "")
                        {
                          widget.storage._writeModulesData(TypePath.toString(),_image!.path, "icare_pictures");
                        }
                        else
                        {
                          widget.storage._writeData(TypePath.toString(), _image!.path, "icare_picture");
                        }
                        Navigator.pop(context,_image!.path);
                      },
                      icon: Icon(Icons.done, color: Colors.white,size: 30.0),
                      label: const Text('Confirm',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)
                      ),
                      style: ElevatedButton.styleFrom(
                        // primary: Color.fromRGBO(66, 133, 244, 1.0),
                        primary: Colors.teal,
                        side: const BorderSide(width: 1.0, color: Colors.teal),
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                    ),
                ),
              ]

          )
        ],
      ),
    );
  }
}




class ImageStorage
{
  // Find the Documents path
  Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<String> createFolder(String ImagePath) async {
    const folderName = "ICare";
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare'+ImagePath);
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

  // This function is triggered when the "Read" button is pressed
  Future<void> _readData(String ImagePath, String Filename) async {
    final dirPath = await createFolder(ImagePath);
    final myFile = File('$dirPath/'+Filename+'.txt');
    final data = await myFile.readAsString(encoding: utf8);

  }

  // This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData(String ImagePath, String Data, String Filename) async {
    final _dirPath = await createFolder(ImagePath);

    final _myFile = File('$_dirPath/'+Filename+'.txt');
    // If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString(Data);
  }

  // This function is triggered when the "Write" buttion is pressed
  Future<void> _writeModulesData(String ImagePath, String Data, String Filename) async {
    final _dirPath = await createFolder(ImagePath);

    final _myFile = File('$_dirPath/'+Filename+'.txt');
    // If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString("$Data\n",mode: FileMode.append);
  }
}