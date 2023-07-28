import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../DependentWidgets/Dependentmain_menu.dart';
import 'DependentAiAnalysisHome.dart';
import 'DependentAllergies.dart';
import 'DependentAppointments.dart';
import 'DependentDoctors.dart';
import 'DependentInfo.dart';
import 'DependentLabTests.dart';
import 'DependentPrescriptions.dart';
import 'DependentReportsHome.dart';
import 'DependentScans.dart';
import 'DependentSymptoms.dart';
import 'DependentVaccinations.dart';
import 'DependentVitalSigns.dart';




class DependentHomePage extends StatefulWidget {

  final DependentHomeStorage storage;
  final String DataTitle;
  final int DataIndex;
  final List DependentDataLines;
  final String FileName;
  final String DirName;
  final String DataImage;

  DependentHomePage({Key? key, required this.storage, required this.DataTitle, required this.DataIndex, required this.DependentDataLines, required this.FileName, required this.DirName, required this.DataImage}) : super(key: key);

  @override
  _DependentHomePageState createState() => _DependentHomePageState(this.DataTitle, this.DataIndex, this.DependentDataLines, this.FileName, this.DirName, this.DataImage);
}

class _DependentHomePageState extends State<DependentHomePage> {



  var DataTitle;
  var DataIndex;
  var DependentDataLines;
  var FileName;
  var DirName;
  var DataImage;

  _DependentHomePageState(this.DataTitle, this.DataIndex, this.DependentDataLines, this.FileName, this.DirName, this.DataImage);

  var buttonsRowDirection=1 ;//ROW DIRECTION
  var buttonsColDirection=2 ;//COLOUMN DIRECTION

  var LisData,DependData,EmergencyContactsData;
  var Data,DepenData,EmergencyData;
  var ImageListData;
  var ImageList;
  var DataLines;


  final horizontalScroll = ScrollController();
  String? _content;
  var lat,long;
  String ImageData = "No Data";
  String ImageType = "Local";

  var HomeTitle = ["Home","الرئيسية",""];
  var VitalSignsTitle = ["Vital Signs","العلامات الحيوية",""];
  var DependentTitle = ["Family Member Home ","صفحة فرد الأسرة",""];
  var DependentInfoTitle = ["Family Member","فرد الأسرة",""];
  var PrescriptionsTitle = ["Prescriptions","الوصفات الطبية",""];
  var LabTestsTitle = ["Lab Tests","الفحوصات المعملية",""];
  var ScansTitle = ["Scans","الأشعة",""];
  var AppointmentsTitle = ["Appointments","المواعيد",""];
  var VaccinationsTitle = ["Vaccinations","التطعيمات",""];
  var AllergiesTitle = ["Allergies","الحساسية",""];
  var SymptomsTitle = ["Symptoms","الأعراض",""];
  var DoctorsTitle = ["Doctors","الأطباء",""];
  var EmergencyContactsTitle = ["Emergency Contacts","جهات اتصال للطوارئ",""];
  var ReportsTitle = ["Reports","التقارير",""];
  var AIAnalysisTitle = ["AI Analysis","تحليل الذكاء الاصطناعي",""];
  var AccountTitle = ["Account","الحساب الشخصي",""];
  var SettingsTitle = ["Settings","الاعدادات",""];
  var LogoutTitle = ["Logout","تسجيل الخروج",""];
  var DependentsHomeTitle = ["Family Members                 + Add new"," أفراد الأسرة                    + اضافة جديد",""];
  var NoDependentsHomeTitle = ["No Added Family Members !\nPlease add new.","لا يوجد أفراد أسرة مضافين !\nبرجاء اضافة جديد.",""];
  var SosPopupTitle = ["Sos automated Feature enables the user to notify up to 3 persons directly through mail and Whatsapp " +
      "that the user is facing a critical health emergency / situation.\n \n Are You Sure To send Sos Message ?","تتيح ميزة Sos التلقائية للمستخدم إخطار ما يصل إلى 3 أشخاص مباشرةً عبر البريد الإلكتروني و الواتساب "+
      "أن المستخدم يواجه حالة صحية طارئة حرجة."+"\n"+" هل أنت متأكد من إرسال رسالة استغاثة؟",""];
  var SosNoContactTitle = ["Sos automated Feature enables the user to notify up to 3 persons directly through mail and Whatsapp " +
      "that the user is facing a critical health emergency / situation.\n \nTo be able to use Sos feature,\nyou should add your emergency contacts first,\nDo you want to add now?","خاصية Sos الآلية تمكن المستخدم من إخطار ما يصل إلى 3 أشخاص مباشرة عبر البريد و الواتساب" +
      "أن المستخدم يواجه حالة / حالة صحية طارئة حرجة."+"\n"+"لتتمكن من استخدام ميزة Sos ، يجب عليك إضافة جهات اتصال الطوارئ أولاً ،"+"\n"+"هل تريد الإضافة الآن؟",""];
  var SosMessageTextPart1 = ["Contact ","اتصل ب ",""];
  var SosMessageTextPart2 = [" For Health Emergency Case !!!! \n \n "
      "At Location:\n","لحالة الطوارئ الصحية !!!! "+"\n"+
      "في الموقع:"+"\n",""];
  var SosMessageTextPart3 = [ "\n\nProvided by ICare,(Link to google play)","\n"+" مقدم من ICare ، (رابط إلى google play)",""];
  var YesBtnTitle = ["Yes","نعم",""];
  var NoBtnTitle = ["No","لا",""];

