import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'RequestMicrophonePermissions.dart';

class RequestStoragePermissionsPage extends StatefulWidget {

  RequestStoragePermissionsPage({ Key? key}) : super(key: key);

  @override
  _RequestStoragePermissionsPageState createState() => _RequestStoragePermissionsPageState();
}

class _RequestStoragePermissionsPageState extends State<RequestStoragePermissionsPage> {

  final verticalScroll = ScrollController();
  bool showProgress = false;
  String? TutorialStatus;



  Future<String> createFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare');
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

  // This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData(String Data) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/RequestPermissions.txt');
    // If data.txt doesn't exist, it will be created automatically
    if ((await _myFile.exists())) {
      await _myFile.writeAsString(Data,  mode: FileMode.append);
    } else {
      await _myFile.writeAsString(Data);

    }
  }


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      //extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/grmain.png'),
                fit: BoxFit.fill
            )
        ),
        height: MediaQuery
            .of(context)
            .size
            .height,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ModalProgressHUD(
          inAsyncCall: showProgress,
          child:Scrollbar(
            isAlwaysShown: true,
            thickness: 0.0,
            //scrollbarOrientation: ScrollbarOrientation.bottom,
            controller: verticalScroll,
            child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                scrollDirection: Axis.vertical,
                controller: verticalScroll,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    const SizedBox(
                      height: 40.0,
                    ),

                  // Form Title
                    Container(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Container(
                        height: 60,
                        width: 60,
                        color: Colors.transparent,
                        child: Image.asset(
                          'assets/img/icareicon.png',
                          width: 50,
                          height: 50,
                          alignment: AlignmentDirectional.center,
                          // color: Colors.white,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),


                    const SizedBox(
                      height: 20.0,
                    ),

                    // Header 2
                    Container(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Container(
                        color: Colors.transparent,
                        child: const Text("Permission Request",
                          style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),),
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    // Form img
                    Container(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Container(
                        height: 200,
                        width: 600,
                        color: Colors.transparent,
                        child: Image.asset(
                          'assets/img/request1.png',
                          width: 200,
                          height: 500,
                          alignment: AlignmentDirectional.center,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    // Body
                    Container(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Container(
                          color: Colors.transparent,
                          child: const Text("The application needs to allow Access to manage all files in order to enable all features to function properly such as AI Analysis, reports and medical files ",textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),),

                      ),
                    ),

                    const SizedBox(
                      height: 40.0,
                    ),

                    Container(
                        height: 50,
                        width: 300.0,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Grant Permission'),
                          onPressed: ()  async {
                            try {
                              await Permission.storage.request();
                              createFolder();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder:
                                      (context) => RequestMicrophonePermissionsPage()
                                  )
                              );
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: "Permission Grant Failed!!"
                                      "Please try again",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.teal,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder:
                                      (context) => RequestStoragePermissionsPage()
                                  )
                              );
                            }
                          },
                        )
                    ),


                  ],
                )
            ),
          ),
        ),
      ),
    );
  }

}






