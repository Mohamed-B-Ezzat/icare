import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' as intl;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../Widgets/PDFScreen.dart';



class ReportsLayoutPage extends StatefulWidget {
  String FromDate, ToDate;
  final ReportsStorage storage;
  final ReportsPdfReport PrintPdf;
  

  ReportsLayoutPage({ required this.FromDate, required this.ToDate, Key? key, required this.storage, required this.PrintPdf}) : super(key: key);

  @override
  _ReportsLayoutPageState createState() => _ReportsLayoutPageState(this.FromDate, this.ToDate);
}

class _ReportsLayoutPageState extends State<ReportsLayoutPage>  {

  var FromDate;
  var ToDate;
  _ReportsLayoutPageState(this.FromDate, this.ToDate);


  bool showProgress = false;

  final verticalScroll = ScrollController();
  final horizontalScroll = ScrollController();

  var ListData;
  var RecommendationsData;
  var ReportsData;
  var VitalSignsData,PrescriptionsData,LabTestsData,VaccinationsData,SymptomsData,ScansData,AllergiesData;

  String ModuleImage = "";
  String ModuleFileName = "";
  String ModuleDirName = "";
  var LanguageData =0;

  var ReportTitle = ["Reports","التقارير",""];
  var IcareReportTitle = ["Icare Report","التقارير",""];
  var SaveToPdfTitle = ["Save To Pdf","حفظ في ملف PDF",""];
  var DateErrorTitle = ["From or To Date is not correct","من أو إلى التاريخ غير صحيح",""];
  var AnalysisSuccessMsg = ["Data is being Analyzed. It will take some time, Please be patient.","يجري تحليل البيانات. سيستغرق الأمر بعض الوقت ، يرجى الانتظار.",""];
  var AnalysisFailMsg = ["Analysis Failed, Check Required Dates.","فشل التحليل ، تحقق من التواريخ المطلوبة.",""];


  @override
  void initState() {
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
    //Read Vital Signs
    widget.storage._readData("icare_vital_signs","VitalSigns").then((String value) async{
      if(value != "No Data")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);
        if(lines.isNotEmpty)
        {
          int row = lines.length;
          int col = 4;

          ListData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result =  lines[i].split('#');
            DateTime ResultDate = new intl.DateFormat("MM/dd/yyyy").parse(result[0]);
            DateTime FromDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(FromDate);
            DateTime ToDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(ToDate);
            if((ResultDate.isAtSameMomentAs(FromDateParsed) || ResultDate.isAfter(FromDateParsed)) && (ResultDate.isAtSameMomentAs(ToDateParsed) || ResultDate.isBefore(ToDateParsed))) {
              for (var j = 0; j < 4; j++) {
                ListData[i][j] = result[j];
              }
            }
          }
        }
        String filteredData = "";
        for (var i = 0; i < ListData.length; i++) {
          for (var j = 0; j < 4; j++) {
            if(ListData[i][j] != "")
            {
              filteredData += ListData[i][j];
              if(j!=3)
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
          int col = 4;

          ReportsData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < newlines.length; i++) {
            List<String> result =  newlines[i].split('#');
            for (var j = 0; j < 4; j++) {
              ReportsData[i][j] = result[j];
            }
          }
        }


        setState(() {
          VitalSignsData = ReportsData;
        });


      }
      else
      {
        Fluttertoast.showToast(
            msg: "No Added Vital Signs in Selected Time Period.\nPlease Add new!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      }

    });

    //Read Prescriptions
    widget.storage._readData("icare_prescriptions","Prescriptions").then((String value) async{
      if(value != "No Data")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);
        if(lines.isNotEmpty)
        {
          int row = lines.length;
          int col = 4;

          ListData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result =  lines[i].split('#');
            DateTime ResultDate = new intl.DateFormat("MM/dd/yyyy").parse(result[0]);
            DateTime FromDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(FromDate);
            DateTime ToDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(ToDate);
            if((ResultDate.isAtSameMomentAs(FromDateParsed) || ResultDate.isAfter(FromDateParsed)) && (ResultDate.isAtSameMomentAs(ToDateParsed) || ResultDate.isBefore(ToDateParsed))) {
              for (var j = 0; j < 4; j++) {
                ListData[i][j] = result[j];
              }
            }
          }
        }
        String filteredData = "";
        for (var i = 0; i < ListData.length; i++) {
          for (var j = 0; j < 4; j++) {
            if(ListData[i][j] != "")
            {
              filteredData += ListData[i][j];
              if(j!=3)
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
          int col = 4;

          ReportsData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < newlines.length; i++) {
            List<String> result =  newlines[i].split('#');
            for (var j = 0; j < 4; j++) {
              ReportsData[i][j] = result[j];
            }
          }
        }


        setState(() {
          PrescriptionsData = ReportsData;
        });


      }
      else
      {
        Fluttertoast.showToast(
            msg: "No Added Prescriptions in Selected Time Period.\nPlease Add new!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      }

    });

    //Read Lab Tests
    widget.storage._readData("icare_labtests","LabTests").then((String value) async{
      if(value != "No Data")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);
        if(lines.isNotEmpty)
        {
          int row = lines.length;
          int col = 5;

          ListData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result =  lines[i].split('#');
            DateTime ResultDate = new intl.DateFormat("MM/dd/yyyy").parse(result[0]);
            DateTime FromDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(FromDate);
            DateTime ToDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(ToDate);
            if((ResultDate.isAtSameMomentAs(FromDateParsed) || ResultDate.isAfter(FromDateParsed)) && (ResultDate.isAtSameMomentAs(ToDateParsed) || ResultDate.isBefore(ToDateParsed))) {
              for (var j = 0; j < 5; j++) {
                ListData[i][j] = result[j];
              }
            }
          }
        }
        String filteredData = "";
        for (var i = 0; i < ListData.length; i++) {
          for (var j = 0; j < 5; j++) {
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
          int col = 5;

          ReportsData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < newlines.length; i++) {
            List<String> result =  newlines[i].split('#');
            for (var j = 0; j < 5; j++) {
              ReportsData[i][j] = result[j];
            }
          }
        }


        setState(() {
          LabTestsData = ReportsData;
        });


      }
      else
      {
        Fluttertoast.showToast(
            msg: "No Added Lab Tests in Selected Time Period.\nPlease Add new!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      }

    });

