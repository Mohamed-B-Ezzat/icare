import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'ReportsHome.dart';


class ReportsTutorialPage extends StatefulWidget {

  ReportsTutorialPage({ Key? key}) : super(key: key);

  @override
  _ReportsTutorialPageState createState() => _ReportsTutorialPageState();
}

class _ReportsTutorialPageState extends State<ReportsTutorialPage> {

  final verticalScroll = ScrollController();
  bool showProgress = false;
  String? TutorialStatus;
  var LanguageData =0;

  var ReportTitle = ["Reports","التقارير",""];
  var MeetTitle = ["Meet","تعرف علي",""];
  var ReportsFeatureTitle = ["The Reports  Feature","ميزة التقارير",""];
  var NullBodyTitle = ["ICare Reports  Feature","ميزة ICare للتقارير",""];
  var SkipTitle = ["Skip >>","تخطي >>",""];
  var NextTitle = ["Next","التالي",""];
  var PrevTitle = ["Prev","السابق",""];
  List Body = [["You can track up to 3 vital signs in an unlimited period of time among their max, min and average.",
    "You can print and share of available reports:\n"
        "- Standalone report for unlimited period of time (Vital Signs, Prescriptions, Vaccinationa, lab Test, Scan tests, Allergies,.....)\n- Total Health Report (Weekly, Monthly, period of time)."],
  ["يمكنك تتبع ما يصل إلى 3 علامات حيوية في فترة زمنية غير محدودة بين الحد الأقصى والحد الأدنى والمتوسط.",
  "\nيمكنك طباعة ومشاركة التقارير المتوفرة:- تقرير مستقل لفترة زمنية غير محدودة (الإشارات الحيوية ، الوصفات الطبية ، التطعيم أ ، الاختبارات المعملية ، اختبارات المسح ، الحساسية ، .....)\n- التقرير الصحي الإجمالي (أسبوعيًا ، شهريًا ، فترة زمنية)."],["",""]];

  int PageNo = 1;

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

    final _myFile = File('$_dirPath/ReportsTutorial.txt');
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

  @override
  void initState() {
    // TODO: implement initState
    _writeData("NotFirst");
    _readSettingsData("icare_Language").then((String value) async{
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
    super.initState();
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      //extendBodyBehindAppBar: true,
      drawer: MainMenu(storage: MainMenuStorage()),
      appBar: AppBar(
        title: Text(ReportTitle[LanguageData],
          style: const TextStyle(
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
                          child: ReportsHomePage(ReportsTutorialStatus: ReportsTutorialStorage()),),
                            ));
                      },
                      child:Container(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Container(
                          color: Colors.transparent,
                          child: Text(SkipTitle[LanguageData],
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
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
                        child: Text(MeetTitle[LanguageData],
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.teal,
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
                        child: Text(ReportsFeatureTitle[LanguageData],
                          style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
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
                          child: Body[LanguageData][PageNo] != null
                              ?Text(Body[LanguageData][PageNo],textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),)
                              :Text(NullBodyTitle[LanguageData])
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
                                tooltip: PrevTitle[LanguageData],
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
                              child: PageNo<Body[LanguageData].length
                                  ?IconButton(
                                icon: const Icon(Icons.skip_next),
                                tooltip: NextTitle[LanguageData],
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






