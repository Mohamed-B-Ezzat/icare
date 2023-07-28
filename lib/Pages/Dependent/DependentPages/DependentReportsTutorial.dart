import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' as intl;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/rendering.dart';

import '../DependentWidgets/Dependentmain_menu.dart';
import 'DependentReportsHome.dart';



class DependentReportsTutorialPage extends StatefulWidget {
  final String DirName;
  final DependentReportsTutorialStorage ReportsTutorialStatus;
  final String DataTitle;
  final String DataImage;
  DependentReportsTutorialPage({ Key? key,required this.DataTitle, required this.DataImage,required this.DirName, required this.ReportsTutorialStatus}) : super(key: key);

  @override
  _DependentReportsTutorialPageState createState() => _DependentReportsTutorialPageState(this.DataTitle, this.DataImage,this.DirName);
}

class _DependentReportsTutorialPageState extends State<DependentReportsTutorialPage> {
  var DirName;
  var DataTitle;
  var DataImage;
  _DependentReportsTutorialPageState(this.DataTitle, this.DataImage,this.DirName,);

  final verticalScroll = ScrollController();
  bool showProgress = false;
  String? TutorialStatus;

  List Body = ["You can track up to 3 vital signs in an unlimited period of time among their max, min and average.","You can print and share of available reports:\n"
      "- Standalone report for unlimited period of time (Vital Signs, Prescriptions, Vaccinationa, lab Test, Scan tests, Allergies,.....)\n- Total Health Report (Weekly, Monthly, period of time).","",""];

  int PageNo = 1;



  var LanguageData =0;


  @override
  void initState() {
    // TODO: implement initState
    widget.ReportsTutorialStatus._readSettingsData("icare_Language").then((String value) async{
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
    widget.ReportsTutorialStatus._writeData(DirName.toString(),"NotFirst");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      //extendBodyBehindAppBar: true,
      drawer: DependentMainMenu(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),storage: DependentMainMenuStorage(), DirName: DirName.toString(),),
      appBar: AppBar(
        title: const Text('Reports',
          style: TextStyle(
            color: Colors.white,),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    Color.fromRGBO(47, 150, 185, 1),
                    Color.fromRGBO(84, 199, 212, 1),
                    Color.fromRGBO(47, 150, 185, 1)
                  ])
          ),
        ),
        elevation: 0,

      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/graybg.png'),
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
                      height: 10.0,
                    ),

                    // Skip
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: DependentReportsHomePage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),ReportsHomeStorage: DependentReportsHomeStorage()),
                              )));
                      },
                      child:Container(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Container(
                          color: Colors.transparent,
                          child: const Text("Skip >>",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),),
                        ),
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
                          'assets/img/demo.png',
                          width: 200,
                          height: 500,
                          alignment: AlignmentDirectional.center,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    // Header 1
                    Container(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Container(
                        color: Colors.transparent,
                        child: const Text("Meet",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.teal,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),),
                      ),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),

                    // Header 2
                    Container(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Container(
                        color: Colors.transparent,
                        child: const Text("The Reports  Feature",
                          style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
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
                          child: Body[PageNo] != null
                              ?Text(Body[PageNo],textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),)
                              :const Text("ICare Reports Feature")
                      ),
                    ),

                    const SizedBox(
                      height: 40.0,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(width: 10.0),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.transparent,
                              child: PageNo>1
                                  ?IconButton(
                                icon: const Icon(Icons.skip_previous),
                                tooltip: 'Prev',
                                onPressed: () {
                                  setState(() {
                                    PageNo--;
                                  });
                                },
                              ):const Text("")
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 2,
                          child: Text(PageNo.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.transparent,
                              child: PageNo<Body.length
                                  ?IconButton(
                                icon: const Icon(Icons.skip_next),
                                tooltip: 'Prev',
                                onPressed: () {
                                  setState(() {
                                    PageNo++;
                                  });
                                },
                              ):const Text("")
                          ),
                        ),
                        const SizedBox(width: 10.0),
                      ],
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


class DependentReportsTutorialStorage
{
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
  Future<String> createFolder(String DirName) async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/'+DirName+'/Reports');
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
  Future<String> _readData(String DirName) async {
    final dirPath = await createFolder(DirName);
    final myFile = File('$dirPath/ReportsTutorial.txt');
    if(await myFile.exists())
    {
      String data = await myFile.readAsString();
      return  data;
    }
    else
    {
      _writeData(DirName,"First");
      return "First";
    }
  }

  // This function is triggered when the "Write" button is pressed
  Future<void> _writeData(String DirName,String Data) async {
    final _dirPath = await createFolder(DirName);

    final _myFile = File('$_dirPath/ReportsTutorial.txt');
    // If data.txt doesn't exist, it will be created automatically
    if ((await _myFile.exists())) {
      await _myFile.writeAsString(Data,  mode: FileMode.append);
    } else {
      await _myFile.writeAsString(Data);

    }
  }


}