    //Read Vaccinations
    widget.storage._readData("icare_vaccinations","Vaccinations").then((String value) async{
      if(value != "No Data")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);
        if(lines.isNotEmpty)
        {
          int row = lines.length;
          int col = 4;

          ListData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result =  lines[i].split('#');
            DateTime ResultDate = new intl.DateFormat("MM/dd/yyyy").parse(result[0]);
            DateTime FromDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(FromDate);
            DateTime ToDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(ToDate);
            if((ResultDate.isAtSameMomentAs(FromDateParsed) || ResultDate.isAfter(FromDateParsed)) && (ResultDate.isAtSameMomentAs(ToDateParsed) || ResultDate.isBefore(ToDateParsed))) {
              for (var j = 0; j < 4; j++) {
                ListData[i][j] = result[j];
              }
            }
          }
        }
        String filteredData = "";
        for (var i = 0; i < ListData.length; i++) {
          for (var j = 0; j < 4; j++) {
            if(ListData[i][j] != "")
            {
              filteredData += ListData[i][j];
              if(j!=3)
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
          int col = 4;

          ReportsData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < newlines.length; i++) {
            List<String> result =  newlines[i].split('#');
            for (var j = 0; j < 4; j++) {
              ReportsData[i][j] = result[j];
            }
          }
        }


        setState(() {
          VaccinationsData = ReportsData;
        });


      }
      else
      {
        Fluttertoast.showToast(
            msg: "No Added Vaccinations in Selected Time Period.\nPlease Add new!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      }

    });

    //Read Symptoms
    widget.storage._readData("icare_symptoms","Symptoms").then((String value) async{
      if(value != "No Data")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);
        if(lines.isNotEmpty)
        {
          int row = lines.length;
          int col = 5;

          ListData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result =  lines[i].split('#');
            DateTime ResultDate = new intl.DateFormat("MM/dd/yyyy").parse(result[0]);
            DateTime FromDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(FromDate);
            DateTime ToDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(ToDate);
            if((ResultDate.isAtSameMomentAs(FromDateParsed) || ResultDate.isAfter(FromDateParsed)) && (ResultDate.isAtSameMomentAs(ToDateParsed) || ResultDate.isBefore(ToDateParsed))) {
              for (var j = 0; j < 5; j++) {
                ListData[i][j] = result[j];
              }
            }
          }
        }
        String filteredData = "";
        for (var i = 0; i < ListData.length; i++) {
          for (var j = 0; j < 5; j++) {
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
          int col = 5;

          ReportsData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < newlines.length; i++) {
            List<String> result =  newlines[i].split('#');
            for (var j = 0; j < 5; j++) {
              ReportsData[i][j] = result[j];
            }
          }
        }


