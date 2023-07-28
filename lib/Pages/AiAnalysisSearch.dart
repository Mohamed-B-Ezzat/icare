import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'AllergiesAiAnalysisLayout.dart';
import 'LabtestsAiAnalysisLayout.dart';
import 'PrescriptionsAiAnalysisLayout.dart';
import 'ScansAiAnalysisLayout.dart';
import 'SymptomsAiAnalysisLayout.dart';
import 'VaccinationsAiAnalysisLayout.dart';
import 'VitalSignsAiAnalysisLayout.dart';


class AiAnalysisSearchPage extends StatefulWidget {
  String AnalysisModule;

  AiAnalysisSearchPage({Key? key, required this.AnalysisModule}) : super(key: key);

  @override
  _AiAnalysisSearchPageState createState() => _AiAnalysisSearchPageState(this.AnalysisModule);
}

class _AiAnalysisSearchPageState extends State<AiAnalysisSearchPage>  {
  bool showProgress = false;
  TextEditingController FromDateController = TextEditingController();
  TextEditingController ToDateController = TextEditingController();

  String ModuleImage = "";
  var LanguageData =0;

  var AIAnalysisTitle = ["AI Analysis","تحليل الذكاء الاصطناعي",""];
  var FromDateTitle = ["From Date","التاريخ من",""];
  var ToDateTitle = ["To Date","التاريخ إلي",""];
  var AnalyzeBtnTitle = ["Analyze","حلل",""];
  var AnalysisSuccessMsg = ["Data is being Analyzed. It will take some time, Please be patient.","يجري تحليل البيانات. سيستغرق الأمر بعض الوقت ، يرجى الانتظار.",""];
  var AnalysisFailMsg = ["Analysis Failed, Check Required Dates.","فشل التحليل ، تحقق من التواريخ المطلوبة.",""];



  final verticalScroll = ScrollController();

  var AnalysisModule;
  _AiAnalysisSearchPageState(this.AnalysisModule);

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


  void initState() {
    // TODO: implement initState
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

  }


