import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Pages/AiAnalysisHome.dart';
import 'package:icare/Pages/Allergies.dart';
import 'package:icare/Pages/Appointments.dart';
import 'package:icare/Pages/Doctors.dart';
import 'package:icare/Pages/EmergencyContacts.dart';
import 'package:icare/Pages/LabTests.dart';
import 'package:icare/Pages/Prescriptions.dart';
import 'package:icare/Pages/Scans.dart';
import 'package:icare/Pages/Symptoms.dart';
import 'package:icare/Pages/Vaccinations.dart';
import 'package:icare/Pages/VitalSigns.dart';
import 'package:icare/Pages/add_dependents.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Pages/DeleteItemList.dart';
import 'Pages/Dependent/DependentPages/DependentHomePage.dart';
import 'Pages/Dependents.dart';
import 'Pages/ReportsHome.dart';
import 'Pages/add_emergency_contact.dart';
import 'Settings.dart';
import 'ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'ICare';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.teal),
    home: HomePage(storage: HomeStorage(),Location: GetLocation(), key: null,),
  );
}

class HomePage extends StatefulWidget {
  final HomeStorage storage;
  final GetLocation Location;
  HomePage({Key? key, required this.storage, required this.Location}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {

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
  var LanguageData =0;
  var DrivePermission = "false";

  var HomeTitle = ["Home","الرئيسية",""];
  var VitalSignsTitle = ["Vital Signs","العلامات الحيوية",""];
  var DependentInfoTitle = ["Family Member","فرد الأسرة",""];
  var DependentHintTitle = ["Click to Enter Family Member's Home","انقر للدخول إلى الصفحة الرئيسية لأفراد العائلة",""];
  var DependentHintToolTip = ["Click on View Icon or Name to Enter Family Member's Home to Edit ,Save Medical Information and Start Tracking and AI Health Analysis","انقر فوق رمز العرض أو الاسم  للدخول إلى الصفحة الرئيسية لأحد أفراد العائلة لتحرير المعلومات الطبية وحفظها وبدء تتبع وتحليل حالته الصحية باستخدام الذكاء الاصطناعي ",""];
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
  var DependentsHomeTitle = ["Family Members","أفراد الأسرة",""];
  var AddNewTitle = ["+ Add new","+ اضافة",""];
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
  var SosMessageTextPart3 = [ "\n\nProvided by ICare,(https://play.google.com/store/apps/details?id=com.icareapp.medical.icare)","\n"+" مقدم من ICare  ، (https://play.google.com/store/apps/details?id=com.icareapp.medical.icaregoogle play)",""];
  var YesBtnTitle = ["Yes","نعم",""];
  var NoBtnTitle = ["No","لا",""];

  // TODO: Add _bannerAd
  BannerAd? _bannerAd;

  final _fcm = FirebaseMessaging.instance;

  initialMessage() async{
    var message = await FirebaseMessaging.instance.getInitialMessage();
    if(message != null) {
      String Navigator_Route = message.notification!.title.toString();
      if (Navigator_Route == "ICare AI Analysis") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: AiAnalysisHomePage(
                        AnalysisTutorialStatus: AnalysisTutorialStorage()),
                  ),
            ));
      }
      else if (Navigator_Route == "ICare Prescriptions") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: PrescriptionsPage(
                      storage: PrescriptionsStorage(), key: null,),
                  ),
            ));
      }
      else if (Navigator_Route == "ICare Reports") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: ReportsHomePage(
                      ReportsTutorialStatus: ReportsTutorialStorage(),)
                ),),
        );
      }
      else if (Navigator_Route == "ICare Scans") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: ScansPage(storage: ScansStorage(), key: null,),
                  ),
            ));
      }
      else if (Navigator_Route == "ICare Vital Signs") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Directionality( // use this
                      textDirection: LanguageData == 1
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: VitalSignsPage(storage: VitalSignsStorage(),)
                  ),
            ));
      }
      else if (Navigator_Route == "ICare Family Members") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: DependentsPage(
                      storage: DependentsStorage(), key: null,)
                ),),
        );
      }
      else if (Navigator_Route == "ICare Lab Tests") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: LabTestsPage(storage: LabTestsStorage(), key: null,),
                  ),
            ));
      }
      else if (Navigator_Route == "ICare Appointments") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: AppointmentsPage(
                      storage: AppointmentsStorage(), key: null,),
                  ),
            ));
      }
      else if (Navigator_Route == "ICare Vaccinations") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: VaccinationsPage(
                      storage: VaccinationsStorage(), key: null,),
                  ),
            ));
      }
      else if (Navigator_Route == "ICare Allergies") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: AllergiesPage(
                      storage: AllergiesStorage(), key: null,),
                  ),
            ));
      }
      else if (Navigator_Route == "ICare Symptoms") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: SymptomsPage(storage: SymptomsStorage(), key: null,),
                  ),
            ));
      }
      else if (Navigator_Route == "ICare Doctors") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: DoctorsPage(storage: DoctorsStorage(), key: null,),
                  ),
            ));
      }
      else if (Navigator_Route == "ICare Emergency Contacts") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: EmergencyContactsPage(
                      storage: EmergencyContactsStorage(), key: null,),
                  ),
            ));
      }
      else if (Navigator_Route == "ICare Invitation" ||
          Navigator_Route == "ICare Medical Data Backup" ||
          Navigator_Route == "ICare Feedback") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: SettingsPage(storage: SettingsStorage(), key: null,)
                ),),
        );
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Directionality( // use this
                    textDirection: LanguageData == 1
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: HomePage(storage: HomeStorage(),
                      Location: GetLocation(),
                      key: null,)
                ),),
        );
      }
    }
  }


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

    widget.storage._readSettingsData("icare_Drive_Permission").then((String value) async{
      if(value != "No Data" && value != "")
      {

        setState(() {
          DrivePermission = value.toString();
        });

      }
      else
      {
        setState(() {
          DrivePermission = "false";
        });
      }

    });

    widget.storage._readData("icare_username").then((String value) async{
        if(value != "No Data" && value != "")
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

    widget.storage._readData("icare_picture").then((String value) async{
      if(value != "No Data" && value != "")
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
      if(value != "No Data" && value != "")
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
      if(value != "No Data" && value != "" && value != "")
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
          ImageList = "";
        });
      }

    });

    widget.storage._readEmergencyContactsData("icare_EmergencyContacts").then((String value) async{
      if(value != "No Data" && value != "")
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

    widget.Location.LocatePosition().then((Position value) async {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
    });

    widget.storage._readData("icare_pictype").then((String value) async{
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

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    initialMessage();

    _fcm.getToken().then((token) {
      print("===========================Token============================");
      print(token);
      print("=======================================================");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if(message != null)
      {

        String Navigator_Route =  message.notification!.title.toString();
        if(Navigator_Route == "ICare AI Analysis")
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: AiAnalysisHomePage(AnalysisTutorialStatus: AnalysisTutorialStorage()),
                ),
              ));
        }
        else if(  Navigator_Route == "ICare Prescriptions")
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: PrescriptionsPage(storage: PrescriptionsStorage(), key: null,),
                ),
              ));
        }
        else if(  Navigator_Route == "ICare Reports")
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: ReportsHomePage(ReportsTutorialStatus: ReportsTutorialStorage(),)
              ),),
          );
        }
        else if(  Navigator_Route == "ICare Scans")
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: ScansPage(storage: ScansStorage(), key: null,),
                ),
              ));
        }
        else if(  Navigator_Route == "ICare Vital Signs")
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                    child: VitalSignsPage(storage: VitalSignsStorage(),)
                ),
              ));
        }
        else if(  Navigator_Route == "ICare Family Members")
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: DependentsPage(storage: DependentsStorage(), key: null,)
              ),),
          );
        }
        else if(  Navigator_Route == "ICare Lab Tests")
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: LabTestsPage(storage: LabTestsStorage(), key: null,),
                ),
              ));
        }
        else if(  Navigator_Route == "ICare Appointments")
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: AppointmentsPage(storage: AppointmentsStorage(), key: null,),
                ),
              ));
        }
        else if(  Navigator_Route == "ICare Vaccinations")
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: VaccinationsPage(storage: VaccinationsStorage(), key: null,),
                ),
              ));
        }
        else if(  Navigator_Route == "ICare Allergies")
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: AllergiesPage(storage: AllergiesStorage(), key: null,),
                ),
              ));
        }
        else if(  Navigator_Route == "ICare Symptoms")
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: SymptomsPage(storage: SymptomsStorage(), key: null,),
                ),
              ));
        }
        else if(  Navigator_Route == "ICare Doctors")
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: DoctorsPage(storage: DoctorsStorage(), key: null,),
                ),
              ));
        }
        else if(  Navigator_Route == "ICare Emergency Contacts")
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: EmergencyContactsPage(storage: EmergencyContactsStorage(), key: null,),
                ),
              ));
        }
        else if(  Navigator_Route == "ICare Invitation" || Navigator_Route == "ICare Medical Data Backup" || Navigator_Route == "ICare Feedback")
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: SettingsPage(storage: SettingsStorage(), key: null,)
              ),),
          );
        }
        else
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: HomePage(storage: HomeStorage(),Location: GetLocation(), key: null,)
              ),),
          );
        }

      }

    });



    // FirebaseMessaging.onMessage.listen((event) {
    //   print("===========================Notofication============================");
    //   AwesomeDialog();
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => Directionality( // use this
    //             textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
    //             child: VitalSignsPage(storage: VitalSignsStorage(),)
    //         ),
    //       ));
    // });

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
      drawer: MainMenu(storage: MainMenuStorage()),
      appBar: AppBar(
        title: const Text(MyApp.title,
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
        child: Stack(
          alignment: Alignment.topCenter,
          children: [

            // User Photo
            CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 40,
          child: ImageType == "Network"
              ?ClipRRect(
            child:ImageData != "No Data"
                ? Image.network(ImageData,
              fit: BoxFit.cover,
              height: 80.0,
              width: 80.0,
            )
                :Image.asset('assets/img/account96.png'),
            borderRadius: BorderRadius.circular(40.0),

          )
              :ClipRRect(
            child:ImageData != "No Data"
                ? Image.file(
              File(ImageData),
              fit: BoxFit.cover,
              height: 80.0,
              width: 80.0,
            )
                :Image.asset('assets/img/account96.png'),
            borderRadius: BorderRadius.circular(40.0),

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
                Data != null
                    ? Text(Data.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    :const Text("UserName",
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
                isAlwaysShown: true,
                  thickness: 2.0,
                  //scrollbarOrientation: ScrollbarOrientation.bottom,
                  controller: horizontalScroll,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    scrollDirection: Axis.horizontal,
                    controller: horizontalScroll,
                    child: Row(
                      children: [

                        // Vital Signs
                        GestureDetector(
                        onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => Directionality( // use this
                      textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                      child: VitalSignsPage(storage: VitalSignsStorage(),)
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
                                      child: PrescriptionsPage(storage: PrescriptionsStorage(), key: null,),
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

                                // Ai Analysis
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Directionality( // use this
                                      textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                      child: AiAnalysisHomePage(AnalysisTutorialStatus: AnalysisTutorialStorage()),
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

                                // Lab Tests
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Directionality( // use this
                                      textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                      child: LabTestsPage(storage: LabTestsStorage(), key: null,),
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

                                // Scans
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Directionality( // use this
                                      textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                      child: ScansPage(storage: ScansStorage(), key: null,),
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

                                // Appointments
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Directionality( // use this
                                      textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                      child: AppointmentsPage(storage: AppointmentsStorage(), key: null,),
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

                                // Vaccinations
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Directionality( // use this
                                      textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                      child: VaccinationsPage(storage: VaccinationsStorage(), key: null,),
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

                                // Allergies
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Directionality( // use this
                                      textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                      child: AllergiesPage(storage: AllergiesStorage(), key: null,),
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

                                // Symptoms
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Directionality( // use this
                                      textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                      child: SymptomsPage(storage: SymptomsStorage(), key: null,),
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
                                      child: DoctorsPage(storage: DoctorsStorage(), key: null,),
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

                                // Emergency Contacts
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Directionality( // use this
                                      textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                      child: EmergencyContactsPage(storage: EmergencyContactsStorage(), key: null,),
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
                                            'assets/svg/emergency.svg',
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
                                            EmergencyContactsTitle[LanguageData],
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
                                      child: ReportsHomePage(ReportsTutorialStatus: ReportsTutorialStorage(),)
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

                      ],
                    ),

                  ),


              ),
            ),

            // Dependents Title and Add New
            Card(
              color: const Color.fromRGBO(32, 116, 150, 1.0),
              shadowColor: Colors.grey,
              elevation: 4.0,
              margin: const EdgeInsets.only(top:330.0,left:0.0,bottom:10.0,right:0.0),
              child: ListTile(
                title:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const SizedBox(width: 5.0),
                    Expanded(
                      // optional flex property if flex is 1 because the default flex is 1
                      flex: 2,
                      child:  Text(DependentsHomeTitle[LanguageData],
                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.white,
                          // Color.fromRGBO(248, 95, 106, 1.0),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          //decoration: TextDecoration.underline,
                        ),
                      ) ,
                    ),
                    const SizedBox(width: 10.0),
                    // Profile Picture
                    Expanded(
                      // optional flex property if flex is 1 because the default flex is 1
                      flex: 1,
                      child:  Text(AddNewTitle[LanguageData],
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.white,
                          // Color.fromRGBO(248, 95, 106, 1.0),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          //decoration: TextDecoration.underline,
                        ),
                      ) ,
                    ),
                    const SizedBox(width: 5.0),
                  ],
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Directionality( // use this
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            child: DependentsPage(storage: DependentsStorage(), key: null,)
                        ),),
                  );
                },
              ),

            ),

            Container(
              margin: const EdgeInsets.only(top:390.0),
              padding: const EdgeInsets.only(top: 0.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.white,
                      Colors.white,
                    ]
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(0, 2), // Shadow position
                  ),
                ],
              ),
              child: ListTile(
                  title:Text(DependentHintTitle[LanguageData],
                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.teal,
                      // Color.fromRGBO(248, 95, 106, 1.0),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      //decoration: TextDecoration.underline,
                    ),
                  ) ,
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: DependentHintToolTip[LanguageData],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.teal,
                        textColor: Colors.white,
                        fontSize: 14.0);
                  },


              ),
            ),

            // Dependents
            Container(
              margin: const EdgeInsets.only(top:440.0),
              padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
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

              child: DepenData != null && ImageList != null
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return DataListViewWidget(
                    DataTitle: DepenData[index][0],
                    DataSubTitle: DepenData[index][1], key: null,
                    imageURL: ImageList!="" ? ImageList[index][0] : "",
                    DataIndex: index,
                    DataLines: DataLines,
                    LanguageData: LanguageData,
                  );
                },
                itemCount: DepenData.length,
              )
                  :Card(
                color: Colors.white,
                shadowColor: Colors.grey,
                elevation: 4.0,
                margin: const EdgeInsets.only(top:10.0,left:10.0,bottom:20.0,right:10.0),
                child: ListTile(
                  title:Text(NoDependentsHomeTitle[LanguageData],
                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color.fromRGBO(248, 95, 106, 1.0),
                      // Color.fromRGBO(248, 95, 106, 1.0),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      //decoration: TextDecoration.underline,
                    ),
                  ) ,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Directionality( // use this
                              textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                              child: AddDependents(storage: AddDependentsStorage(),)
                          ),),
                    );
                  },
                ),

              ),

            ),

