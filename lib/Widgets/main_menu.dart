import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/HomePage.dart';
import 'package:icare/Pages/AiAnalysisHome.dart';
import 'package:icare/Pages/Allergies.dart';
import 'package:icare/Pages/Appointments.dart';
import 'package:icare/Pages/Dependents.dart';
import 'package:icare/Pages/Doctors.dart';
import 'package:icare/Pages/EmergencyContacts.dart';
import 'package:icare/Pages/LabTests.dart';
import 'package:icare/Pages/Prescriptions.dart';
import 'package:icare/Pages/Scans.dart';
import 'package:icare/Pages/Vaccinations.dart';
import 'package:icare/Pages/add_allergies.dart';
import 'package:icare/Pages/add_labtests.dart';
import 'package:icare/Pages/add_prescriptions.dart';
import 'package:icare/Pages/add_symptoms.dart';
import 'package:icare/Pages/Symptoms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../AccountInfo.dart';
import '../Login.dart';
import '../Pages/ReportsHome.dart';
import '../Pages/VitalSigns.dart';
import '../Pages/add_scans.dart';
import '../Settings.dart';



class MainMenu extends StatefulWidget {
  final MainMenuStorage storage;

  MainMenu({Key? key, required this.storage}) : super(key: key);
  @override
  MainMenuState createState() => MainMenuState();
}


class MainMenuState extends State<MainMenu> {

  var UsernameData = "No Data";
  var ImageData = "No Data";
  var EmailData = "No Data";
  var ImageType = "Local";
  var LanguageData =0;

  var HomeTitle = ["Home","الرئيسية",""];
  var VitalSignsTitle = ["Vital Signs","العلامات الحيوية",""];
  var DependentsTitle = ["Fammily Members","أفراد الأسرة",""];
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


