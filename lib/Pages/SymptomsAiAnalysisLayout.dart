import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/HomePage.dart';
import 'package:icare/Pages/AiAnalysisHome.dart';
import 'package:icare/Pages/VitalSigns.dart';
import 'package:icare/Pages/add_allergies.dart';
import 'package:icare/Pages/add_labtests.dart';
import 'package:icare/Pages/add_prescriptions.dart';
import 'package:icare/Pages/add_scans.dart';
import 'package:icare/Pages/add_symptoms.dart';
import 'package:icare/Pages/add_vaccinations.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../Widgets/PDFScreen.dart';

class SymptomsAiAnalysisLayoutPage extends StatefulWidget {
  String FromDate, ToDate, AnalysisModule;
  final SymptomsAnalysisStorage storage;
  final SymptomsPdfReport PrintPdf;
  final SymptomsActiveRecommendations RecommendationsStorage;

  SymptomsAiAnalysisLayoutPage({ required this.FromDate, required this.ToDate, required this.AnalysisModule, Key? key, required this.storage, required this.PrintPdf, required this.RecommendationsStorage}) : super(key: key);

  @override
  _SymptomsAiAnalysisLayoutPageState createState() => _SymptomsAiAnalysisLayoutPageState(this.FromDate, this.ToDate, this.AnalysisModule);
}

class _SymptomsAiAnalysisLayoutPageState extends State<SymptomsAiAnalysisLayoutPage>  {

  var FromDate;
  var ToDate;
  var AnalysisModule;
  _SymptomsAiAnalysisLayoutPageState(this.FromDate, this.ToDate, this.AnalysisModule);


  bool showProgress = false;

  final verticalScroll = ScrollController();

  var ListData;
  var RecommendationsData;
  var SymptomsData;
  var Data;
  int ListSize = 2;

  String ModuleImage = "";
  String ModuleFileName = "";
  String ModuleDirName = "";

  // String ColorCode = "";
  // var ColorsList = const ["#9CCC65","#BCAAA4","#388E3C","#FFC107","#455A64","#2E7D32","#D32F2F","#BA68C8","#FFB300","#795548","#FF1744","#AA00FF","#B388FF","#FFEA00","#9C27B0","#2979FF","#FBC02D","#81C784","#2196F3","#B71C1C","#D84315","#80CBC4","#18FFFF","#D81B60","#29B6F6","#FF9800","#80D8FF","#CCFF90","#1B5E20","#D4E157","#FFE57F","#FFD54F","#F44336","#40C4FF","#FF6F00","#3949AB","#FFD600","#8C9EFF","#2962FF","#1565C0","#FF4081","#FFF176","#E65100","#C51162","#80DEEA","#F57F17","#3D5AFE","#8BC34A","#4FC3F7","#4DD0E1","#82B1FF","#00695C","#1A237E","#0091EA","#512DA8","#AEEA00","#E57373","#FF8A80","#84FFFF","#7C4DFF","#FFCC80","#AED581","#4CAF50","#4E342E","#F06292","#827717","#C2185B","#26A69A","#283593","#FF5722","#00C853","#C0CA33","#006064","#EEFF41","#66BB6A","#00B0FF","#F9A825","#B2FF59","#009688","#9E9D24","#81D4FA","#EC407A","#76FF03","#F4FF81","#BF360C","#A5D6A7","#DCE775","#FF80AB","#FFEE58","#FFFF8D","#7B1FA2","#1DE9B6","#9FA8DA","#00B8D4","#69F0AE","#64DD17","#FFAB40","#7986CB","#0D47A1","#F50057","#AFB42B","#CDDC39","#1976D2","#FFFF00","#212121","#448AFF","#673AB7","#DD2C00","#FF3D00","#7E57C2","#AD1457","#C62828","#FFEB3B","#00E676","#FF7043","#0097A7","#3E2723","#00E5FF","#004D40","#00BCD4","#FFAB00","#FFCA28","#0288D1","#00897B","#4A148C","#FFD740","#D500F9","#1E88E5","#64B5F6","#64FFDA","#9575CD","#FFB74D","#4527A0","#00796B","#43A047","#FFC400","#304FFE","#A1887F","#26C6DA","#5D4037","#880E4F","#F48FB1","#546E7A","#37474F","#6D4C41","#FDD835","#03A9F4","#689F38","#EF5350","#00ACC1","#C6FF00","#A7FFEB","#3F51B5","#FF9100","#EF6C00","#536DFE","#5C6BC0","#FF9E80","#4DB6AC","#039BE5","#311B92","#263238","#FF8A65","#E040FB","#B9F6CA","#FFAB91","#E64A19","#6200EA","#FFA000","#651FFF","#F4511E","#B39DDB","#303F9F","#FFE0B2","#EA80FC","#616161","#8D6E63","#FFA726","#90CAF9","#0277BD","#FFECB3","#FFD180","#FFCCBC","#6A1B9A","#AB47BC","#01579B","#E53935","#7CB342","#E91E63","#FF6D00","#5E35B1","#D50000","#FFE082","#8E24AA","#42A5F5","#FF5252","#FF6E40","#00BFA5","#FF8F00","#F57C00","#FB8C00","#558B2F","#424242","#00838F","#33691E"];