        setState(() {
          SymptomsData = ReportsData;
        });


      }
      else
      {
        Fluttertoast.showToast(
            msg: "No Added Symptoms in Selected Time Period.\nPlease Add new!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      }

    });

    //Read Scans
    widget.storage._readData("icare_scans","Scans").then((String value) async{
      if(value != "No Data")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);
        if(lines.isNotEmpty)
        {
          int row = lines.length;
          int col = 4;

          ListData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result =  lines[i].split('#');
            DateTime ResultDate = new intl.DateFormat("MM/dd/yyyy").parse(result[0]);
            DateTime FromDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(FromDate);
            DateTime ToDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(ToDate);
            if((ResultDate.isAtSameMomentAs(FromDateParsed) || ResultDate.isAfter(FromDateParsed)) && (ResultDate.isAtSameMomentAs(ToDateParsed) || ResultDate.isBefore(ToDateParsed))) {
              for (var j = 0; j < 4; j++) {
                ListData[i][j] = result[j];
              }
            }
          }
        }
        String filteredData = "";
        for (var i = 0; i < ListData.length; i++) {
          for (var j = 0; j < 4; j++) {
            if(ListData[i][j] != "")
            {
              filteredData += ListData[i][j];
              if(j!=3)
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
          int col = 4;

          ReportsData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < newlines.length; i++) {
            List<String> result =  newlines[i].split('#');
            for (var j = 0; j < 4; j++) {
              ReportsData[i][j] = result[j];
            }
          }
        }


        setState(() {
          ScansData = ReportsData;
        });


      }
      else
      {
        Fluttertoast.showToast(
            msg: "No Added Scans in Selected Time Period.\nPlease Add new!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      }

    });

    //Read Allergies
    widget.storage._readData("icare_allergies","Allergies").then((String value) async{
      if(value != "No Data")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);
        if(lines.isNotEmpty)
        {
          int row = lines.length;
          int col = 5;

          ListData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result =  lines[i].split('#');
            DateTime ResultDate = new intl.DateFormat("MM/dd/yyyy").parse(result[0]);
            DateTime FromDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(FromDate);
            DateTime ToDateParsed = new intl.DateFormat("MM/dd/yyyy").parse(ToDate);
            if((ResultDate.isAtSameMomentAs(FromDateParsed) || ResultDate.isAfter(FromDateParsed)) && (ResultDate.isAtSameMomentAs(ToDateParsed) || ResultDate.isBefore(ToDateParsed))) {
              for (var j = 0; j < 5; j++) {
                ListData[i][j] = result[j];
              }
            }
          }
        }
        String filteredData = "";
        for (var i = 0; i < ListData.length; i++) {
          for (var j = 0; j < 5; j++) {
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
          int col = 5;

          ReportsData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < newlines.length; i++) {
            List<String> result =  newlines[i].split('#');
            for (var j = 0; j < 5; j++) {
              ReportsData[i][j] = result[j];
            }
          }
        }


        setState(() {
          AllergiesData = ReportsData;
        });


      }
      else
      {
        Fluttertoast.showToast(
            msg: "No Added Allergies in Selected Time Period.\nPlease Add new!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      }

    });


    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    var now =  DateTime.now();
    var outputFormat = intl.DateFormat('MM/dd/yyyy');
    var outputDate = outputFormat.format(now);
    String? DateNow = outputDate.toString().replaceAll("/", "");

    return Scaffold(
      //extendBodyBehindAppBar: true,
      drawer: MainMenu(storage: MainMenuStorage()),
      appBar: AppBar(
        title: Text(IcareReportTitle[LanguageData],
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
                          final path = Directory('${dir.path}/ICare/Reports');
                          var dirPath = path.path;
                          final myFile = await File('$dirPath/ICareReport'+DateNow+'.pdf');
                          String FileTitle = 'ICareReport'+DateNow;
                          widget.PrintPdf.SaveToPdf(PrescriptionsData, PrescriptionsData, LabTestsData, VaccinationsData, SymptomsData, ScansData, AllergiesData, FromDate.toString(),ToDate.toString());
                          Timer(const Duration(seconds: 8), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Directionality( // use this
                              textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                              child: PDFScreen(pdfPath: myFile.path,FileTitle: FileTitle),),
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
                                  child: Text("ICare Report",
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
                                'assets/svg/reports.svg',
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
                                    :Text(DateErrorTitle[LanguageData],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.teal,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

// Vital Signs

                            // Module Name
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: const Text("Vital Signs",
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

                            const SizedBox(
                              height: 10.0,
                            ),

                            Scrollbar(
                              isAlwaysShown: true,
                              thickness: 0.0,
                              //scrollbarOrientation: ScrollbarOrientation.bottom,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScroll,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child:  DataTable(
                                        columns: const [
                                          DataColumn(label: Text(
                                              'Date',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Doctor',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Ingredients',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                        ],
                                        rows: [
                                          if(PrescriptionsData != null)
                                            for (var rowData in PrescriptionsData)
                                              rowData[0].toString() != ""
                                                  ?DataRow(cells: [
                                                DataCell(Text(rowData[0].toString())),
                                                DataCell(Text(rowData[3].toString()+" / "+rowData[1].toString())),
                                                DataCell(Text(rowData[2].toString())),
                                              ])
                                                  :const DataRow(cells: [
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                              ])
                                          else
                                            const DataRow(cells: [
                                              DataCell(Text("No Added",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Vital Signs in",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Selected time period",style: TextStyle(color: Colors.redAccent),)),
                                            ])
                                           ],
                                      ),
                                    ),
                                  ],

                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

// Prescriptions

                            // Module Name
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: const Text("Prescriptions",
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

                            const SizedBox(
                              height: 10.0,
                            ),

                            Scrollbar(
                              isAlwaysShown: true,
                              thickness: 0.0,
                              //scrollbarOrientation: ScrollbarOrientation.bottom,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScroll,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child:  DataTable(
                                        columns: const [
                                          DataColumn(label: Text(
                                              'Date',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Doctor',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Ingredients',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                        ],
                                        rows: [
                                          if(PrescriptionsData != null)
                                            for (var rowData in PrescriptionsData)
                                              rowData[0].toString() != ""
                                                  ?DataRow(cells: [
                                                DataCell(Text(rowData[0].toString())),
                                                DataCell(Text(rowData[3].toString()+" / "+rowData[1].toString())),
                                                DataCell(Text(rowData[2].toString())),
                                              ])
                                                  :const DataRow(cells: [
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                              ])
                                          else
                                            const DataRow(cells: [
                                              DataCell(Text("No Added",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Prescriptions in",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Selected time period",style: TextStyle(color: Colors.redAccent),)),
                                            ])
                                          


                                        ],
                                      ),
                                    ),
                                  ],

                                ),
                              ),
                            ),


                            const SizedBox(
                              height: 10.0,
                            ),

// Lab Tests
                            // Module Name
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: const Text("Lab Tests",
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

                            const SizedBox(
                              height: 10.0,
                            ),

                            Scrollbar(
                              isAlwaysShown: true,
                              thickness: 0.0,
                              //scrollbarOrientation: ScrollbarOrientation.bottom,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScroll,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child:  DataTable(
                                        columns: const [
                                          DataColumn(label: Text(
                                              'Date',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Lab Test',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Description',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                        ],
                                        rows: [
                                          if(LabTestsData != null)
                                            for (var rowData in LabTestsData)
                                              rowData[0].toString() != ""
                                                  ?DataRow(cells: [
                                                DataCell(Text(rowData[0].toString())),
                                                DataCell(Text(rowData[1].toString()+" / "+rowData[2].toString())),
                                                DataCell(Text(rowData[4].toString())),
                                              ])
                                                  :const DataRow(cells: [
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                              ])
                                          else
                                            const DataRow(cells: [
                                              DataCell(Text("No Added",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Lab Tests in",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Selected time period",style: TextStyle(color: Colors.redAccent),)),
                                            ])
                                          


                                        ],
                                      ),
                                    ),
                                  ],

                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

// Vaccinations
                            // Module Name
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: const Text("Vaccinations",
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

                            const SizedBox(
                              height: 10.0,
                            ),

                            Scrollbar(
                              isAlwaysShown: true,
                              thickness: 0.0,
                              //scrollbarOrientation: ScrollbarOrientation.bottom,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScroll,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child:  DataTable(
                                        columns: const [
                                          DataColumn(label: Text(
                                              'Date',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Vaccine Name',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Address',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Description',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                        ],
                                        rows: [
                                          if(VaccinationsData != null)
                                            for (var rowData in VaccinationsData)
                                              rowData[0].toString() != ""
                                                  ?DataRow(cells: [
                                                DataCell(Text(rowData[0].toString())),
                                                DataCell(Text(rowData[1].toString())),
                                                DataCell(Text(rowData[2].toString())),
                                                DataCell(Text(rowData[3].toString())),
                                              ])
                                                  :const DataRow(cells: [
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                              ])
                                          else
                                            const DataRow(cells: [
                                              DataCell(Text("No Added",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Vaccinations",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("in Selected",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("time period",style: TextStyle(color: Colors.redAccent),)),
                                            ])


                                        ],
                                      ),
                                    ),
                                  ],

                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

// Symptoms
                            // Module Name
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: const Text("Symptoms",
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

                            const SizedBox(
                              height: 10.0,
                            ),

                            Scrollbar(
                              isAlwaysShown: true,
                              thickness: 0.0,
                              //scrollbarOrientation: ScrollbarOrientation.bottom,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScroll,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child:  DataTable(
                                        columns: const [
                                          DataColumn(label: Text(
                                              'Date',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Symptoms',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Description',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                        ],
                                        rows: [
                                          if(SymptomsData != null)
                                            for (var rowData in SymptomsData)
                                              rowData[0].toString() != ""
                                                  ?DataRow(cells: [
                                                DataCell(Text(rowData[0].toString())),
                                                DataCell(Text(rowData[1].toString()+" / "+rowData[2].toString())),
                                                DataCell(Text(rowData[3].toString())),
                                              ])
                                                  :const DataRow(cells: [
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                              ])
                                          else
                                            const DataRow(cells: [
                                              DataCell(Text("No Added",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Symptoms in",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Selected time period",style: TextStyle(color: Colors.redAccent),)),
                                            ])


                                        ],
                                      ),
                                    ),
                                  ],

                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

// Scans
                            // Module Name
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: const Text("Scans",
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

                            const SizedBox(
                              height: 10.0,
                            ),

                            Scrollbar(
                              isAlwaysShown: true,
                              thickness: 0.0,
                              //scrollbarOrientation: ScrollbarOrientation.bottom,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScroll,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child:  DataTable(
                                        columns: const [
                                          DataColumn(label: Text(
                                              'Date',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Scan Name',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Description',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                        ],
                                        rows: [
                                          if(ScansData != null)
                                            for (var rowData in ScansData)
                                              rowData[0].toString() != ""
                                                  ?DataRow(cells: [
                                                DataCell(Text(rowData[0].toString())),
                                                DataCell(Text(rowData[1].toString())),
                                                DataCell(Text(rowData[3].toString())),
                                              ])
                                                  :const DataRow(cells: [
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                              ])
                                          else
                                            const DataRow(cells: [
                                              DataCell(Text("No Added",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Scans in",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Selected time period",style: TextStyle(color: Colors.redAccent),)),
                                            ])

                                        ],
                                      ),
                                    ),
                                  ],

                                ),
                              ),
                            ),


                            const SizedBox(
                              height: 10.0,
                            ),

// Allergies
                            // Module Name
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: const Text("Allergies",
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

                            const SizedBox(
                              height: 10.0,
                            ),

                            Scrollbar(
                              isAlwaysShown: true,
                              thickness: 0.0,
                              //scrollbarOrientation: ScrollbarOrientation.bottom,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScroll,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child:  DataTable(
                                        columns: const [
                                          DataColumn(label: Text(
                                              'Date',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Allergy',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                          DataColumn(label: Text(
                                              'Description',
                                              style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 14, fontWeight: FontWeight.bold)
                                          )),
                                        ],
                                        rows: [
                                          if(AllergiesData != null)
                                            for (var rowData in AllergiesData)
                                              rowData[0].toString() != ""
                                                  ?DataRow(cells: [
                                                DataCell(Text(rowData[0].toString())),
                                                DataCell(Text(rowData[1].toString()+" / "+rowData[3].toString())),
                                                DataCell(Text(rowData[4].toString())),
                                              ])
                                                  :const DataRow(cells: [
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                                DataCell(Text("")),
                                              ])
                                          else
                                            const DataRow(cells: [
                                              DataCell(Text("No Added",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Allergies in",style: TextStyle(color: Colors.redAccent),)),
                                              DataCell(Text("Selected time period",style: TextStyle(color: Colors.redAccent),)),
                                            ])

                                        ],
                                      ),
                                    ),
                                  ],

                                ),
                              ),
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
          final path = Directory('${dir.path}/ICare/Reports');
          var dirPath = path.path;
          final myFile = await File('$dirPath/ICareReport'+DateNow+'.pdf');
          String FileTitle = 'ICareReport'+DateNow;
          widget.PrintPdf.SaveToPdf(PrescriptionsData, PrescriptionsData, LabTestsData, VaccinationsData, SymptomsData, ScansData, AllergiesData, FromDate.toString(),ToDate.toString());
          Timer(const Duration(seconds: 8), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
              textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
              child: PDFScreen(pdfPath: myFile.path,FileTitle: FileTitle),),
              ),
            );
          });

        },
        elevation: 5,
        backgroundColor:  const Color.fromRGBO(32, 116, 150, 1.0),
        tooltip: SaveToPdfTitle[LanguageData],
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


class ReportsStorage
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


class ReportsPdfReport
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

  Future<void> SaveToPdf(List VitalSignsData, List PrescriptionsData, List LabTestsData, List VaccinationsData, List SymptomsData, List ScansData, List AllergiesData, String FromDate,String ToDate) async {
    final pdf = pw.Document();

    var now =  DateTime.now();
    var outputFormat = intl.DateFormat('MMddyyyy');
    var outputDate = outputFormat.format(now);
    String? DateNow = outputDate.toString().replaceAll("/", "");

    final ByteData IcareIconbytes = await rootBundle.load('assets/img/icareicon.png');
    final Uint8List IcareIconbyteList = IcareIconbytes.buffer.asUint8List();
    final ByteData AiAnalysisbytes = await rootBundle.load('assets/img/reports32.png');
    final Uint8List AiAnalysisbyteList = AiAnalysisbytes.buffer.asUint8List();
    final ByteData VitalSignsIconbytes = await rootBundle.load('assets/img/vitals32.png');
    final Uint8List VitalSignsIconbyteList = VitalSignsIconbytes.buffer.asUint8List();
    final ByteData PrescriptionsIconbytes = await rootBundle.load('assets/img/prescriptions32.png');
    final Uint8List PrescriptionsIconbyteList = PrescriptionsIconbytes.buffer.asUint8List();
    final ByteData LabTestsIconbytes = await rootBundle.load('assets/img/labtests32.png');
    final Uint8List LabTestsIconbyteList = LabTestsIconbytes.buffer.asUint8List();
    final ByteData VaccinationsIconbytes = await rootBundle.load('assets/img/vaccinations32.png');
    final Uint8List VaccinationsIconbyteList = VaccinationsIconbytes.buffer.asUint8List();
    final ByteData SymptomsIconbytes = await rootBundle.load('assets/img/symptoms32.png');
    final Uint8List SymptomsIconbyteList = SymptomsIconbytes.buffer.asUint8List();
    final ByteData ScansIconbytes = await rootBundle.load('assets/img/scans32.png');
    final Uint8List ScansIconbyteList = ScansIconbytes.buffer.asUint8List();
    final ByteData AllergiesIconbytes = await rootBundle.load('assets/img/allergies32.png');
    final Uint8List AllergiesIconbyteList = AllergiesIconbytes.buffer.asUint8List();

    Fluttertoast.showToast(
        msg: "Pdf is being generated,It may take time.\n Please be patient.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 14.0);


// Vital Signs
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
                          pw.SizedBox(width: 120),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("ICare Report",
                                    style: const pw.TextStyle(fontSize: 16,color: PdfColors.teal,)),
                              ]
                          ),
                          pw.SizedBox(width: 120),
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
                        'Vital Signs Report',
                        style: const pw.TextStyle(fontSize: 14)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        FromDate+" - "+ToDate,
                        style: const pw.TextStyle(fontSize: 14,color: PdfColors.teal,)),
                    pw.SizedBox(height: 10),
                    pw.Image(
                        pw.MemoryImage(
                          VitalSignsIconbyteList,
                        ),
                        height: 40,
                        width: 40,
                        fit: pw.BoxFit.contain),
                    pw.SizedBox(height: 10),
                    PrescriptionsData != null
                        ?pw.Table(
                        children: [
                          for (var i = 0; i <= PrescriptionsData.length; i++)
                            i != 0
                                ?pw.TableRow(
                                children: [
                                  pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text(PrescriptionsData[i-1][0],
                                            style: const pw.TextStyle(fontSize: 12)),
                                        pw.Divider(thickness: 1)
                                      ]
                                  ),
                                  pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text(PrescriptionsData[i-1][3] +" / "+ PrescriptionsData[i-1][1],
                                            style: const pw.TextStyle(fontSize: 12)),
                                        pw.Divider(thickness: 1)
                                      ]
                                  ),
                                  pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text(PrescriptionsData[i-1][2],
                                            style: const pw.TextStyle(fontSize: 12)),
                                        pw.Divider(thickness: 1)
                                      ]
                                  ),

                                ]
                            )
                                :pw.TableRow(
                                children: [
                                  pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text("Date",
                                            style: const pw.TextStyle(fontSize: 14)),
                                        pw.Divider(thickness: 1)
                                      ]
                                  ),
                                  pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text("Doctor",
                                            style: const pw.TextStyle(fontSize: 14)),
                                        pw.Divider(thickness: 1)
                                      ]
                                  ),
                                  pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text("Ingredients",
                                            style: const pw.TextStyle(fontSize: 14)),
                                        pw.Divider(thickness: 1)
                                      ]
                                  ),

                                ]
                            )
                        ]
                    )
                        :pw.Table(
                        children: [
                          pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Date",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Doctor",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Ingredients",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),

                              ]
                          ),
                          pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("No Added",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Prescriptions in",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Selected Time Period",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                )
                              ]
                          )
                        ]
                    ),
                  ]
              )
          ),
        ),
      );

