import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/HomePage.dart';
import 'package:flutter/foundation.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'Login.dart';
import 'SignUpInfo.dart';

class DemoPage extends StatefulWidget {
  final DemoStorage storage;

  DemoPage({ Key? key, required this.storage}) : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String _email = "" , _age = "";

  final verticalScroll = ScrollController();
  bool showProgress = false;
  String? DemoStatus;
  var LanguageData =0;

  //var PrivacyPolicyTitle = ["","",""];



  @override
  void initState() {
    // TODO: implement initState
    widget.storage._readSettingsData("icare_Language").then((String value) async{
      if(value != "No Data" && value != "")
      {

        setState(() {
          LanguageData = int.parse(value);
        });

      }
      else
      {
        setState(() {
          LanguageData = 0;
        });
      }

    });

    widget.storage._readData("icare_Demo").then((String icare_Demo) {
      if (icare_Demo == "NotFirst") {
        widget.storage._readData("icare_email").then((String icare_email) {
          setState(() {
            _email = icare_email;
          });
          if (icare_email == "No Data") {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => Directionality( // use this
                        textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                        child: LoginPage(storage: LoginStorage())
                    ),
                )
            );
          }
          else {
            widget.storage._readData("icare_age").then((
                String icare_age) {
              setState(() {
                _age = icare_age;
              });
              if (icare_age == "No Data") {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder:
                        (context) =>
                            Directionality( // use this
                                textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                child: SignUpInfoPage(
                                  storage: ProfileInfoStorage(), key: null,)
                            ),
                    )
                );
              }
              else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder:
                        (context) =>
                            Directionality( // use this
                                textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                child: HomePage(storage: HomeStorage(),
                                  Location: GetLocation(),
                                  key: null,)
                            ),
                    )
                );
              }
            });
          }
        });
      }
      else {
        super.initState();
      }
    });

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
                        child: const Text("ICare",
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
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:   Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            offset: Offset(0, 2), // Shadow position
                          ),
                        ],
                      ),
                      child: Container(
                        height: 200,
                        width: 600,
                        color: Colors.transparent,
                        child: Image.asset(
                          'assets/img/demo2.png',
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
                        child: const Text("Welcome to ICare",textAlign: TextAlign.center,
                          style: TextStyle(color: Color.fromRGBO(47, 150, 185, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),),

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
                        child: const Text("ICare, Your own medical System, You can track your health and your family health.\n"
                            "you can use our free AI Analysis engine to analyse your medical status and your family.\n"
                            "you can easily contact your medical service provider with your issue and medical records directly.",textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black,
                            fontSize: 16,
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
                          child: const Text('Get Started'),
                          onPressed: ()  async {
                            try {
                              widget.storage._writeData("NotFirst");

                              Navigator.pushReplacement(context,
                              MaterialPageRoute(builder:
                              (context) => Directionality( // use this
                                  textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                  child: LoginPage(storage: LoginStorage())
                              ),
                              )
                              );
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: "Error, $e!!Please try again",
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
                                          child: DemoPage(storage: DemoStorage(),)
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


class DemoStorage
{
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

      final _myFile = File('$_dirPath/icare_Demo.txt');
    // If data.txt doesn't exist, it will be created automatically
    if ((await _myFile.exists())) {
      await _myFile.writeAsString(Data,  mode: FileMode.append);
    } else {
      await _myFile.writeAsString(Data);

    }
  }

  Future<String> createSettingsFolder() async {
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
  Future<String> _readSettingsData(String Filename) async {
    final dirPath =  await createSettingsFolder();
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
}



