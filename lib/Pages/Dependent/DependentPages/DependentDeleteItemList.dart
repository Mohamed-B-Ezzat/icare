import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../DependentWidgets/Dependentmain_menu.dart';
import 'DependentAllergies.dart';
import 'DependentHomePage.dart';
import 'DependentLabTests.dart';
import 'DependentPrescriptions.dart';
import 'DependentScans.dart';
import 'DependentSymptoms.dart';
import 'DependentVaccinations.dart';



class DependentDeleteItemListPage extends StatefulWidget {
  final String DataTitle;
  final int DataIndex;
  final List DataLines;
  final String FileName;
  final String DirName;
  final String DataImage;

  DependentDeleteItemListPage({Key? key, required this.DataTitle, required this.DataIndex, required this.DataLines, required this.FileName, required this.DirName, required this.DataImage}) : super(key: key);

  @override
  _DependentDeleteItemListPageState createState() =>   _DependentDeleteItemListPageState(this.DataTitle, this.DataIndex, this.DataLines, this.FileName, this.DirName, this.DataImage);

}
class _DependentDeleteItemListPageState extends State<DependentDeleteItemListPage>  {

  var DataTitle;
  var DataIndex;
  var DataLines;
  var FileName;
  var DirName;
  var DataImage;
  _DependentDeleteItemListPageState(this.DataTitle, this.DataIndex, this.DataLines, this.FileName, this.DirName, this.DataImage);

  bool showProgress = false;

  Future<String> createFolder(String DireName) async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/'+DireName);
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
  Future<void> _writeData(String Data, String DireName, String Filename) async {
    final _dirPath = await createFolder(DireName);

    final _myFile = File('$_dirPath/'+Filename+'.txt');
// If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString(Data);
  }


  @override
  void initState() {
    // TODO: implement initState
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //extendBodyBehindAppBar: true,
      drawer: DependentMainMenu(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),storage: DependentMainMenuStorage(), DirName: DirName.toString(),),
      appBar: AppBar(
          title: Text('Delete '+ DirName.toString(),
            style: const TextStyle(
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
                      'assets/svg/'+DataImage.toString()+'.svg',
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
                  child: DataTitle != null
                      ? Text("Are You Sure To Delete Selected Item From "+DirName.toString()+" ?",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      //decoration: TextDecoration.underline,
                    ),
                  )
                      :const Text("Erorr occured, please go back and try again !!!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
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
                          String UpdatedData = "";
                          DataLines[DataIndex] = "";
                          for(int i=0 ; i<DataLines.length ; i++)
                          {
                            if(DataLines[i] != "")
                            {
                              UpdatedData +=DataLines[i] +"\n";
                            }
                          }
                          setState(() {
                            showProgress = true;
                          });
                          Fluttertoast.showToast(
                              msg: "Deleting,......\nPlease be patient",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.teal,
                              textColor: Colors.white,
                              fontSize: 14.0);
                          _writeData(UpdatedData,DirName.toString(), FileName.toString());

                          Timer(const Duration(seconds: 5), () {
                            switch (DirName)
                            {
                              case "Vital Signs":
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                            DependentPrescriptionsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentPrescriptionsStorage(), key: null,)
                                    )
                                );
                                break;
                              case "Prescriptions":
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                            DependentPrescriptionsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentPrescriptionsStorage(), key: null,)
                                    )
                                );
                                break;
                              case "Lab Tests":
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                            DependentLabTestsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentLabTestsStorage(), key: null,)
                                    )
                                );
                                break;
                              case "Vaccinations":
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                            DependentVaccinationsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentVaccinationsStorage(), key: null,)
                                    )
                                );
                                break;
                              case "Symptoms":
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                            DependentSymptomsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentSymptomsStorage(), key: null,)
                                    )
                                );
                                break;
                              case "Scans":
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                            DependentScansPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentScansStorage(), key: null,)
                                    )
                                );
                                break;
                              case "Allergies":
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                            DependentAllergiesPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentAllergiesStorage(), key: null,)
                                    )
                                );
                                break;
                              default:
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                            DependentHomePage(storage: DependentHomeStorage(),DirName: 'Dependents', FileName: 'icare_Dependents', DataIndex: DataIndex, DataTitle: DataTitle, DependentDataLines: DataLines, DataImage: "dependents")
                                    )
                            );
                                break;
                            }

                          });

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DependentLabTestsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentLabTestsStorage(), key: null,)),
                          );
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