// Prescriptions
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
                        pw.SizedBox(width: 120),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("ICare Report",
                                    style: const pw.TextStyle(fontSize: 16,color: PdfColors.teal,)),
                              ]
                          ),
                          pw.SizedBox(width: 120),
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
                      'Prescriptions Report',
                      style: const pw.TextStyle(fontSize: 14)),
                  pw.SizedBox(height: 10),
                  pw.Text(
                      FromDate+" - "+ToDate,
                      style: const pw.TextStyle(fontSize: 14,color: PdfColors.teal,)),
                  pw.SizedBox(height: 10),
                  pw.Image(
                      pw.MemoryImage(
                        PrescriptionsIconbyteList,
                      ),
                      height: 40,
                      width: 40,
                      fit: pw.BoxFit.contain),
                  pw.SizedBox(height: 10),
                  PrescriptionsData != null
                      ?pw.Table(
                      children: [
                        for (var i = 0; i <= PrescriptionsData.length; i++)
                          i != 0
                              ?pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(PrescriptionsData[i-1][0],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(PrescriptionsData[i-1][3] +" / "+ PrescriptionsData[i-1][1],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(PrescriptionsData[i-1][2],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),

                              ]
                          )
                              :pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Date",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Doctor",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Ingredients",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),

                              ]
                          )
                      ]
                  )
                      :pw.Table(
                      children: [
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Date",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Doctor",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Ingredients",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),

                            ]
                        ),
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("No Added",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Prescriptions in",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Selected Time Period",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              )
                            ]
                        )
                      ]
                  ),
                ]
            )
        ),
      ),
    );