  @override
  void initState()
  {
    widget.storage._readData("icare_username").then((String value) async{
      if(value != "No Data" && value != "")
      {
        setState(() {
          UsernameData = value;
        });

      }
      else
      {
        setState(() {
          UsernameData = "No Data";
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

    widget.storage._readData("icare_email").then((String value) async{
      if(value != "No Data" && value != "")
      {
        setState(() {
          EmailData = value;
        });

      }
      else
      {
        setState(() {
          EmailData = "No Data";
        });
      }

    });

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

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
           DrawerHeader(
              padding: const EdgeInsets.only(top: 40.0),
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/drawer.png"),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:  Radius.circular(20)),
    ),
              child: Stack(
          alignment: Alignment.topCenter,
          children: [

            // User Photo
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: ImageType == "Network"
                    ?Container(
                  height: 80,
                  width: 80,
                  color: Colors.transparent,
                  child:
                  ImageData != "No Data"
                      ? Image.network(ImageData
                  )
                      :SvgPicture.asset(
                    'assets/svg/profile.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
                )
                    :Container(
                  height: 80,
                  width: 80,
                  color: Colors.transparent,
                  child:
                  ImageData != "No Data"
                      ? Image.file(
                    File(ImageData),
                  )
                      :SvgPicture.asset(
                    'assets/svg/profile.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
                ),
              ),
            ),

            // User Name
            Container(
              padding: const EdgeInsets.only(top: 70.0),
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
                  child:GestureDetector(
                      child: UsernameData!= "No Data"
                          ?Text(UsernameData.toString(),style: const TextStyle(color: Colors.white),)
                          :const Text("User Name",),
                      onTap: (){
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder:
                                (context) =>
                                    Directionality( // use this
                                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                        child: AccountInfoPage(storage: ProfileInfoStorage(),)
                                    ),
                            )
                        );
                      }
                  ),
                ),
              ),

            ),
          ],
        ),
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(HomeTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                constraints:
                const BoxConstraints(minWidth: 100, minHeight: 30),
                child: SvgPicture.asset(
                  'assets/svg/home.svg',
                  width: 20,
                  height: 20,
                  alignment: AlignmentDirectional.center,
                  // color: Colors.white,
                  allowDrawingOutsideViewBox: false,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: HomePage(storage: HomeStorage(),Location: GetLocation(), key: null,)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(VitalSignsTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/vitals.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: VitalSignsPage(storage: VitalSignsStorage(),)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(DependentsTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/dependents.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
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
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(PrescriptionsTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/prescriptions.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: PrescriptionsPage(storage: PrescriptionsStorage(), key: null,)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(LabTestsTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/labtests.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: LabTestsPage(storage: LabTestsStorage(), key: null,)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(ScansTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: const Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/scans.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: ScansPage(storage: ScansStorage(), key: null,)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(AppointmentsTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/appointments.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: AppointmentsPage(storage: AppointmentsStorage(), key: null,)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(VaccinationsTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: const Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/vaccinations.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: VaccinationsPage(storage: VaccinationsStorage(), key: null,)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(AllergiesTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/allergies.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: AllergiesPage(storage: AllergiesStorage(), key: null,)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(SymptomsTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/symptoms.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: SymptomsPage(storage: SymptomsStorage(), key: null,)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(DoctorsTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: const Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                'assets/svg/doctors.svg',
                width: 20,
                height: 20,
                alignment: AlignmentDirectional.center,
                // color: Colors.white,
                allowDrawingOutsideViewBox: false,
              ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: DoctorsPage(storage: DoctorsStorage(), key: null,)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(EmergencyContactsTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/emergency.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: EmergencyContactsPage(storage: EmergencyContactsStorage(), key: null,)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(ReportsTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: const Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/reports.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
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
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(AIAnalysisTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/aianalysis.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                        child: AiAnalysisHomePage(AnalysisTutorialStatus: AnalysisTutorialStorage())
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(AccountTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: const Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/account.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                        child: AccountInfoPage(storage: ProfileInfoStorage(), key: null,),
                      ),
                  ),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(SettingsTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/settings.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: SettingsPage(storage: SettingsStorage(), key: null,)
                      ),),
                );
              },
            ),
           ListTile(
              contentPadding:EdgeInsets.zero ,
              title: Text(LogoutTitle[LanguageData],
                  style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(32, 116, 150, 1.0),)
              ),
              leading: ConstrainedBox(
                  constraints:
                  const BoxConstraints(minWidth: 100, minHeight: 30),
                  child: SvgPicture.asset(
                    'assets/svg/logout.svg',
                    width: 20,
                    height: 20,
                    alignment: AlignmentDirectional.center,
                    // color: Colors.white,
                    allowDrawingOutsideViewBox: false,
                  ),
              ),
              onTap: () {
                widget.storage._signOut();
                widget.storage.deleteFile("icare_fullname");
                widget.storage.deleteFile("icare_username");
                widget.storage.deleteFile("icare_age");
                widget.storage.deleteFile("icare_email");
                widget.storage.deleteFile("icare_picture");
                widget.storage.deleteDrivePermissionFile("icare_Drive_Permission");
                Fluttertoast.showToast(
                    msg: "Logged Out.......",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.teal,
                    textColor: Colors.white,
                    fontSize: 14.0);
                Future<void> deleteFile(File file) async {
                  try {
                    if (await file.exists()) {
                      await file.delete();
                    }
                  } catch (e) {
                    // Error in getting access to the file.
                  }
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Directionality( // use this
                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                          child: LoginPage(storage: LoginStorage()),
                      ),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }


}



class MainMenuStorage
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

  Future<void> deleteFile(String Filename) async {
    final dirPath =  await createFolder();
    final file = await File('$dirPath/'+Filename+'.txt');
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  Future<void> deleteDrivePermissionFile(String Filename) async {
    final dirPath =  await createSettingsFolder();
    final file = await File('$dirPath/'+Filename+'.txt');
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  final _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await _auth.signOut();
    // await _googleSignIn.signOut();
  }

}