// TODO: Display a banner when ready
            if (_bannerAd != null)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),

          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (_) {
                if(EmergencyData != null)
                  {
                    return AlertDialog(
                      titleTextStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 16,
                        fontWeight: FontWeight.w500,),
                      title: Text(SosPopupTitle[LanguageData],
                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,),
                      actions: [
                        TextButton(
                          onPressed: () async => await launch(
                              "https://api.whatsapp.com/send?phone="+ EmergencyData[0][2]+"&text="+ SosMessage),
                          // '\n https://www.google.com/maps/search/?api=1&query=${currentMArker.position.latitude},${currentMArker.position.longitude}'),
                          child: Text(YesBtnTitle[LanguageData],
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            style: const TextStyle(color: Colors.teal,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, false), // passing false
                          child: Text(NoBtnTitle[LanguageData],
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            style: const TextStyle(color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                else
                  {
                    return AlertDialog(
                      titleTextStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontSize: 16,
                        fontWeight: FontWeight.w500,),
                      title: Text(SosNoContactTitle[LanguageData],
                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Directionality( // use this
                                      textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                      child: AddEmergencyContacts(storage: AddEmergencyContactsStorage(),)
                                  ),),
                            );
                          },
                          child: Text(YesBtnTitle[LanguageData],
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            style: const TextStyle(color: Colors.teal,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, false), // passing false
                          child: Text(NoBtnTitle[LanguageData],
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            style: const TextStyle(color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

              }).then((exit) {
            if (exit == null) return;

            if (exit) {
              // user pressed Yes button
            } else {
              // user pressed No button
            }
          });

        },

        elevation: 5,
        backgroundColor: Colors.teal,
        tooltip: "Sos Message",
        focusColor:  const Color.fromRGBO(47, 150, 185, 1),
        splashColor: const Color.fromRGBO(47, 150, 185, 1),
        hoverColor: const Color.fromRGBO(47, 150, 185, 1),
        //child: const Icon(Icons.emergency),
        child: SvgPicture.asset(
          'assets/svg/sos.svg',
          width: 30,
          height: 30,
          alignment: AlignmentDirectional.center,
          color: Colors.white,
          allowDrawingOutsideViewBox: false,
          // fit: BoxFit.cover,
        ),
      ),
    );
  }

}






class HomeStorage
{

// Find the Documents path
  Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
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



class DataListViewWidget extends StatelessWidget {
  final String DataTitle;
  final String DataSubTitle;
  final String imageURL;
  final int DataIndex;
  final List DataLines;
  final int LanguageData;

  // const DataListViewWidget({required Key key, required this.DataTitle, required this.DataSubTitle, required this.imageURL}) : super(key: key);
  const DataListViewWidget({required Key? key, required this.DataTitle, required this.DataSubTitle,required this.DataIndex, required this.DataLines, required this.imageURL, required this.LanguageData}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:5.0,left:10.0,bottom:5.0,right:10.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.white,
              Colors.white,
            ]
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            offset: Offset(0, 0), // Shadow position
          ),
        ],
      ),
      child: ListTile(
        leading: FittedBox(
          fit: BoxFit.fill,
          child: Row(
            children: [
              GestureDetector(
                  child: const Icon(
                    Icons.manage_search,color:Color.fromRGBO(32, 116, 150, 1.0),size: 30.0,
                  ),
                  onTap: () async {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder:
                            (context) =>
                            Directionality( // use this
                                textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                child:  DependentHomePage(storage: DependentHomeStorage(),DirName: "Dependent"+DataIndex.toString(), FileName: 'icare_Dependents', DataIndex: DataIndex, DataTitle: DataTitle, DependentDataLines: DataLines, DataImage: imageURL)

                            ),
                        )
                    );

                  }
              ),
              const SizedBox(width: 10),
              imageURL!=""
                  ?ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 64,
                  maxHeight: 64,
                ),
                child: Image.file(
                  File(imageURL),
                  width: 50,
                  height: 50,
                  alignment: AlignmentDirectional.center,
                ),
              )
                  :ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 64,
                  maxHeight: 64,
                ),
                child: SvgPicture.asset(
                  'assets/svg/dependents.svg',
                  width: 50,
                  height: 50,
                  alignment: AlignmentDirectional.center,
                  // color: Colors.white,
                  allowDrawingOutsideViewBox: false,
                ),
              ),
            ],
          ),
        ),
        title:GestureDetector(
            child: Text(DataTitle,
                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),fontWeight: FontWeight.bold)),
            onTap: (){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:
                      (context) =>
                      Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child:  DependentHomePage(storage: DependentHomeStorage(),DirName: "Dependent"+DataIndex.toString(), FileName: 'icare_Dependents', DataIndex: DataIndex, DataTitle: DataTitle, DependentDataLines: DataLines, DataImage: imageURL)

                      ),
                  )
              );
            }
        ),
        subtitle: Text(DataSubTitle),
        trailing: FittedBox(
          fit: BoxFit.fill,
          child: Column(
            children: [
              GestureDetector(
                  child: const Icon(
                    Icons.share,color:Colors.teal,size: 30.0,
                  ),
                  onTap: () async {
                    Share.share("Dependent\nDate:"+DataTitle+"\n"+"Details:"+DataSubTitle+"\n"+"\n\nProvided by ICare,(https://play.google.com/store/apps/details?id=com.icareapp.medical.icare)");
                  }
              ),
              const SizedBox(height: 5),
              // GestureDetector(
              //     child: const Icon(
              //       Icons.edit,color: Color.fromRGBO(32, 116, 150, 1.0),size: 30.0,
              //     ),
              //     onTap: (){
              //       Navigator.pushReplacement(context,
              //           MaterialPageRoute(builder:
              //               (context) =>
              //                   Directionality( // use this
              //                       textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
              //                       child:  DependentHomePage(storage: DependentHomeStorage(),DirName: "Dependent"+DataIndex.toString(), FileName: 'icare_Dependents', DataIndex: DataIndex, DataTitle: DataTitle, DependentDataLines: DataLines, DataImage: imageURL)
              //
              //                   ),
              //           )
              //       );
              //     }
              // ),
              // const SizedBox(height: 5),
              GestureDetector(
                  child: const Icon(
                    Icons.delete_forever,color: Colors.redAccent,size: 30.0,
                  ),
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder:
                            (context) =>
                                Directionality( // use this
                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                    child: DeleteItemListPage(DirName: 'Dependents', FileName: 'icare_Dependents', DataIndex: DataIndex, DataTitle: DataSubTitle, DataLines: DataLines, DataImage: "dependents")
                                ),
                        )
                    );
                  }
              ),
              // Icon(Icons.share,color: Color.fromRGBO(32, 116, 150, 1.0),),
              // SizedBox(height: 15),
              // Icon(Icons.edit,color: Colors.teal,)
            ],
          ),
        ),
      ),
    );
  }
}



class GetLocation
{
Future<Position> LocatePosition() async
{
  var status = await Permission.accessMediaLocation.status;
  if (!status.isGranted) {
    await Permission.accessMediaLocation.request();
  }
  Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  LatLng LatLngPosition = LatLng(currentPosition.latitude,currentPosition.longitude);

  return currentPosition;
 }
}