// Lab Tests
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
                        pw.SizedBox(width: 120),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("ICare Report",
                                    style: const pw.TextStyle(fontSize: 16,color: PdfColors.teal,)),
                              ]
                          ),
                          pw.SizedBox(width: 120),
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
                      'Lab Tests Report',
                      style: const pw.TextStyle(fontSize: 14)),
                  pw.SizedBox(height: 10),
                  pw.Text(
                      FromDate+" - "+ToDate,
                      style: const pw.TextStyle(fontSize: 14,color: PdfColors.teal,)),
                  pw.SizedBox(height: 10),
                  pw.Image(
                      pw.MemoryImage(
                        LabTestsIconbyteList,
                      ),
                      height: 40,
                      width: 40,
                      fit: pw.BoxFit.contain),
                  pw.SizedBox(height: 10),
                  LabTestsData != null
                  ?pw.Table(
                      children: [
                        for (var i = 0; i <= LabTestsData.length; i++)
                          i != 0
                              ?pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(LabTestsData[i-1][0],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(LabTestsData[i-1][1] +" / "+LabTestsData[i-1][2],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(LabTestsData[i-1][4],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                )
                              ]
                          )
                              :pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Date",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Lab Test",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Description",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                )
                              ]
                          )
                      ]
                  )
                      :pw.Table(
                      children: [
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Date",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Lab Test",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Description",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              )
                            ]
                        ),
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("No Added",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Lab Tests in",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Selected Time Period",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              )
                            ]
                        )
                        ]
                  ),
                ]
            )
        ),
      ),
    );