 var LanguageData =0;

  var AIAnalysisTitle = ["AI Analysis","تحليل الذكاء الاصطناعي",""];
  var SaveToPdfTitle = ["Save To Pdf","حفظ في ملف PDF",""];
  var ICareAIAnalysisTitle = ["ICare AI Analysis","تحليل الذكاء الاصطناعي ICare",""];
  var DateErrorTitle = ["From or To Date is not correct","من أو إلى التاريخ غير صحيح",""];
  var AnalysisSuccessMsg = ["Data is being Analyzed. It will take some time, Please be patient.","يجري تحليل البيانات. سيستغرق الأمر بعض الوقت ، يرجى الانتظار.",""];
  var AnalysisFailMsg = ["Analysis Failed, Check Required Dates.","فشل التحليل ، تحقق من التواريخ المطلوبة.",""];


  @override
  void initState() {

    switch (AnalysisModule)
    {
      case "Vital Signs":
        ModuleImage = "vitals";
        ModuleDirName = "VitalSigns";
        ModuleFileName = "icare_vital_signs";
        ListSize = 4;
        break;
      case "Prescriptions":
        ModuleImage = "prescriptions";
        ModuleDirName = "Prescriptions";
        ModuleFileName = "icare_prescriptions";
        ListSize = 4;
        break;
      case "Lab Tests":
        ModuleImage = "labtests";
        ModuleDirName = "LabTests";
        ModuleFileName = "icare_labtests";
        ListSize = 4;
        break;
      case "Vaccinations":
        ModuleImage = "vaccinations";
        ModuleDirName = "Vaccinations";
        ModuleFileName = "icare_vaccinations";
        ListSize = 4;
        break;
      case "Symptoms":
        ModuleImage = "symptoms";
        ModuleDirName = "Symptoms";
        ModuleFileName = "icare_symptoms";
        ListSize = 5;
        break;
      case "Scans":
        ModuleImage = "scans";
        ModuleDirName = "Scans";
        ModuleFileName = "icare_scans";
        ListSize = 4;
        break;
      case "Allergies":
        ModuleImage = "allergies";
        ModuleDirName = "Allergies";
        ModuleFileName = "icare_allergies";
        ListSize = 4;
        break;
      default:
        ModuleImage = "";
        ModuleDirName = "";
        ModuleFileName = "";
        ListSize = 2;
        break;
    }
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

    widget.storage._readData(ModuleFileName,ModuleDirName).then((String value) async{
      if(value != "No Data")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);
        if(lines.isNotEmpty)
        {
          int row = lines.length;
          int col = ListSize;

          ListData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result =  lines[i].split('#');
            DateTime ResultDate = new DateFormat("MM/dd/yyyy").parse(result[0]);
            DateTime FromDateParsed = new DateFormat("MM/dd/yyyy").parse(FromDate);
            DateTime ToDateParsed = new DateFormat("MM/dd/yyyy").parse(ToDate);
            if((ResultDate.isAtSameMomentAs(FromDateParsed) || ResultDate.isAfter(FromDateParsed)) && (ResultDate.isAtSameMomentAs(ToDateParsed) || ResultDate.isBefore(ToDateParsed))) {
              for (var j = 0; j < ListSize; j++) {
                  ListData[i][j] = result[j];
              }
            }
          }
        }
        String filteredData = "";
        for (var i = 0; i < ListData.length; i++) {
          for (var j = 0; j < ListSize; j++) {
            if(ListData[i][j] != "")
              {
                filteredData += ListData[i][j];
                if(j!=4)
                  filteredData += ",";
              }
          }
          if(ListData[i][0] != "") {
            filteredData += "\n";
          }
          }

        LineSplitter newls = new LineSplitter();
        List<String> newlines = newls.convert(filteredData);
        if(newlines.isNotEmpty)
        {
          int row = newlines.length;
          int col = ListSize+2;

          SymptomsData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < newlines.length; i++) {
            List<String> result =  newlines[i].split('#');
            for (var j = 0; j < ListSize; j++) {
              SymptomsData[i][j] = result[j];
            }
            }
        }

