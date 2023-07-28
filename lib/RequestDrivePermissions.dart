import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icare/HomePage.dart';
import 'package:flutter/foundation.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'Widgets/GoogleDrive.dart';


class RequestDrivePermissionsPage extends StatefulWidget {
  final DrivePermisssionStorage storage;

  RequestDrivePermissionsPage({ Key? key, required this.storage}) : super(key: key);

  @override
  _RequestDrivePermissionsPageState createState() => _RequestDrivePermissionsPageState();
}

class _RequestDrivePermissionsPageState extends State<RequestDrivePermissionsPage> {

  final googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.file']);

  // String APIKEY = "AIzaSyAWYnOR-pipvIDphMntL7cUa2Ow5tYT308";
  String APIKEY = "AIzaSyCTFdtYFcpoczv6_uyVI9C8jtpqsMbq8xE";

  final verticalScroll = ScrollController();
  bool showProgress = false;
  String? TutorialStatus;
  var LanguageData =0;
  var PrivacyPolicyTitle = ["","",""];
  final drive = GoogleDrive();
  var DrivePermission = "false";





  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  @override
  void initState() {
    // TODO: implement initState
    widget.storage._readData("icare_Drive_Permission").then((String value) async{
      if(value != "No Data" && value != "")
      {

        setState(() {
          DrivePermission = value.toString();
        });

      }
      else
      {
        setState(() {
          DrivePermission = "false";
        });
      }

    });

    if(DrivePermission != "false")
    {
      Fluttertoast.showToast(
          msg: "Drive Permission Granted Successfully\n"
              "Data Backup Activated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 14.0);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              HomePage(storage: HomeStorage(),Location: GetLocation(), key: null,)
          )
      );
    }
    else
    {
      Fluttertoast.showToast(
          msg: "Permission Grant Failed!!\n"
              "Please try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 14.0);

      super.initState();

    }
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
                      height: 80.0,
                    ),

                  // Form Title
                    Container(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Container(
                        height: 60,
                        width: 60,
                        color: Colors.transparent,
                        child: Image.asset(
                          'assets/img/drive.png',
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
                        child: const Text("Drive Permission Request",
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
                          'assets/img/request4.png',
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
                          child: const Text("The application needs to allow Access to your Drive in order to enable backup of your data and medical files on your google drive ",textAlign: TextAlign.center,
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
                              setState(() {
                                showProgress = true;
                              });
                              await googleSignIn.signIn();

                              await googleSignIn.isSignedIn().then((value) {
                                DrivePermission = value.toString();
                              }
                              );
                              widget.storage._writeData(DrivePermission);

                              if(DrivePermission != "false")
                              {
                                Fluttertoast.showToast(
                                    msg: "Drive Permission Granted Successfully\n"
                                        "Data Backup Activated",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.teal,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                        HomePage(storage: HomeStorage(),Location: GetLocation(), key: null,)
                                    )
                                );
                              }
                              else
                              {
                                Fluttertoast.showToast(
                                    msg: "Permission Grant Failed!!\n"
                                        "Please try again",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.teal,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                        RequestDrivePermissionsPage(storage: DrivePermisssionStorage(),)

                                    )
                                );
                              }                              // GoogleDriveHandler().setAPIKey(
                              //   APIKey: APIKEY,
                              // );
                              // File? myFile = await GoogleDriveHandler()
                              //     .getFileFromGoogleDrive(context: context);
                              // if (myFile != null) {
                              //   //Do something with the file
                              // } else {
                              //   //Discard...
                              // }

                              // await drive.getHttpClient();
                              // FilePickerResult? result = await FilePicker.platform.pickFiles();
                              //
                              // if (result != null) {
                              //   Uint8List? fileBytes = result.files.first.bytes;
                              //   String? path = result.files.first.path;
                              //   File fileToUpload = new File(path!);
                              //   await drive.uploadFileToGoogleDrive(fileToUpload);
                              // }
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         Directionality( // use this
                              //             textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                              //             child: SignUpInfoPage(
                              //               storage: ProfileInfoStorage(),
                              //               key: null,)),
                              //   ),
                              // );
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: "Permission Grant Failed!!\n"
                                      "Please try again",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.teal,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder:
                                      (context) => Directionality( // use this
                                          textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                          child:   RequestDrivePermissionsPage(storage: DrivePermisssionStorage(),)

                                      ),
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


class DrivePermisssionStorage
{

  Future<String> createFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/Settings');
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
  Future<String> _readData(String Filename) async {
    final dirPath =  await createFolder();
    final myFile = await File('$dirPath/'+Filename+'.txt');

    if(await myFile.exists())
    {
      String data = await myFile.readAsString();
      return  data;
    }
    else
    {
      return "No Data";
    }

  }



  // This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData(String Data) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/icare_Drive_Permission.txt');
    // If data.txt doesn't exist, it will be created automatically
    if ((await _myFile.exists())) {
      await _myFile.writeAsString(Data,  mode: FileMode.append);
    } else {
      await _myFile.writeAsString(Data);

    }
  }
}




