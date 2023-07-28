import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icare/Pages/AiAnalysisSearch.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/PDFScreen.dart';
import 'AiAnalysisTutorial.dart';
import 'DeleteFilePage.dart';


class AiAnalysisHomePage extends StatefulWidget {
  final AnalysisTutorialStorage AnalysisTutorialStatus;

  AiAnalysisHomePage({ required this.AnalysisTutorialStatus });

  @override
  _AiAnalysisHomePageState createState() => _AiAnalysisHomePageState();
}

class _AiAnalysisHomePageState extends State<AiAnalysisHomePage>  {

  final verticalScroll = ScrollController();
  bool showProgress = false;

  List file = [];

  _AiAnalysisHomePageState();

  var LanguageData =0;

  var AIAnalysisTitle = ["AI Analysis","تحليل الذكاء الاصطناعي",""];
  var VitalSignsTitle = ["Vital Signs","العلامات الحيوية",""];
  var PrescriptionsTitle = ["Prescriptions","الوصفات الطبية",""];
  var LabTestsTitle = ["Lab Tests","الفحوصات المعملية",""];
  var ScansTitle = ["Scans","الأشعة",""];
  var VaccinationsTitle = ["Vaccinations","التطعيمات",""];
  var AllergiesTitle = ["Allergies","الحساسية",""];
  var SymptomsTitle = ["Symptoms","الأعراض",""];
  var TutorialTitle = ["Tutorial","شرح توضيحي",""];
  var AIFilesTitle = ["No Available Analyzed Files\n Start AI Analysis Now","لا توجد ملفات محللة متوفرة"+"\n"+" ابدأ استخدام تحليل الذكاء الإصطناعي الآن",""];


  @override
  void initState() {
    // TODO: implement initState
    widget.AnalysisTutorialStatus._readSettingsData("icare_Language").then((String value) async{
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

    widget.AnalysisTutorialStatus._readData().then((String value) async{
      if(value != "" && value != null)
      {
        if(value == "First")
        {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Directionality( // use this
              textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
              child: AiAnalysisTutorialPage()),),
          );
        }
        else
        {
          widget.AnalysisTutorialStatus._listofFiles().then((List value) async{
            setState(() {
              file = value;
            });
          });
          super.initState();
        }
      }

    });

  }