  @override
  Widget build(BuildContext context) {

    double edge = 120.0;
    double padding = edge / 10.0;
    var now =  DateTime.now();
    var outputFormat = DateFormat('MM/dd/yyyy');
    var outputDate = outputFormat.format(now);
    String? DateNow = outputDate.toString();
    switch (AnalysisModule)
    {
      case "Vital Signs":
        ModuleImage = "vitals";
        break;
      case "Prescriptions":
        ModuleImage = "prescriptions";
        break;
      case "Lab Tests":
        ModuleImage = "labtests";
        break;
      case "Vaccinations":
        ModuleImage = "vaccinations";
        break;
      case "Symptoms":
        ModuleImage = "symptoms";
        break;
      case "Scans":
        ModuleImage = "scans";
        break;
      case "Allergies":
        ModuleImage = "allergies";
        break;
      default:
        ModuleImage = "";
        break;
    }

    return Scaffold(
      //extendBodyBehindAppBar: true,
        drawer: MainMenu(storage: MainMenuStorage()),
        appBar: AppBar(
          title: Text(AIAnalysisTitle[LanguageData],
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

                    // Form Title
                    Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          'assets/svg/aianalysis.svg',
                          width: 50,
                          height: 50,
                          alignment: AlignmentDirectional.center,
                          // color: Colors.white,
                          allowDrawingOutsideViewBox: false,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Add Form
                    Container(
                      margin: const EdgeInsets.only(top:5.0),
                      //padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.white,
                              Colors.white,
                            ]
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            offset: Offset(0, 2), // Shadow position
                          ),
                        ],
                      ),
                      child: ModalProgressHUD(
                        inAsyncCall: showProgress,
                        child: Column(
                          children: <Widget>[

                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Card(
                                  color: const Color.fromRGBO(32, 116, 150, 1.0),
                                  shadowColor: Colors.grey,
                                  elevation: 4.0,
                                  margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                  child: ListTile(
                                    title: AnalysisModule!= null
                                        ? Text(AnalysisModule.toString() + " Analysis",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                        :const Text("ICare Analysis",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                height: 80,
                                width: 80,
                                color: Colors.transparent,
                                child: ModuleImage!= ""
                                ?SvgPicture.asset(
                                  'assets/svg/'+ModuleImage+'.svg',
                                  width: 50,
                                  height: 50,
                                  alignment: AlignmentDirectional.center,
                                  // color: Colors.white,
                                  allowDrawingOutsideViewBox: false,
                                  // fit: BoxFit.cover,
                                )
                                    :SvgPicture.asset(
                                  'assets/svg/aianalysis.svg',
                                  width: 50,
                                  height: 50,
                                  alignment: AlignmentDirectional.center,
                                  // color: Colors.white,
                                  allowDrawingOutsideViewBox: false,
                                  // fit: BoxFit.cover,
                                )

                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child:TextField(
                                controller: FromDateController, //editing controller of this TextField
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.date_range), //icon of text field
                                  labelText: FromDateTitle[LanguageData],
                                  labelStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),  //label text of field
                                ),
                                readOnly: true,  //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context, initialDate: DateTime.now(),
                                      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101)
                                  );

                                  if(pickedDate != null ){
                                    //var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
                                    var outputFormat = DateFormat('MM/dd/yyyy');
                                    var outputDate = outputFormat.format(pickedDate);
                                    FromDateController.text =  outputDate.toString();
                                    setState(() {
                                      FromDateController.text = outputDate.toString(); //set output date to TextField value.
                                    });
                                  }else{
                                    print("Date is not selected");
                                  }
                                },
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child:TextField(
                                controller: ToDateController, //editing controller of this TextField
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.date_range), //icon of text field
                                  labelText: ToDateTitle[LanguageData],
                                  labelStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),  //label text of field
                                ),
                                readOnly: true,  //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context, initialDate: DateTime.now(),
                                      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101)
                                  );

                                  if(pickedDate != null ){
                                    //var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
                                    var outputFormat = DateFormat('MM/dd/yyyy');
                                    var outputDate = outputFormat.format(pickedDate);
                                    ToDateController.text =  outputDate.toString();
                                    setState(() {
                                      ToDateController.text = outputDate.toString(); //set output date to TextField value.
                                    });
                                  }else{
                                    print("Date is not selected");
                                  }
                                },
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 20.0,
                            ),

                            Container(
                                height: 50,
                                width: 300.0,
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  child: Text(AnalyzeBtnTitle[LanguageData]),
                                  onPressed: ()  async {
                                    try {
                                      if(FromDateController.text != "" && ToDateController.text != "")
                                      {
                                        setState(() {
                                          showProgress = true;
                                        });

                                          Fluttertoast.showToast(
                                              msg: AnalysisSuccessMsg[LanguageData],
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.teal,
                                              textColor: Colors.white,
                                              fontSize: 14.0);
                                        switch (AnalysisModule)
                                        {
                                          case "Vital Signs":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Directionality( // use this
                                                      textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                      child: VitalSignsAiAnalysisLayoutPage(FromDate: FromDateController.text,ToDate: ToDateController.text,AnalysisModule: AnalysisModule.toString(),storage: VitalSignsAnalysisStorage(),IngeredientsStorage: VitalSignsActiveIngredients(),PrintPdf: VitalSignsPdfReport(),)),
                                              ),);
                                            break;
                                          case "Prescriptions":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Directionality( // use this
                                                      textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                      child: PrescriptionsAiAnalysisLayoutPage(FromDate: FromDateController.text,ToDate: ToDateController.text,AnalysisModule: AnalysisModule.toString(),storage: PrescriptionsAnalysisStorage(),IngeredientsStorage: PrescriptionsActiveIngredients(),PrintPdf: PrescriptionsPdfReport(),)),
                                              ),);
                                            break;
                                          case "Lab Tests":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Directionality( // use this
                                                      textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                      child: LabtestsAiAnalysisLayoutPage(FromDate: FromDateController.text,ToDate: ToDateController.text,AnalysisModule: AnalysisModule.toString(),storage: LabtestsAnalysisStorage(),RecommendationsStorage: LabtestsRecommendations(),PrintPdf: LabtestsPdfReport(),)),
                                              ),);
                                            break;
                                          case "Vaccinations":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Directionality( // use this
                                                      textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                      child: VaccinationsAiAnalysisLayoutPage(FromDate: FromDateController.text,ToDate: ToDateController.text,AnalysisModule: AnalysisModule.toString(),storage: VaccinationsAnalysisStorage(),WhoRecommendationsStorage: VaccinationsWhoRecommendations(),PrintPdf: VaccinationsPdfReport(),)),
                                              ),);
                                            break;
                                          case "Symptoms":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Directionality( // use this
                                                      textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                      child: SymptomsAiAnalysisLayoutPage(FromDate: FromDateController.text,ToDate: ToDateController.text,AnalysisModule: AnalysisModule.toString(),storage: SymptomsAnalysisStorage(),RecommendationsStorage: SymptomsActiveRecommendations(),PrintPdf: SymptomsPdfReport(),)),
                                              ),);
                                            break;
                                          case "Scans":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Directionality( // use this
                                                      textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                      child: ScansAiAnalysisLayoutPage(FromDate: FromDateController.text,ToDate: ToDateController.text,AnalysisModule: AnalysisModule.toString(),storage: ScansAnalysisStorage(),RecommendationsStorage: ScansActiveRecommendations(),PrintPdf: ScansPdfReport(),)),
                                              ),);
                                            break;
                                          case "Allergies":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Directionality( // use this
                                                      textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                      child: AllergiesAiAnalysisLayoutPage(FromDate: FromDateController.text,ToDate: ToDateController.text,AnalysisModule: AnalysisModule.toString(),storage: AllergiesAnalysisStorage(),RecommendationsStorage: AllergiesRecommendations(),PrintPdf: AllergiesPdfReport(),)),
                                              ),);
                                            break;
                                          default:
                                            ModuleImage = "";
                                            break;
                                        }
                                        setState(() {
                                          showProgress = false;
                                        });
                                      }
                                    } catch (e) {
                                      setState(() {
                                        showProgress = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: AnalysisFailMsg[LanguageData],
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.teal,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                    }
                                  },
                                )
                            ),

                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                )
            ),
          ),
        )
    );
  }

}