        RecommendationsData = List.generate(SymptomsData.length, (s) => List.filled(9, "", growable: false), growable: false);

        int RecoIndex;
        for (var i = 0; i < SymptomsData.length; i++) {
          switch (SymptomsData[i][1].toString()) {
            case "Dermatological Rash":
              RecoIndex = 18;
              break;
            case "Head - Face and Neck":
              RecoIndex = 22;
              break;
            case "Ears and Hearing":
              RecoIndex = 16;
              break;
            case "Digestive and Excretory Systems":
              RecoIndex = 20;
              break;
            case "Muscoskeletal System":
              RecoIndex = 24;
              break;
            case "Respitory and Circulatory Systems":
              RecoIndex = 10;
              break;
            case "Neurologic System":
              RecoIndex = 4;
              break;
            case "Psychological Well‐Being":
              RecoIndex = 7;
              break;
            case "Mental Capability":
              RecoIndex = 4;
              break;
            case "Reproduction and Sexuality":
              RecoIndex = 15;
              break;
            case "General Well‐Being":
              RecoIndex = 1;
              break;
            case "Endocrine System":
              RecoIndex = 3;
              break;
            default:
              RecoIndex = 1;
              break;
          }

        widget.RecommendationsStorage._SearchRecommendationsBank(RecoIndex).then((String Recommendation) async{
            if(Recommendation != "") {
              List<String> RecommendationList = Recommendation.split("<>");
              for (var R = 0; R < RecommendationList.length; R++) {
                RecommendationsData[i][R] = RecommendationList[R];
              }
              SymptomsData[i][5] = RecommendationList[0];
              SymptomsData[i][6] = RecommendationList[1];
            }
            else
            {
              RecommendationsData[i][0] = "No Recommendations for" + SymptomsData[i][1] + " Symptoms found in our database!!!";
              Fluttertoast.showToast(
                  msg: "No Recommendations for" + SymptomsData[i][1] + " Symptoms found in our database!!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.teal,
                  textColor: Colors.white,
                  fontSize: 14.0);

            }
          });
        }