  @override
  Widget build(BuildContext context) {

    double edge = 120.0;
    double padding = edge / 10.0;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: MainMenu(storage: MainMenuStorage()),
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.analytics)),
                Tab(icon: Icon(Icons.picture_as_pdf)),
              ],
            ),
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
          body: TabBarView(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/img/grmain.png'),
                          fit: BoxFit.fill
                      )
                  ),
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  // child:Scrollbar(
                  //   isAlwaysShown: false,
                  //   thickness: 0.0,
                  //   //scrollbarOrientation: ScrollbarOrientation.bottom,
                  //   controller: verticalScroll,
                  //   child: SingleChildScrollView(
                  //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  //       scrollDirection: Axis.vertical,
                  //       controller: verticalScroll,
                  child: Stack(
                    alignment: Alignment.topCenter,

                    children: [

                      // Form Title
                      Container(
                        padding: const EdgeInsets.only(top: 0.0),
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




                      // Dependents
                      // Container(
                      // margin: const EdgeInsets.only(top:100.0),
                      // //padding: const EdgeInsets.all(10.0),
                      // decoration: const BoxDecoration(
                      // gradient: LinearGradient(
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                      // colors: <Color>[
                      // Colors.white,
                      // Colors.white,
                      // ]
                      // ),
                      // borderRadius: BorderRadius.all(Radius.circular(20)),
                      // boxShadow: [
                      // BoxShadow(
                      // color: Colors.grey,
                      // blurRadius: 4,
                      // offset: Offset(0, 2), // Shadow position
                      // ),
                      // ],
                      // ),
                      // // Horizontal Slider
                      // child:
                       Scrollbar(
                          isAlwaysShown: true,
                          thickness: 0.0,
                          //scrollbarOrientation: ScrollbarOrientation.bottom,
                          controller: verticalScroll,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                            //scrollDirection: Axis.horizontal,
                            controller: verticalScroll,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    const SizedBox(width: 10.0),
                                    //Vital Signs
                                    Expanded(
                                      // optional flex property if flex is 1 because the default flex is 1
                                      flex: 1,
                                      child: // Vital Signs
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                            child: AiAnalysisSearchPage(AnalysisModule: "Vital Signs",),
                                              )),);
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.fromLTRB(15.0,10.0,15.0,10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 150,
                                                  height: 70,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(32, 116, 150, 1.0),
                                                            Color.fromRGBO(43, 162, 164, 1.0)
                                                          ]
                                                      )
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/vitals.svg',
                                                    width: 50,
                                                    height: 50,
                                                    alignment: AlignmentDirectional.center,
                                                    // color: Colors.white,
                                                    allowDrawingOutsideViewBox: false,
                                                    // fit: BoxFit.cover,
                                                  ),

                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(edge * .2),bottomRight: Radius.circular(edge * .2),),
                                                child:  Container(
                                                  width: 150,
                                                  height: 35.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(43, 162, 164, 1.0),
                                                          Color.fromRGBO(43, 162, 164, 1.0)
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    VitalSignsTitle[LanguageData],
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    //Prescriptions
                                    Expanded(
                                      // optional flex property if flex is 1 because the default flex is 1
                                      flex: 1,
                                      child: // Prescriptions
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                            child: AiAnalysisSearchPage(AnalysisModule: "Prescriptions"),
                                              )),);
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.fromLTRB(15.0,10.0,15.0,10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 150,
                                                  height: 70,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(43, 162, 164, 1.0),
                                                            Color.fromRGBO(32, 116, 150, 1.0),
                                                          ]
                                                      )
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/prescriptions.svg',
                                                    width: 50,
                                                    height: 50,
                                                    alignment: AlignmentDirectional.center,
                                                    // color: Colors.white,
                                                    allowDrawingOutsideViewBox: false,
                                                    // fit: BoxFit.cover,
                                                  ),

                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(edge * .2),bottomRight: Radius.circular(edge * .2),),
                                                child:  Container(
                                                  width: 150,
                                                  height: 35.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(32, 116, 150, 1.0),
                                                          Color.fromRGBO(32, 116, 150, 1.0),
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    PrescriptionsTitle[LanguageData],
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    const SizedBox(width: 10.0),
                                    //Vaccinations
                                    Expanded(
                                      // optional flex property if flex is 1 because the default flex is 1
                                      flex: 1,
                                      child: // Vaccinations
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                            child: AiAnalysisSearchPage(AnalysisModule: "Vaccinations",),
                                              )),);
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.fromLTRB(15.0,10.0,15.0,10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 150,
                                                  height: 70,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(43, 162, 164, 1.0),
                                                            Color.fromRGBO(32, 116, 150, 1.0),
                                                          ]
                                                      )
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/vaccinations.svg',
                                                    width: 50,
                                                    height: 50,
                                                    alignment: AlignmentDirectional.center,
                                                    // color: Colors.white,
                                                    allowDrawingOutsideViewBox: false,
                                                    // fit: BoxFit.cover,
                                                  ),

                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(edge * .2),bottomRight: Radius.circular(edge * .2),),
                                                child:  Container(
                                                  width: 150,
                                                  height: 35.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(32, 116, 150, 1.0),
                                                          Color.fromRGBO(32, 116, 150, 1.0),
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    VaccinationsTitle[LanguageData],
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    //Lab Tests
                                    Expanded(
                                      // optional flex property if flex is 1 because the default flex is 1
                                      flex: 1,
                                      child: // Lab Tests
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                            child: AiAnalysisSearchPage(AnalysisModule: "Lab Tests"),
                                              )),);
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.fromLTRB(15.0,10.0,15.0,10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 150,
                                                  height: 70,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(32, 116, 150, 1.0),
                                                            Color.fromRGBO(43, 162, 164, 1.0)
                                                          ]
                                                      )
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/labtests.svg',
                                                    width: 50,
                                                    height: 50,
                                                    alignment: AlignmentDirectional.center,
                                                    // color: Colors.white,
                                                    allowDrawingOutsideViewBox: false,
                                                    // fit: BoxFit.cover,
                                                  ),

                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(edge * .2),bottomRight: Radius.circular(edge * .2),),
                                                child:  Container(
                                                  width: 150,
                                                  height: 35.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(43, 162, 164, 1.0),
                                                          Color.fromRGBO(43, 162, 164, 1.0)
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    LabTestsTitle[LanguageData],
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    const SizedBox(width: 10.0),
                                    //Symptoms
                                    Expanded(
                                      // optional flex property if flex is 1 because the default flex is 1
                                      flex: 1,
                                      child: // Symptoms
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                            child: AiAnalysisSearchPage(AnalysisModule: "Symptoms"),
                                              )),);
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.fromLTRB(15.0,10.0,15.0,10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 150,
                                                  height: 70,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(32, 116, 150, 1.0),
                                                            Color.fromRGBO(43, 162, 164, 1.0)
                                                          ]
                                                      )
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/symptoms.svg',
                                                    width: 50,
                                                    height: 50,
                                                    alignment: AlignmentDirectional.center,
                                                    // color: Colors.white,
                                                    allowDrawingOutsideViewBox: false,
                                                    // fit: BoxFit.cover,
                                                  ),

                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(edge * .2),bottomRight: Radius.circular(edge * .2),),
                                                child:  Container(
                                                  width: 150,
                                                  height: 35.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(43, 162, 164, 1.0),
                                                          Color.fromRGBO(43, 162, 164, 1.0)
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    SymptomsTitle[LanguageData],
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    //Scans
                                    Expanded(
                                      // optional flex property if flex is 1 because the default flex is 1
                                      flex: 1,
                                      child: // Scans
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                            child: AiAnalysisSearchPage(AnalysisModule: "Scans"),
                                              )),);
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.fromLTRB(15.0,10.0,15.0,10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 150,
                                                  height: 70,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(43, 162, 164, 1.0),
                                                            Color.fromRGBO(32, 116, 150, 1.0),
                                                          ]
                                                      )
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/scans.svg',
                                                    width: 50,
                                                    height: 50,
                                                    alignment: AlignmentDirectional.center,
                                                    // color: Colors.white,
                                                    allowDrawingOutsideViewBox: false,
                                                    // fit: BoxFit.cover,
                                                  ),

                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(edge * .2),bottomRight: Radius.circular(edge * .2),),
                                                child:  Container(
                                                  width: 150,
                                                  height: 35.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(32, 116, 150, 1.0),
                                                          Color.fromRGBO(32, 116, 150, 1.0),
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    ScansTitle[LanguageData],
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    const SizedBox(width: 10.0),
                                    //Allergies
                                    Expanded(
                                      // optional flex property if flex is 1 because the default flex is 1
                                      flex: 1,
                                      child: // Allergies
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                            child: AiAnalysisSearchPage(AnalysisModule: "Allergies"),
                                              )),);
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.fromLTRB(15.0,10.0,15.0,10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 150,
                                                  height: 70,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(43, 162, 164, 1.0),
                                                            Color.fromRGBO(32, 116, 150, 1.0),
                                                          ]
                                                      )
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/allergies.svg',
                                                    width: 50,
                                                    height: 50,
                                                    alignment: AlignmentDirectional.center,
                                                    // color: Colors.white,
                                                    allowDrawingOutsideViewBox: false,
                                                    // fit: BoxFit.cover,
                                                  ),

                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(edge * .2),bottomRight: Radius.circular(edge * .2),),
                                                child:  Container(
                                                  width: 150,
                                                  height: 35.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(32, 116, 150, 1.0),
                                                          Color.fromRGBO(32, 116, 150, 1.0),
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    AllergiesTitle[LanguageData],
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    //Tutorial
                                    Expanded(
                                      // optional flex property if flex is 1 because the default flex is 1
                                      flex: 1,
                                      child: // tutorial
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                            child: AiAnalysisTutorialPage(),
                                              )),);
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.fromLTRB(15.0,10.0,15.0,10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 150,
                                                  height: 70,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(32, 116, 150, 1.0),
                                                            Color.fromRGBO(43, 162, 164, 1.0)
                                                          ]
                                                      )
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/tutorial.svg',
                                                    width: 50,
                                                    height: 50,
                                                    alignment: AlignmentDirectional.center,
                                                    // color: Colors.white,
                                                    allowDrawingOutsideViewBox: false,
                                                    // fit: BoxFit.cover,
                                                  ),

                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(edge * .2),bottomRight: Radius.circular(edge * .2),),
                                                child:  Container(
                                                  width: 150,
                                                  height: 35.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(43, 162, 164, 1.0),
                                                          Color.fromRGBO(43, 162, 164, 1.0)
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    TutorialTitle[LanguageData],
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                  ],
                                ),

                              ],
                            ),

                          ),


                        ),

                      // ),



                    ],
                  )
                //   ),
                // ),
              ),

              file.length == 0?
              Card(margin: const EdgeInsets.only(top: 200.0),
                  child:ListTile(
                    title: Text(AIFilesTitle[LanguageData],textAlign: TextAlign.center,
                      style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),),
                  )
              ):
              ListView.builder(  //if file/folder list is grabbed, then show here
                itemCount: file.length,
                itemBuilder: (context, index) {
                  return Card(
                      child:ListTile(
                        title:  GestureDetector(
                          child:  Text(file[index].path.split('/').last,style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),),
                          onTap: ()
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>Directionality( // use this
                              textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                              child:  PDFScreen(pdfPath: file[index].path,FileTitle: file[index].path.split('/').last),
                              ),
                              ),
                            );
                          },
                        ),
                        leading: const Icon(Icons.picture_as_pdf, color: Colors.teal,),
                        trailing:GestureDetector(
                          child:  const Icon(Icons.delete, color: Colors.redAccent,),
                          onTap: ()
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Directionality( // use this
                              textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                              child: DeleteFilePage(FilePath: file[index].path,FileName: file[index].path.split('/').last, Module: "analysis"),
                              ),),
                            );
                          },
                        ),

                      )
                  );
                },
              ),

            ],
          ),

      ),
    );
  }


}


class AnalysisTutorialStorage
{
  // Make New Function
  Future<List> _listofFiles() async {
    var dir = await getApplicationDocumentsDirectory();
    List file = Directory('${dir.path}/ICare/AIAnalysis').listSync();  //use your folder name insted of resume.
    return file;
  }

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
  Future<String> _readData() async {
    final dirPath = await createFolder();
    final myFile = File('$dirPath/AnalysisTutorial.txt');
    if(await myFile.exists())
    {
      String data = await myFile.readAsString();
      return  data;
    }
    else
    {
      _writeData("First");
      return "First";
    }
  }

  // This function is triggered when the "Write" button is pressed
  Future<void> _writeData(String Data) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/AnalysisTutorial.txt');
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