// Vaccinations
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
                        pw.SizedBox(width: 120),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("ICare Report",
                                    style: const pw.TextStyle(fontSize: 16,color: PdfColors.teal,)),
                              ]
                          ),
                          pw.SizedBox(width: 120),
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
                      'Vaccinations Report',
                      style: const pw.TextStyle(fontSize: 14)),
                  pw.SizedBox(height: 10),
                  pw.Text(
                      FromDate+" - "+ToDate,
                      style: const pw.TextStyle(fontSize: 14,color: PdfColors.teal,)),
                  pw.SizedBox(height: 10),
                  pw.Image(
                      pw.MemoryImage(
                        VaccinationsIconbyteList,
                      ),
                      height: 40,
                      width: 40,
                      fit: pw.BoxFit.contain),
                  pw.SizedBox(height: 10),
                  VaccinationsData != null
                  ?pw.Table(
                      children: [
                        for (var i = 0; i <= VaccinationsData.length; i++)
                          i != 0
                              ?pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(VaccinationsData[i-1][0],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(VaccinationsData[i-1][1],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(VaccinationsData[i-1][2],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(VaccinationsData[i-1][3],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                )
                              ]
                          )
                              :pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Date",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Vaccine Name",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Address",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Description",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                )
                              ]
                          )
                      ]
                  )
                      :pw.Table(
                      children: [
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Date",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Vaccine Name",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Address",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Description",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              )
                            ]
                        ),
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("No Added",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Vaccinations",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("in selected",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("time period",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              )
                            ]
                        )
                      ]
                  ),
                ]
            )
        ),
      ),
    );