        setState(() {
          Data = SymptomsData;
        });
        super.initState();

      }
      else
      {
        Fluttertoast.showToast(
            msg: "No added " + AnalysisModule.toString() + " to be analyzed. Please Add new!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);

        switch (AnalysisModule)
        {
          case "Vital Signs":
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                        VitalSignsPage(storage: VitalSignsStorage(),)
                )
            );
            break;
          case "Prescriptions":
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                    AddPrescriptions(storage: AddPrescriptionsStorage(),)
                )
            );
            break;
          case "Lab Tests":
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                    AddLabTests(storage: AddLabTestsStorage(),)
                )
            );
            break;
          case "Vaccinations":
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                    AddVaccinations(storage: AddVaccinationsStorage(),)
                )
            );
            break;
          case "Symptoms":
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                    AddSymptoms(storage: AddSymptomsStorage(),)
                )
            );
            break;
          case "Scans":
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                    AddScans(storage: AddScansStorage(),)
                )
            );
            break;
          case "Allergies":
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                    AddAllergies(storage: AddAllergiesStorage(),)
                )
            );
            break;
          default:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                        AiAnalysisHomePage(AnalysisTutorialStatus: AnalysisTutorialStorage())
                )
            );
            break;
        }

      }

    });
  }




  @override
  Widget build(BuildContext context) {
    var now =  DateTime.now();
    var outputFormat = DateFormat('MM/dd/yyyy');
    var outputDate = outputFormat.format(now);
    String? DateNow = outputDate.toString().replaceAll("/", "");

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
                  image: AssetImage('assets/img/graybg.png'),
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

            // Dependents Title and Add New
            Card(
              color: const Color.fromRGBO(32, 116, 150, 1.0),
              shadowColor: Colors.grey,
              elevation: 4.0,
              margin: const EdgeInsets.only(top:0.0,left:10.0,bottom:0.0,right:10.0),
              child: ListTile(
                title:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            const SizedBox(width: 30.0),
                            Expanded(
                              // optional flex property if flex is 1 because the default flex is 1
                              flex: 2,
                              child:  Text(SaveToPdfTitle[LanguageData],
                                textAlign: TextAlign.start,
                                style: const TextStyle(color: Colors.white,
                                  // Color.fromRGBO(248, 95, 106, 1.0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  //decoration: TextDecoration.underline,
                                ),
                              ) ,
                            ),
                            const SizedBox(width: 0.0),
                            // Profile Picture
                            const Expanded(
                              // optional flex property if flex is 1 because the default flex is 1
                              flex: 1,
                              child:  Icon(Icons.picture_as_pdf,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 20.0),
                          ],
                        ),
                onTap: () async{
                  var dir = await getApplicationDocumentsDirectory();
                  final path = Directory('${dir.path}/ICare/AIAnalysis');
                  var dirPath = path.path;
                  final myFile = await File('$dirPath/'+ModuleDirName+'AIAnalysis'+DateNow+'.pdf');
                  String FileTitle = ModuleDirName+'AIAnalysis'+DateNow;
                  widget.PrintPdf.SaveToPdf(ModuleDirName,Data,FromDate.toString(),ToDate.toString(),AnalysisModule.toString(),ModuleImage.toString());
                  Timer(const Duration(seconds: 8), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFScreen(pdfPath: myFile.path,FileTitle: FileTitle),
                      ),
                    );
                  });
                  },
              ),
            ),

            const SizedBox(
              height: 10.0,
            ),


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

                    const SizedBox(
                      height: 10.0,
                    ),

                    // Title and Icons
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
                            child: Image.asset('assets/img/icareicon.png',
                              width: 50,
                              height: 50,
                              alignment: AlignmentDirectional.center,
                              // color: Colors.white,
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        const Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 2,
                          child: Text("ICare AI Analysis",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                              fontSize: 20,
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
                        const SizedBox(width: 10.0),
                      ],
                    ),

                    // Analysis Period
                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: FromDate != null && ToDate !=null
                            ?Text(FromDate.toString() +"  -  "+ ToDate.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.teal,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                            :const Text("From or To Date is not correct",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.teal,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),

                    // Module Name
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: AnalysisModule!= null
                          ? Text(AnalysisModule.toString() + " Analysis",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.underline,
                        ),
                      )
                          :const Text("ICare Analysis",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),

                    // Module Image
                    Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          height: 50,
                          width: 50,
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

                    if(Data != null)
                      for (var rowData in Data)
                        rowData[0].toString() != "" && rowData[0] != null
                            ?Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child:  ExpansionTile(
                              childrenPadding: const EdgeInsets.all(5.0),
                              tilePadding: const EdgeInsets.all(5.0),
                              title: Text("Date:        " + rowData[0].toString(),textAlign: TextAlign.left,
                                style: const TextStyle(height: 1.5),
                              ),
                              subtitle: Text("Symptom:        " +rowData[1].toString()+" / "+rowData[2].toString()+'\n'
                                  +"Description:        " + rowData[3].toString(),textAlign: TextAlign.left,
                                style: const TextStyle(height: 1.5),
                              ),
                              children: <Widget>[
                                ListTile(title: Text('Recommendations for ' + rowData[1].toString() + " Symptoms",textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.teal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,),)),
                                ListTile(title: rowData[5].toString() != ""
                                    ?Text("Never Take any Medications Without Consulting A/An " +rowData[5].toString()+"\n\n"+rowData[6].toString(),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 14,),)
                                    :Text('No Recommendations with ' + rowData[1].toString() + " found in our database.",textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.teal,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,),)),
                              ],
                            )
                        )
                            : Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: const Text(""),
                        ),




                    const SizedBox(
                      height: 5.0,
                    ),


                  ],
                ),
              ),
            ),



          ]
          ),
        )
    ),
    ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          var dir = await getApplicationDocumentsDirectory();
          final path = Directory('${dir.path}/ICare/AIAnalysis');
          var dirPath = path.path;
          final myFile = await File('$dirPath/'+ModuleDirName+'AIAnalysis'+DateNow+'.pdf');
          String FileTitle = ModuleDirName+'AIAnalysis'+DateNow;
          widget.PrintPdf.SaveToPdf(ModuleDirName,Data,FromDate.toString(),ToDate.toString(),AnalysisModule.toString(),ModuleImage.toString());
          Timer(const Duration(seconds: 8), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFScreen(pdfPath: myFile.path,FileTitle: FileTitle),
              ),
            );
          });

          },
        elevation: 5,
        backgroundColor:  const Color.fromRGBO(32, 116, 150, 1.0),
        tooltip: "Save To PDF",
        focusColor:  const Color.fromRGBO(47, 150, 185, 1),
        splashColor: const Color.fromRGBO(47, 150, 185, 1),
        hoverColor: const Color.fromRGBO(47, 150, 185, 1),
        child: const Icon(Icons.picture_as_pdf,
            size: 30.0,
            color: Colors.white),

      ),

    );
  }

}




