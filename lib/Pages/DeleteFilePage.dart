import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/HomePage.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/ImageFromGalleryEx.dart';
import 'package:share_plus/share_plus.dart';

import 'AiAnalysisHome.dart';
import 'Allergies.dart';
import 'LabTests.dart';
import 'Prescriptions.dart';
import 'ReportsHome.dart';
import 'Scans.dart';
import 'Symptoms.dart';
import 'Vaccinations.dart';
import 'VitalSigns.dart';


class DeleteFilePage extends StatefulWidget {

  final String FilePath;
  final String FileName;
  final String Module;

  DeleteFilePage({Key? key, required this.FilePath, required this.FileName, required this.Module}) : super(key: key);

  @override
  _DeleteFilePageState createState() =>   _DeleteFilePageState(this.FilePath, this.FileName, this.Module);

}
class _DeleteFilePageState extends State<DeleteFilePage>  {


  var FilePath;
  var FileName;
  var Module;

  _DeleteFilePageState(this.FilePath, this.FileName, this.Module);

  bool showProgress = false;

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  @override
  void initState() {
    // TODO: implement initState
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //extendBodyBehindAppBar: true,
        drawer: MainMenu(storage: MainMenuStorage()),
        appBar: AppBar(
          title: const Text('Delete File',
            style: TextStyle(
              color: Colors.white,),
          ),
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
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/grmain.png'),
                    fit: BoxFit.fill
                )
            ),
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: ModalProgressHUD(
              inAsyncCall: showProgress,
              child: Column(
              children: <Widget>[

                // Form Title
                Container(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.transparent,
                    child: SvgPicture.asset(
                      'assets/svg/pdffile.svg',
                      width: 50,
                      height: 50,
                      alignment: AlignmentDirectional.center,
                      // color: Colors.white,
                      allowDrawingOutsideViewBox: false,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                // Dependents Title and Add New
                const Card(
                  color: Color.fromRGBO(32, 116, 150, 1.0),
                  shadowColor: Colors.grey,
                  elevation: 4.0,
                  margin: EdgeInsets.only(top:0.0,left:0.0,bottom:0.0,right:0.0),
                  child: ListTile(
                    title:Text("Confirm Delete",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,
                        // Color.fromRGBO(248, 95, 106, 1.0),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        //decoration: TextDecoration.underline,
                      ),
                    ) ,
                  ),
                ),


                // Dependents
                Container(
                  margin: const EdgeInsets.only(top:0.0),
                  padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.white,
                          Colors.white,
                        ]
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:   Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4,
                        offset: Offset(0, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: Text("Are You Sure To Delete " +FileName.toString()+ " ?",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      //decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 50.0,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async{
                        try {
                          setState(() {
                            showProgress = true;
                          });
                          deleteFile(File(FilePath));
                          switch(Module.toString())
                          {
                            case "analysis":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AiAnalysisHomePage(AnalysisTutorialStatus: AnalysisTutorialStorage())
                                  )
                              );
                              break;
                            case "Reports":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReportsHomePage(ReportsTutorialStatus: ReportsTutorialStorage()),
                                  ));
                              break;
                          }

                          setState(() {
                            showProgress = false;
                          });
                        } catch (e) {
                          setState(() {
                            showProgress = false;
                          });
                          Fluttertoast.showToast(
                              msg: "Delete Failed, Please go back and try again.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.teal,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        }
                      },
                      icon: Icon(Icons.done, color: Colors.teal),
                      label: const Text('Yes',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.teal)
                      ),
                      style: ElevatedButton.styleFrom(
                        // primary: Color.fromRGBO(66, 133, 244, 1.0),
                        primary: Colors.white,
                        side: const BorderSide(width: 1.0, color: Colors.teal),
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 50.0,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async{
                        try {
                          Navigator.pop(context);
                          setState(() {
                            showProgress = false;
                          });
                        } catch (e) {
                          setState(() {
                            showProgress = false;
                          });
                          Fluttertoast.showToast(
                              msg: "Delete Failed, Please go back and try again.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.teal,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        }
                      },
                      icon: Icon(Icons.close_outlined,color: Colors.redAccent),
                      label: const Text('No',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.redAccent)
                      ),
                      style: ElevatedButton.styleFrom(
                        // primary: Color.fromRGBO(66, 133, 244, 1.0),
                        primary: Colors.white,
                        side: const BorderSide(width: 1.0, color: Colors.redAccent),
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 50.0,
                    ),
                  ], //<Widget>[]
                ),
              ],
            )
          //   ),
          // ),
        ),
        ),
    );
  }




}