// Symptoms
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
                        pw.SizedBox(width: 120),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("ICare Report",
                                    style: const pw.TextStyle(fontSize: 16,color: PdfColors.teal,)),
                              ]
                          ),
                          pw.SizedBox(width: 120),
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
                      'Symptoms Report',
                      style: const pw.TextStyle(fontSize: 14)),
                  pw.SizedBox(height: 10),
                  pw.Text(
                      FromDate+" - "+ToDate,
                      style: const pw.TextStyle(fontSize: 14,color: PdfColors.teal,)),
                  pw.SizedBox(height: 10),
                  pw.Image(
                      pw.MemoryImage(
                        SymptomsIconbyteList,
                      ),
                      height: 40,
                      width: 40,
                      fit: pw.BoxFit.contain),
                  pw.SizedBox(height: 10),
                  SymptomsData != null
                  ?pw.Table(
                      children: [
                        for (var i = 0; i <= SymptomsData.length; i++)
                          i != 0
                              ?pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(SymptomsData[i-1][0],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(SymptomsData[i-1][1] +" / "+SymptomsData[i-1][2] ,
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(SymptomsData[i-1][3],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),

                              ]
                          )
                              :pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Date",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Symptom",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Description",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                )
                              ]
                          )
                      ]
                  )
                      :pw.Table(
                      children: [
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Date",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Symptom",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Description",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              )
                            ]
                        ),
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("No Added",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Symptoms in",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Selected Time Period",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              )
                            ]
                        )
                      ]
                  ),
                ]
            )
        ),
      ),
    );

