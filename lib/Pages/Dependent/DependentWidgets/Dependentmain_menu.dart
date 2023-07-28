import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../HomePage.dart';
import '../DependentPages/DependentAiAnalysisHome.dart';
import '../DependentPages/DependentAllergies.dart';
import '../DependentPages/DependentAppointments.dart';
import '../DependentPages/DependentDoctors.dart';
import '../DependentPages/DependentHomePage.dart';
import '../DependentPages/DependentInfo.dart';
import '../DependentPages/DependentLabTests.dart';
import '../DependentPages/DependentPrescriptions.dart';
import '../DependentPages/DependentReportsHome.dart';
import '../DependentPages/DependentScans.dart';
import '../DependentPages/DependentSymptoms.dart';
import '../DependentPages/DependentVaccinations.dart';
import '../DependentPages/DependentVitalSigns.dart';





class DependentMainMenu extends StatefulWidget {
  final DependentMainMenuStorage storage;
  final String DirName;
  final String DataTitle;
  final String DataImage;

  DependentMainMenu({Key? key,required this.DataTitle, required this.DataImage,required this.DirName, required this.storage}) : super(key: key);
  @override
  DependentMainMenuState createState() => DependentMainMenuState(this.DataTitle, this.DataImage,this.DirName);
}


class DependentMainMenuState extends State<DependentMainMenu> {
  var DirName;
  var DataTitle;
  var DataImage;

  DependentMainMenuState(this.DataTitle, this.DataImage,this.DirName);

  var UsernameData = "No Data";
  var ImageData = "No Data";
  var EmailData = "No Data";
  var ImageType = "Local";
  var LanguageData =0;

  var HomeTitle = ["Your Home","صفحتك الرئيسية",""];
  var VitalSignsTitle = ["Family Member Vital Signs","العلامات الحيوية لفرد الأسرة",""];
  var DependentsTitle = ["Family Member Home","الصفحة الرئيسية لفرد الأسرة",""];
  var PrescriptionsTitle = ["Family Member Prescriptions","الوصفات الطبية لفرد الأسرة",""];
  var LabTestsTitle = ["Family Member Lab Tests","الفحوصات المعملية لفرد الأسرة",""];
  var ScansTitle = ["Family Member Scans","الأشعة لفرد الأسرة",""];
  var AppointmentsTitle = ["Family Member Appointments","المواعيد لفرد الأسرة",""];
  var VaccinationsTitle = ["Family Member Vaccinations","التطعيمات لفرد الأسرة",""];
  var AllergiesTitle = ["Family Member Allergies","الحساسية لفرد الأسرة",""];
  var SymptomsTitle = ["Family Member Symptoms","الأعراض لفرد الأسرة",""];
  var DoctorsTitle = ["Family Member Doctors","الأطباء لفرد الأسرة",""];
  var ReportsTitle = ["Family Member Reports","التقارير لفرد الأسرة",""];
  var AIAnalysisTitle = ["Family Member AI Analysis","تحليل الذكاء الاصطناعي لفرد الأسرة",""];
  var AccountTitle = ["Family Member Account","الحساب الشخصي لفرد الأسرة",""];



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
                child: DataImage != "No Data" && DataImage != "" && DataImage != null
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
                      child: DataTitle != null
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
                      onTap: (){
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder:
                                (context) =>
                                    Directionality( // use this
                                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                        child: DependentInfo(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentInfoStorage()),
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
                          child: HomePage(storage: HomeStorage(), key: null, Location: GetLocation(),)
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
                        child:  DependentHomePage(storage: DependentHomeStorage(),DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(), FileName: 'icare_Dependents', DataIndex: 0, DependentDataLines: [])

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
                          child: DependentVitalSignsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),)
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
                          child: DependentPrescriptionsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentPrescriptionsStorage(), key: null,)
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
                          child: DependentLabTestsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentLabTestsStorage(), key: null,)
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
                          child: DependentScansPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentScansStorage(), key: null,),
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
                          child: DependentAppointmentsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentAppointmentsStorage(), key: null,)
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
                          child: DependentVaccinationsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentVaccinationsStorage(), key: null,)
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
                          child: DependentAllergiesPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentAllergiesStorage(), key: null,)
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
                          child: DependentSymptomsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentSymptomsStorage(), key: null,)
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
                          child: DependentDoctorsPage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentDoctorsStorage(), key: null,)
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
                          child: DependentReportsHomePage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),ReportsHomeStorage: DependentReportsHomeStorage(),)
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
                        child: DependentAiAnalysisHomePage(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),DependentAnalysisTutorialStatus: DependentAnalysisTutorialStorage())
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
                        child: DependentInfo(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString(),storage: DependentInfoStorage()),
                      ),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }


}



class DependentMainMenuStorage
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

  final _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await _auth.signOut();
    // await _googleSignIn.signOut();
  }

}