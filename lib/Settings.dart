import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'AccountInfo.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Login.dart';
import 'RequestDrivePermissions.dart';
import 'TutorialPage.dart';
import 'Widgets/GoogleDrive.dart';

class SettingsPage extends StatefulWidget {
  final SettingsStorage storage;

  SettingsPage({Key? key, required this.storage}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage>  {

  final _auth = FirebaseAuth.instance;
  final DriveBackup = GoogleDrive();

  var EmailData = "No Data";
  var UsernameData = "No Data";
  var ImageData = "No Data";
  var NotificationsData = true,LanguageData =0;
  var LisData;
  var Data;
  var DataLines;
  final verticalScroll = ScrollController();
  TextEditingController MessageController = TextEditingController();
  String Message = "";

  var AppLang;
  bool showProgress = false;
  String? _content;
  XFile? _image = null;
  final picker = ImagePicker();
  var Lang = const ["En","Ar"];


  var PageTitle = ["Settings","الاعدادات",""];
  var AccountSettingsTitle = ["Account Settings","اعدادات الحساب",""];
  var GeneralSettingsTitle = ["General Settings","الاعدادات العامة",""];
  var NotificationsTitle = ["Notifications","الإشعارات",""];
  var LangTitle = ["Language","اللغة",""];
  var ClearCacheTitle = ["Clear Cache","مسح ذاكرة التخزين المؤقت",""];
  var DataBackupTilte = ["Data Backup","النسخ الاحتياطي للبيانات",""];
  var PrivacyPolicyTitle = ["Privacy Policy","سياسة الخصوصية",""];
  var OffTitle = ["Off","إيقاف",""];
  var OnTitle = ["On","تفعيل",""];
  var TutorialTitle = ["Tutorial","شرح التطبيق",""];
  var InviteTitle = ["Invite Friends","ادع أصدقائك",""];
  var ContactTitle = ["Contact Us","تواصل معنا",""];
  var LogoutTitle = ["Logout","تسجيل الخروج",""];
  var ShareMessageTitle = [" invited you to download and use ICare Medical Application.\n \nDownload Now and start tracking your family health and enjoy ICare AI Medical System.\nhttps://play.google.com/store/apps/details?id=com.icareapp.medical.icare","دعاك لتنزيل واستخدام تطبيق ICare الطبي.\n \n قم بالتنزيل الآن وابدأ في تتبع صحة عائلتك واستمتع بنظام ICare AI الطبي.https://play.google.com/store/apps/details?id=com.icareapp.medical.icare \n   ",""];
  var ContactFormTitle1 = ["Tell us your feedback","أخبرنا بتعليقاتك",""];
  var ContactFormTitle2 = ["We are delighted to get your message","نحن سعداء لتلقي رسالتك",""];
  var ContactFormTitle3 = ["Enter Message here","أدخل الرسالة هنا",""];
  var ContactFormTitle4 = ["Message","الرسالة",""];
  var ContactFormSubmit = ["Submit","ارسال",""];



  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState

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

    widget.storage._readSettingsData("icare_Notifications").then((String value) async{
      if(value != "No Data" && value != "")
      {
        bool NotStatus;
        if(value == "true") {
          NotStatus = true;
        } else {
          NotStatus = false;
        }

        setState(() {
          NotificationsData = NotStatus;
        });

      }
      else
      {
        setState(() {
          NotificationsData = true;
        });
      }

    });


    widget.storage._readSettingsData("icare_Language").then((String value) async{
      if(value != "No Data" && value != "")
      {

        setState(() {
          LanguageData = int.parse(value);
          AppLang = Lang[LanguageData];
        });

      }
      else
      {
        setState(() {
          LanguageData = 0;
          AppLang = Lang[LanguageData];
        });
      }

    });


    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    final Uri Privacyurl =
    Uri(scheme: 'https', host: 'drive.google.com', path: 'file/d/1ZI3A5NAHP4NJ3QYh6VjmloqTzp1EjtH6/view?usp=sharing');

    return Scaffold(
      //extendBodyBehindAppBar: true,
        drawer: MainMenu(storage: MainMenuStorage()),
        appBar: AppBar(
          title: Text(PageTitle[LanguageData],
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
                      'assets/svg/settings.svg',
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
                Container(
                  margin: const EdgeInsets.only(top:100.0),
                  padding: const EdgeInsets.only(top: 0.0,bottom: 20.0),
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
                  child: ListView(
                    children: [

                      // Dependents Title and Add New
                      Card(
                        color: const Color.fromRGBO(32, 116, 150, 1.0),
                        shadowColor: Colors.grey,
                        elevation: 4.0,
                        margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:10.0,right:0.0),
                        child: ListTile(
                          title:Text(AccountSettingsTitle[LanguageData],
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white,
                              // Color.fromRGBO(248, 95, 106, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              //decoration: TextDecoration.underline,
                            ),
                          ) ,
                        ),
                      ),

                      // First Dependent
                      Container(
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
                            leading: ImageType == "Network"
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
                            title: GestureDetector(
                                child: UsernameData!= "No Data"
                                    ?Text(UsernameData.toString(),
                                  style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),),)
                                    :const Text("User Name",
                                  style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),),),
                                onTap: (){
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder:
                                          (context) =>
                                      Directionality( // use this
                                          textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                          child: AccountInfoPage(storage: ProfileInfoStorage(),)
                                      )),
                                  );
                                }
                            ),
                            subtitle:GestureDetector(
                                child:  EmailData!= "No Data"
                                    ?Text(EmailData.toString())
                                    :const Text("User@icare.com"),
                                onTap: (){
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder:
                                          (context) =>
                                      Directionality( // use this
                                          textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                          child: AccountInfoPage(storage: ProfileInfoStorage(),)),
                                      )
                                  );
                                }
                            ),
                          )

                      ),

                      // Dependents Title and Add New
                      Card(
                        color: const Color.fromRGBO(32, 116, 150, 1.0),
                        shadowColor: Colors.grey,
                        elevation: 4.0,
                        margin: const EdgeInsets.only(top:20.0,left:0.0,bottom:10.0,right:0.0),
                        child: ListTile(
                          title:Text(GeneralSettingsTitle[LanguageData],
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white,
                              // Color.fromRGBO(248, 95, 106, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              //decoration: TextDecoration.underline,
                            ),
                          ) ,
                        ),
                      ),

                      // First Dependent
                      Container(
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
                          child:Center(
                            // CupertinoFormRow's main axis is set to max by default.
                            // Set the intrinsic height widget to center the CupertinoFormRow.
                            child: IntrinsicHeight(
                              child: Container(
                                child: CupertinoFormRow(
                                  prefix: Row(
                                    children: <Widget>[
                                      Text(NotificationsTitle[LanguageData],
                                        style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),),),
                                      const SizedBox(width: 10),
                                      Icon(
                                        // Wifi icon is updated based on switch value.
                                        NotificationsData ? Icons.notifications_active : Icons.notifications_none,
                                        color: NotificationsData
                                            ? Colors.teal
                                            : const Color(0xffdc6c73),
                                      ),
                                    ],
                                  ),
                                  child: CupertinoSwitch(
                                    // This bool value toggles the switch.
                                    value: NotificationsData,
                                    thumbColor: Colors.teal,
                                    trackColor: CupertinoColors.systemRed.withOpacity(0.14),
                                    activeColor: const Color(0xffe4e5eb),
                                    onChanged: (bool? value) {
                                      widget.storage._writeData(value.toString(), "icare_Notifications");
                                      setState(() {
                                        NotificationsData = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                      //     ListTile(
                      //       title: Text(NotificationsTitle[LanguageData],
                      //         style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),),),
                      //       trailing: SlidingSwitch(
                      //         value: NotificationsData,
                      //         width: 100,
                      //         onChanged: (bool value) {
                      //           widget.storage._writeData(value.toString(), "icare_Notifications");
                      //         },
                      //         height : 35,
                      //         // animationDuration : const Duration(milliseconds: 400),
                      //         onTap:(){},
                      //         contentSize: 17,
                      //         onDoubleTap:(){},
                      //         onSwipe:(){},
                      //         textOff : "Off",
                      //         textOn : "On",
                      //         colorOn : const Color(0xffdc6c73),
                      //         colorOff : const Color(0xff6682c0),
                      //         background : const Color(0xffe4e5eb),
                      //         buttonColor : const Color(0xfff7f5f7),
                      //         inactiveColor : const Color(0x2074968C),
                      //       ),
                      // ),
                      ),

                      // First Dependent
                      Container(
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
                          child:ListTile(
                            title: GestureDetector(
                              child: Text(DataBackupTilte[LanguageData],
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),),
                              ),
                              onTap: ()
                              {
                                //DriveBackup.getHttpClient();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                        Directionality( // use this
                                            textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                            child: RequestDrivePermissionsPage(storage: DrivePermisssionStorage(),)),

                                    )
                                );
                                Fluttertoast.showToast(
                                    msg: "Data Backup Started Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.teal,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              },
                            ),
                          )

                      ),



                      // Second Dependent
                      Container(
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
                            title: Text(LangTitle[LanguageData],
                              style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),),),
                            trailing: ToggleSwitch(
                              minWidth: 50,
                              activeBgColors: const [[Colors.teal], [Colors.teal],[Colors.teal]],
                              initialLabelIndex: LanguageData,
                              totalSwitches: 2,
                              labels: const ['En', 'Ar'],
                              onToggle: (index) {
                                widget.storage._writeData(index.toString(), "icare_Language");
                                setState(() {
                                  LanguageData = int.parse(index.toString());
                                  AppLang = Lang[int.parse(index.toString())];
                                });
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder:
                                        (context) =>
                                        Directionality( // use this
                                            textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                            child: SettingsPage(storage: SettingsStorage(),)),

                                    )
                                );
                              },
                            ),
                            ),
                      ),

                      // First Dependent
                      Container(
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
                          child:ListTile(
                            title: GestureDetector(
                              child:  Text(ClearCacheTitle[LanguageData],
                                style: const TextStyle(color: const Color.fromRGBO(32, 116, 150, 1.0),),
                              ),
                              onTap: ()
                              {
                                widget.storage.deleteFolder("AIAnalysis");
                                widget.storage.deleteFolder("Reports");
                                Fluttertoast.showToast(
                                    msg: "Cache Cleared Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.teal,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              },
                            ),
                          )

                      ),


                      // Second Dependent
                      Container(
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
                            title: GestureDetector(
                              child: Text(PrivacyPolicyTitle[LanguageData],
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),),
                              ),
                              onTap: ()
                              {
                                _launchInBrowser(Privacyurl);
                              },
                            ),
                          )

                      ),

                      // First Dependent
                      Container(
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
                            title: GestureDetector(
                              child: Text(TutorialTitle[LanguageData],
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),),
                              ),
                              onTap: ()
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Directionality( // use this
                                    textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                    child: TutorialPage(storage: TutorialStorage(), key: null,)),),
                                );
                              },
                            ),
                          )

                      ),

                      // First Dependent
                      Container(
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
                            title: GestureDetector(
                              child: Text(InviteTitle[LanguageData],
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),),
                              ),
                              onTap: ()
                              {
                                String ShareMessage = UsernameData.toString()+ ShareMessageTitle[LanguageData];

                                Share.share(ShareMessage);
                              },
                            ),
                          )

                      ),

                      // First Dependent
                      Container(
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
                            title: GestureDetector(
                              child: Text(ContactTitle[LanguageData],
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),),
                              ),
                              onTap:  ()
                               async{
                                showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          20.0,
                                        ),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                      top: 10.0,
                                    ),
                                    title: Text(
                                      ContactFormTitle1[LanguageData],
                                      style: TextStyle(fontSize: 24.0,color: const Color.fromRGBO(32, 116, 150, 1.0),),
                                    ),
                                    content: SizedBox(
                                      height: 200,
                                      child: SingleChildScrollView(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                ContactFormTitle2[LanguageData],textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
                                                keyboardType: TextInputType.multiline,
                                                controller: MessageController,
                                                onChanged: (value) {
                                                  Message = value;
                                                  //get value from textField
                                                },
                                                decoration: InputDecoration(
                                                    border: const OutlineInputBorder(),
                                                    hintText: ContactFormTitle3[LanguageData],
                                                    labelText: ContactFormTitle4[LanguageData],
                                                  prefixIcon: Icon(Icons.notes),
                                              ),
                                              style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                                fontSize: 16,
                                                //fontWeight: FontWeight.w500,
                                              ),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 60,
                                              padding: const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () async{
                                                  Fluttertoast.showToast(
                                                      msg: "Sending Feedback.......",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.teal,
                                                      textColor: Colors.white,
                                                      fontSize: 14.0);
                                                  launch('mailto:icareappmail@gmail.com?subject=ICare Feedback Support&body='+MessageController.text);
                                                  Navigator.pop(context, false);
                                                  Fluttertoast.showToast(
                                                      msg: "Sent Successfully",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.teal,
                                                      textColor: Colors.white,
                                                      fontSize: 14.0);
                                                  },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.teal,
                                                  // fixedSize: Size(250, 50),
                                                ),
                                                child: Text(
                                                  ContactFormSubmit[LanguageData],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).then((exit) {
                                  if (exit == null) return;

                                  if (exit) {
                                    // user pressed Yes button
                                  } else {
                                    // user pressed No button
                                  }
                                });


                              },
                            ),
                          )

                      ),

                      // First Dependent
                      Container(
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
                            title: GestureDetector(
                              child: Text(LogoutTitle[LanguageData],
                                style: const TextStyle(color: Color(0xffdc6c73),),
                              ),
                              onTap: ()
                              {
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
                                  textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                  child: LoginPage(storage: LoginStorage()),),
                                    ));
                              },
                            ),
                          )

                      ),

                    ],
                    //padding: EdgeInsets.all(10),
                  ),

                ),

              ],
            )

        )
    );
  }




}





class SettingsStorage
{
  final _auth = FirebaseAuth.instance;

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

// This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData(String Data, String Filename) async {
    final _dirPath = await createSettingsFolder();

    final _myFile = File('$_dirPath/'+Filename+'.txt');
// If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString(Data);
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

  Future<void> deleteFolder(String Foldername) async {
    final dirPath =  await createFolder();
    final folder = Directory('$dirPath/'+Foldername);
    try {
      if (await folder.exists()) {
        folder.deleteSync(recursive: true);
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }


  Future<void> _signOut() async {
    await _auth.signOut();
    // await _googleSignIn.signOut();
  }
}