class SymptomsAnalysisStorage
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
    final path = Directory('${dir.path}/ICare/'+DirName);
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
  Future<String> _readData(String Filename, String DirName) async {
    final dirPath =  await createFolder(DirName);
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
  Future<void> _writeData(String Data, String Filename) async {
//     final _dirPath = await createFolder();
//
//     final _myFile = File('$_dirPath/'+Filename+'.txt');
// // If data.txt doesn't exist, it will be created automatically
//
//     await _myFile.writeAsString(Data);
  }

}

class SymptomsPdfReport
{
  Future<String> createFolder(String DirName) async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/'+DirName);
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

  Future<void> SaveToPdf(String ModuleName, List Data,String FromDate,String ToDate,String AnalysisModule,String ModuleImage) async {
    final pdf = pw.Document();

    var now =  DateTime.now();
    var outputFormat = DateFormat('MMddyyyy');
    var outputDate = outputFormat.format(now);
    String? DateNow = outputDate.toString().replaceAll("/", "");

    final ByteData IcareIconbytes = await rootBundle.load('assets/img/icareicon.png');
    final Uint8List IcareIconbyteList = IcareIconbytes.buffer.asUint8List();
    final ByteData AiAnalysisbytes = await rootBundle.load('assets/img/analysis32.png');
    final Uint8List AiAnalysisbyteList = AiAnalysisbytes.buffer.asUint8List();
    final ByteData ModuleIconbytes = await rootBundle.load('assets/img/symptoms32.png');
    final Uint8List ModuleIconbyteList = ModuleIconbytes.buffer.asUint8List();

    Fluttertoast.showToast(
        msg: "Pdf is being generated,It may take time.\n Please be patient.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 14.0);



    for (var i = 0; i < Data.length; i++) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 50, horizontal: 10),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisSize: pw.MainAxisSize.max,
                  children: [
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.SizedBox(width: 30),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Image(
                                    pw.MemoryImage(
                                      IcareIconbyteList,
                                    ),
                                    height: 40,
                                    width: 40,
                                    fit: pw.BoxFit.contain),
                              ]
                          ),
                          pw.SizedBox(width: 100),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("ICare AI Analysis",
                                    style: const pw.TextStyle(fontSize: 16,color: PdfColors.teal,)),
                              ]
                          ),
                          pw.SizedBox(width: 100),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Image(
                                    pw.MemoryImage(
                                      AiAnalysisbyteList,
                                    ),
                                    height: 40,
                                    width: 40,
                                    fit: pw.BoxFit.contain),
                              ]
                          ),
                        ]
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        'Symptoms Analysis',
                        style: const pw.TextStyle(fontSize: 14)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        FromDate+" - "+ToDate,
                        style: const pw.TextStyle(fontSize: 14,color: PdfColors.teal,)),
                    pw.SizedBox(height: 10),
                    pw.Image(
                        pw.MemoryImage(
                          ModuleIconbyteList,
                        ),
                        height: 40,
                        width: 40,
                        fit: pw.BoxFit.contain),
                    pw.SizedBox(height: 20),
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.SizedBox(width: 30),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("Date : "+Data[i][0],
                                    style: const pw.TextStyle(fontSize: 14)),
                              ]
                          ),
                          pw.SizedBox(width: 110),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("Description : "+Data[i][3],
                                    style: const pw.TextStyle(fontSize: 14)),
                              ]
                          ),
                        ]
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.SizedBox(width: 30),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("Symptom : "+Data[i][1]+ " / " +Data[i][2],
                                    style: const pw.TextStyle(fontSize: 14)),
                              ]
                          ),
                          pw.SizedBox(width: 110),
                        ]
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text("Recommendations for "+ Data[i][1] +" Symptoms",
                        style: const pw.TextStyle(fontSize: 16,color: PdfColors.teal,)),
                    pw.SizedBox(height: 10),

                    pw.Text("Never Take any Medications Without Consulting A/An " +Data[i][5]+"\n\n"+Data[i][6],textAlign: pw.TextAlign.left,
                            style: const pw.TextStyle(
                              fontSize: 10, lineSpacing: 10.0,color: PdfColors.blue900,)),

                  ]
              )
          ),
        ),
      );
    }


    final dirPath =  await createFolder("AIAnalysis");
    final myFile = await File('$dirPath/'+ModuleName+'AIAnalysis'+DateNow+'.pdf');

    try{
      if(await myFile.exists()) {
        await myFile.writeAsBytes(await pdf.save());
        Fluttertoast.showToast(
            msg: "Pdf Saved Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);



      }
      else {
        await myFile.writeAsBytes(await pdf.save());
        Fluttertoast.showToast(
            msg: "Pdf Saved Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);      }
    }
    catch(ex)
    {
      Fluttertoast.showToast(
          msg: "Failed to Save Pdf!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 14.0);
    }

  }
}

class SymptomsActiveRecommendations
{
  Future<String> _readRecommendationsBank() async {
    return await rootBundle.loadString('assets/files/SymptomsAiBank.txt');
  }


  Future<String> _SearchRecommendationsBank(int RecommendationIndex) async {
    try {
      String result = "";
      String value = await _readRecommendationsBank();
      List<String> Recommendations = value.split('&');
        if(Recommendations.isNotEmpty) {
          // result = Recommendations[RecommendationIndex].toString().replaceAll("\r\n", "");
          result = Recommendations[RecommendationIndex].toString();
        }
      return result;

    } catch (Exception) {
      return "";
    }
  }

}