  var LanguageData =0;


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
    widget.storage.createDependentFolder(DirName.toString());
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

    widget.storage._readData(DirName.toString(), "icare_username").then((String value) async{
      if(value != "No Data")
      {
        setState(() {
          Data = value;
        });


      }
      else
      {
        setState(() {
          Data = "No Data";
        });
      }

    });

    widget.storage._readData(DirName.toString(), "icare_picture").then((String value) async{
      if(value != "No Data")
      {
        setState(() {
          ImageData = value;
        });
      }
      else
      {
        setState(() {
          ImageData = "No Data";
        });
      }

    });


    widget.storage._readDependentsData("icare_Dependents").then((String value) async{
      if(value != "No Data")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);
        if(lines.isNotEmpty)
        {
          int row = lines.length;
          int col = 2;
          DependData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < row; i++) {
            List<String> result =  lines[i].split(',');
            for(var j = 0; j< col; j++){
              DependData[i][j] =  result[j];
            }
          }
        }
        setState(() {
          DataLines = lines;
          DepenData = DependData;
        });
      }

    });


    widget.storage._readDependentsData("icare_pictures").then((String value) async{
      if(value != "No Data" && value != "")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);

        if(lines.isNotEmpty)
        {
          int row = Data.length;
          int col = 1;
          ImageListData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {

            ImageListData[i][0] =  lines[i];

          }
          setState(() {
            ImageList = ImageListData;
          });
        }
      }
      else
      {
        setState(() {
          ImageList = null;
        });
      }

    });

    widget.storage._readEmergencyContactsData("icare_EmergencyContacts").then((String value) async{
      if(value != "No Data")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);
        if(lines.isNotEmpty)
        {
          int row = lines.length;
          int col = 3;
          EmergencyContactsData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result =  lines[i].split(',');
            for(var j = 0; j<3; j++){
              EmergencyContactsData[i][j] =  result[j];
            }
          }
        }
        setState(() {
          EmergencyData = EmergencyContactsData;
        });
      }

    });



    widget.storage._readData(DirName.toString(), "icare_pictype").then((String value) async{
      if(value != "No Data" && value != "")
      {
        setState(() {
          ImageType = value;
        });

      }
      else
      {
        setState(() {
          ImageType = "Local";
        });
      }

    });

    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    double edge = 120.0;
    double padding = edge / 10.0;
    String SosMessage = SosMessageTextPart1[LanguageData]+Data.toString()+ SosMessageTextPart2[LanguageData]+
        "http://www.google.com/maps/place/"+lat.toString()+","+long.toString()+
        SosMessageTextPart3[LanguageData];


    return Scaffold(
      //extendBodyBehindAppBar: true,
      drawer: DependentMainMenu(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),storage: DependentMainMenuStorage(), DirName: DirName.toString(),),
      appBar: AppBar(
        title:Text(
          DependentTitle[LanguageData],
          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,)
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
          child: Stack(
            alignment: Alignment.topCenter,
            children: [

              // User Photo
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child:DataImage != "No Data" && DataImage != "" && DataImage != null
                      ? Image.file(
                    File(DataImage),
                    fit: BoxFit.cover,
                    height: 80.0,
                    width: 80.0,
                  )
                      :SvgPicture.asset(
                    'assets/svg/dependents.svg',
                    width: 50,
                    height: 50,
                    alignment: AlignmentDirectional.center,
                    //color: Colors.white,
                    allowDrawingOutsideViewBox: true,
                    // fit: BoxFit.cover,
                  ),

                ),
              ),

              // User Name
              Container(
                padding: const EdgeInsets.only(top: 80.0),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color.fromRGBO(32, 116, 150, 1.0),
                          Color.fromRGBO(32, 116, 150, 1.0)
                          // Color.fromRGBO(32, 116, 150, 1.0),
                          // Color.fromRGBO(43, 162, 164, 1.0),
                          // Color.fromRGBO(32, 116, 150, 1.0)
                        ]
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2,
                        offset: Offset(0, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0, right:20.0, left:20.0),
                    child:
                    DataTitle != null
                        ? Text(DataTitle.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        :const Text("Family Member Name",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),


                  ),
                ),

              ),

              // Home Tabs
              Container(
                margin: const EdgeInsets.only(top:140.0),
                padding: const EdgeInsets.all(10.0),
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
                // Horizontal Slider
                child: Scrollbar(
                  isAlwaysShown: false,
                  thickness: 2.0,
                  //scrollbarOrientation: ScrollbarOrientation.bottom,
                  controller: horizontalScroll,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    scrollDirection: Axis.vertical,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Container(
                            child: Scrollbar(
                              isAlwaysShown: false,
                              thickness: 2.0,
                              //scrollbarOrientation: ScrollbarOrientation.bottom,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScroll,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Vital Signs
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentVitalSignsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString()),
                                                ),
                                              ));
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
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
                                                  width: 110,
                                                  height: 30.0,
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
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
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


                                      // Prescriptions
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentPrescriptionsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentPrescriptionsStorage(), key: null,),
                                                ),
                                              ));
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[

                                                            Color.fromRGBO(43, 162, 164, 1.0),
                                                            Color.fromRGBO(32, 116, 150, 1.0),
                                                            // Color.fromRGBO(43, 162, 164, 1.0),
                                                            // Color.fromRGBO(0, 121, 107, 1.0)
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
                                                  width: 110,
                                                  height: 30.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(32, 116, 150, 1.0),
                                                          Color.fromRGBO(32, 116, 150, 1.0)
                                                          // Color.fromRGBO(0, 121, 107, 1.0),
                                                          // Color.fromRGBO(0, 121, 107, 1.0)
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    PrescriptionsTitle[LanguageData],
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
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

                                      // Scans
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentScansPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentScansStorage(), key: null,),
                                                ),
                                              ));
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
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
                                                  width: 110,
                                                  height: 30.0,
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
                                                    ScansTitle[LanguageData],
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
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
                                    ]
                                ),
                              ),
                            ),
                            // Home Tabs




                          ),

                          Container(
                            child: Scrollbar(
                              isAlwaysShown: false,
                              thickness: 2.0,
                              //scrollbarOrientation: ScrollbarOrientation.bottom,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScroll,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Lab Tests
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentLabTestsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentLabTestsStorage(), key: null,),
                                                ),
                                              ));
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(43, 162, 164, 1.0),
                                                            Color.fromRGBO(0, 121, 107, 1.0)
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
                                                  width: 110,
                                                  height: 30.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(0, 121, 107, 1.0),
                                                          Color.fromRGBO(0, 121, 107, 1.0)
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    LabTestsTitle[LanguageData],
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
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

                                      // Symptoms
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentSymptomsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentSymptomsStorage(), key: null,),
                                                ),
                                              ));
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
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
                                                  width: 110,
                                                  height: 30.0,
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
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Vaccinations
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentVaccinationsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentVaccinationsStorage(), key: null,),
                                                ),
                                              ));
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
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
                                                  width: 110,
                                                  height: 30.0,
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
                                                    VaccinationsTitle[LanguageData],
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
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

                                    ]
                                ),
                              ),
                            ),
                            // Home Tabs




                          ),

                          Container(
                            child: Scrollbar(
                              isAlwaysShown: false,
                              thickness: 2.0,
                              //scrollbarOrientation: ScrollbarOrientation.bottom,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScroll,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Ai Analysis
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentAiAnalysisHomePage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),DependentAnalysisTutorialStatus: DependentAnalysisTutorialStorage()),
                                                ),
                                              ));
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
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
                                                    'assets/svg/aianalysis.svg',
                                                    width: 50,
                                                    height: 50,
                                                    alignment: AlignmentDirectional.center,
                                                    //color: Colors.white,
                                                    allowDrawingOutsideViewBox: true,
                                                    // fit: BoxFit.cover,
                                                  ),

                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(edge * .2),bottomRight: Radius.circular(edge * .2),),
                                                child:  Container(
                                                  width: 110,
                                                  height: 30.0,
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
                                                    AIAnalysisTitle[LanguageData],
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
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

                                      // Reports
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentReportsHomePage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),ReportsHomeStorage: DependentReportsHomeStorage(),)
                                              ),),
                                          );
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(43, 162, 164, 1.0),
                                                            Color.fromRGBO(0, 121, 107, 1.0)
                                                          ]
                                                      )
                                                  ),
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
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(edge * .2),bottomRight: Radius.circular(edge * .2),),
                                                child:  Container(
                                                  width: 110,
                                                  height: 30.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(0, 121, 107, 1.0),
                                                          Color.fromRGBO(0, 121, 107, 1.0)
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    ReportsTitle[LanguageData],
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Allergies
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentAllergiesPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentAllergiesStorage(), key: null,),
                                                ),
                                              ));
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(43, 162, 164, 1.0),
                                                            Color.fromRGBO(0, 121, 107, 1.0)
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
                                                  width: 110,
                                                  height: 30.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(0, 121, 107, 1.0),
                                                          Color.fromRGBO(0, 121, 107, 1.0)
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    AllergiesTitle[LanguageData],
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
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
                                    ]
                                ),
                              ),
                            ),
                            // Home Tabs




                          ),

                          Container(
                            child: Scrollbar(
                              isAlwaysShown: false,
                              thickness: 2.0,
                              //scrollbarOrientation: ScrollbarOrientation.bottom,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScroll,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Family Member Info
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentInfo(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentInfoStorage()),
                                                ),
                                              ));
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
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
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    radius: 40,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      child:DataImage != "No Data" && DataImage != "" && DataImage != null
                                                          ? Image.file(
                                                        File(DataImage),
                                                        fit: BoxFit.cover,
                                                        height: 80.0,
                                                        width: 80.0,
                                                      )
                                                          :SvgPicture.asset(
                                                        'assets/svg/dependents.svg',
                                                        width: 50,
                                                        height: 50,
                                                        alignment: AlignmentDirectional.center,
                                                        //color: Colors.white,
                                                        allowDrawingOutsideViewBox: true,
                                                        // fit: BoxFit.cover,
                                                      ),

                                                    ),
                                                  ),

                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(edge * .2),bottomRight: Radius.circular(edge * .2),),
                                                child:  Container(
                                                  width: 110,
                                                  height: 30.0,
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
                                                    DependentInfoTitle[LanguageData],
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
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

                                      // Doctors
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentDoctorsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentDoctorsStorage(), key: null,),
                                                ),
                                              ));
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(43, 162, 164, 1.0),
                                                            Color.fromRGBO(0, 121, 107, 1.0)
                                                          ]
                                                      )
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/doctors.svg',
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
                                                  width: 110,
                                                  height: 30.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(0, 121, 107, 1.0),
                                                          Color.fromRGBO(0, 121, 107, 1.0)
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    DoctorsTitle[LanguageData],
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Appointments
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Directionality( // use this
                                                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                  child: DependentAppointmentsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentAppointmentsStorage(), key: null,),
                                                ),
                                              ));
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5.0,
                                          margin: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(edge * .2),topRight: Radius.circular(edge * .2),),
                                                child: Container(
                                                  width: 110,
                                                  height: 95,
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: <Color>[
                                                            Color.fromRGBO(43, 162, 164, 1.0),
                                                            Color.fromRGBO(0, 121, 107, 1.0)
                                                          ]
                                                      )
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/appointments.svg',
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
                                                  width: 110,
                                                  height: 30.0,
                                                  // padding: const EdgeInsets.all(5.0),
                                                  decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: <Color>[
                                                          Color.fromRGBO(0, 121, 107, 1.0),
                                                          Color.fromRGBO(0, 121, 107, 1.0)
                                                        ]
                                                    ),
                                                  ),
                                                  child: Text(
                                                    AppointmentsTitle[LanguageData],
                                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
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
                                    ]
                                ),
                              ),
                            ),
                            // Home Tabs




                          ),

                  ],
                ),

              ),


          )
              ),

        ],
      ),
    ),
    );
  }

}






class DependentHomeStorage
{

// Find the Documents path
  Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<String> createDependentFolder(String DirName) async {
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
  Future<String> _readData(String DirName, String Filename) async {
    //final DepndentFolderPath =  await createDependentFolder(DirName);
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
  Future<void> _writeData(String Data, String Filename) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/'+Filename+'.txt');
// If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString(Data);
  }



  Future<String> createDependentsFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/Dependents');
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
  Future<String> _readDependentsData(String Filename) async {
    final dirPath =  await createDependentsFolder();
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


  Future<String> createEmergencyContactsFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/EmergencyContacts');
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
  Future<String> _readEmergencyContactsData(String Filename) async {
    final dirPath =  await createEmergencyContactsFolder();
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