// Scans
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
                        pw.SizedBox(width: 120),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("ICare Report",
                                    style: const pw.TextStyle(fontSize: 16,color: PdfColors.teal,)),
                              ]
                          ),
                          pw.SizedBox(width: 120),
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
                      'Scans Report',
                      style: const pw.TextStyle(fontSize: 14)),
                  pw.SizedBox(height: 10),
                  pw.Text(
                      FromDate+" - "+ToDate,
                      style: const pw.TextStyle(fontSize: 14,color: PdfColors.teal,)),
                  pw.SizedBox(height: 10),
                  pw.Image(
                      pw.MemoryImage(
                        ScansIconbyteList,
                      ),
                      height: 40,
                      width: 40,
                      fit: pw.BoxFit.contain),
                  pw.SizedBox(height: 10),
                  ScansData != null
                      ?pw.Table(
                      children: [
                        for (var i = 0; i <= ScansData.length; i++)
                          i != 0
                              ?pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(ScansData[i-1][0],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(ScansData[i-1][1],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(ScansData[i-1][3],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),

                              ]
                          )
                              :pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Date",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Scan",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Description",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                )
                              ]
                          )
                      ]
                  )
                      :pw.Table(
                      children: [
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Date",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Scan",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Description",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              )
                            ]
                        ),
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("No Added",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Scans in",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Selected Time Period",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              )
                            ]
                        )
                      ]
                  ),
                ]
            )
        ),
      ),
    );


// Allergies
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
                        pw.SizedBox(width: 120),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("ICare Report",
                                    style: const pw.TextStyle(fontSize: 16,color: PdfColors.teal,)),
                              ]
                          ),
                          pw.SizedBox(width: 120),
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
                      'Allergies Report',
                      style: const pw.TextStyle(fontSize: 14)),
                  pw.SizedBox(height: 10),
                  pw.Text(
                      FromDate+" - "+ToDate,
                      style: const pw.TextStyle(fontSize: 14,color: PdfColors.teal,)),
                  pw.SizedBox(height: 10),
                  pw.Image(
                      pw.MemoryImage(
                        AllergiesIconbyteList,
                      ),
                      height: 40,
                      width: 40,
                      fit: pw.BoxFit.contain),
                  pw.SizedBox(height: 10),
                  AllergiesData != null
                      ?pw.Table(
                      children: [
                        for (var i = 0; i <= AllergiesData.length; i++)
                          i != 0
                              ?pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(AllergiesData[i-1][0],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(AllergiesData[i-1][1]+" / "+AllergiesData[i-1][3],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text(AllergiesData[i-1][4],
                                          style: const pw.TextStyle(fontSize: 12)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),

                              ]
                          )
                              :pw.TableRow(
                              children: [
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Date",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Allergy",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                ),
                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Text("Description",
                                          style: const pw.TextStyle(fontSize: 14)),
                                      pw.Divider(thickness: 1)
                                    ]
                                )
                              ]
                          )
                      ]
                  )
                      :pw.Table(
                      children: [
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Date",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Allergy",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Description",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              )
                            ]
                        ),
                        pw.TableRow(
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("No Added",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Allergies in",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              ),
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("Selected Time Period",
                                        style: const pw.TextStyle(fontSize: 14)),
                                    pw.Divider(thickness: 1)
                                  ]
                              )
                            ]
                        )
                      ]
                  ),

                ]
            )
        ),
      ),
    );


    final dirPath =  await createFolder("Reports");
    final myFile = await File('$dirPath/ICareReport'+DateNow+'.pdf');

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