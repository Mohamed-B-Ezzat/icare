import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Pages/review_vitalsigns.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/ImageFromGalleryEx.dart';



  class EditVitalSigns extends StatefulWidget {
    final EditVitalSignsStorage storage;

    EditVitalSigns({Key? key, required this.storage}) : super(key: key);

    @override
  _EditVitalSignsState createState() => _EditVitalSignsState();
  }

  class _EditVitalSignsState extends State<EditVitalSigns>  {
    var LanguageData =0;
    var Title = ["Vital Signs","العلامات الحيوية",""];
    var SelectTitle = ["Select Vital Signs","حدد العلامات الحيوية",""];
    var LeastOneTitle = ["Select at least one vital sign","حدد علامة حيوية واحدة على الأقل",""];
    var Sign1Title = ["Vital Sign 1","علامة حيوية 1",""];
    var Sign2Title = ["Vital Sign 2","علامة حيوية 2",""];
    var Sign3Title = ["Vital Sign 3","علامة حيوية 3",""];
    var VitalTitle = ["Vital Sign","العلامة الحيوية",""];
    var RateTitle = ["Rate","المعدل",""];
    var SaveBtnTitle = ["Save","حفظ",""];
    var NoSelectedTitle = ["Save Failed,\nSelect at least one vital sign.","فشل الحفظ ,"+"\n"+"حدد علامة حيوية واحدة على الأقل.",""];
    var SaveFailedTitle = ["Save Failed, Check Required Info.","فشل الحفظ ، تحقق من المعلومات المطلوبة.",""];
    var SaveSuccessTitle = ["Successfully Saved \n Review selected vital signs","تم الحفظ بنجاح "+"\n"+"راجع العلامات الحيوية المحددة",""];


  TextEditingController DateController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController CauseController = TextEditingController();

  final verticalScroll = ScrollController();

  var VitalSigns = const ["Abdomen measurement","Body Mass Index (BMI)","Blood glucose","Blood pressure","Body fat percentage","Bust/pectoral measurement","Chest measurement","Cholesterol","Forearm measurement","Height","Hydration percentage","Mid-calf measurement","Muscle mass percentage","Neck measurement","Oxygen saturation","Peak flow","Pulse rate","Temperature","Upper-arm measurement","Visceral fat","Waist/Hip ratio","Weight","Respiration rate"];
  var Rates = const ["Daily","Weekly","Monthly"];
  var _VitalSigns1,_Rates1;
  var _VitalSigns2,_Rates2;
  var _VitalSigns3,_Rates3;
  var AllergyID;

  String Cause = "";
  String description = "";
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String? _content;
  XFile? _image = null;
  final picker = ImagePicker();
  bool VitalSign1Checked = false, VitalSign2Checked = false, VitalSign3Checked = false;
  var VitalData, VitalSignsData, VitalReviewed, VitalSignsReviewed;

  @override
  void initState() {
    // TODO: implement initState
    widget.storage._readData("icare_vital_signs").then((String VitalValue) async{
      if(VitalValue != "No Data" && VitalValue != "")
      {
        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(VitalValue);
        if(lines.isNotEmpty) {
          int row = lines.length;
          int col = 7;
          VitalData = List.generate(
              row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result = lines[i].split('#');
            for (var j = 0; j < result.length; j++) {
              VitalData[i][j] = result[j];
            }
          }
          if(VitalData[0][1] != null)
            {
              VitalSign1Checked = true;
            }
          if(VitalData[0][3] != null)
          {
            VitalSign2Checked = true;
          }
          if(VitalData[0][5] != null)
          {
            VitalSign3Checked = true;
          }


          setState(() {
            VitalSignsData = VitalData;
            _VitalSigns1 = VitalData[0][1];
            _VitalSigns2 = VitalData[0][3];
            _VitalSigns3 = VitalData[0][5];
            _Rates1 = VitalData[0][2];
            _Rates2 = VitalData[0][4];
            _Rates3 = VitalData[0][6];
            VitalSignsReviewed = VitalReviewed;
          });

        }
      }
      else
      {
        super.initState();
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

  }

  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Directionality( // use this
        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
        child: ImageFromGalleryEx("/VitalSigns", type,storage: ImageStorage(),))),);
  }

  @override
  Widget build(BuildContext context) {

    double edge = 120.0;
    double padding = edge / 10.0;
    var now =  DateTime.now();
    var outputFormat = intl.DateFormat('MM/dd/yyyy');
    var outputDate = outputFormat.format(now);
    String? DateNow = outputDate.toString();

    return Scaffold(
      //extendBodyBehindAppBar: true,
        drawer: MainMenu(storage: MainMenuStorage()),
        appBar: AppBar(
          title: Text(Title[LanguageData],
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
                              child:  Card(
                                  color: const Color.fromRGBO(32, 116, 150, 1.0),
                                  shadowColor: Colors.grey,
                                  elevation: 4.0,
                                  margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                  child: ListTile(
                                    title:Text(SelectTitle[LanguageData],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ) ,
                                  )
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child:  Card(
                                  color: Colors.teal,
                                  shadowColor: Colors.grey,
                                  elevation: 4.0,
                                  margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                  child: ListTile(
                                    title:Text(LeastOneTitle[LanguageData],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ) ,
                                  )
                              ),
                            ),

                            const SizedBox(
                              height: 5.0,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const SizedBox(width: 0.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child:  Checkbox(
                                      activeColor: Colors.teal,
                                      value: VitalSign1Checked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          VitalSign1Checked = value!;
                                        });
                                      },
                                    ),
                                ),
                                const SizedBox(width: 0.0),
                                // Profile Picture
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child:  Text(Sign1Title[LanguageData],
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ) ,
                                        ),
                                const SizedBox(width: 50.0),
                              ],
                            ),

                            const SizedBox(
                              height: 0.0,
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Card(
                                color: VitalSign1Checked ? null :Colors.grey ,
                                shadowColor: Colors.grey,
                                elevation: 4.0,
                                margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                child:DropdownButtonFormField(
                                isDense: true,
                                isExpanded: true,
                                items: VitalSigns.map((String VitalSign) {
                                  return  DropdownMenuItem(
                                      enabled: VitalSign1Checked,
                                      alignment: Alignment.center,
                                      value: VitalSign,
                                      child: Row(
                                        children: <Widget>[
                                          //Icon(Icons.star),
                                          Text(VitalSign,
                                            style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                              fontSize: 16,
                                              //fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  // do other stuff with _Symptom
                                  _VitalSigns1 = newValue;
                                  //AllergyID = VitalSigns.indexOf(newValue.toString());
                                },
                                value: _VitalSigns1,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                                  filled: false,
                                  fillColor: Colors.grey[200],
                                  prefixIcon: const Icon(Icons.monitor_heart_outlined) ,
                                  hintText: VitalTitle[LanguageData],
                                  hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  // errorText: 'Select Sub VitalSigns',
                                ),
                              ),
                            ),
                            ),

                            const SizedBox(
                              height: 5.0,
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child:  Card(
                                  color: VitalSign1Checked ? null :Colors.grey ,
                                  shadowColor: Colors.grey,
                                  elevation: 4.0,
                                  margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                  child: DropdownButtonFormField(
                                    isDense: true,
                                    isExpanded: true,
                                    items: Rates.map((String Rate) {
                                      return  DropdownMenuItem(
                                          enabled: VitalSign1Checked,
                                          alignment: Alignment.center,
                                          value: Rate,
                                          child: Row(
                                            children: <Widget>[
                                              //Icon(Icons.star),
                                              Text(Rate,
                                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      // do other stuff with _Symptom
                                      _Rates1 = newValue;
                                      //AllergyID = Rates.indexOf(newValue.toString());
                                    },
                                    value: _Rates1,
                                    decoration: InputDecoration(
                                      enabled: VitalSign1Checked,
                                      border: const OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                                      filled: false,
                                      fillColor: Colors.grey[200],
                                      prefixIcon: const Icon(Icons.access_time) ,
                                      hintText: RateTitle[LanguageData],
                                      hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                        fontSize: 16,
                                        //fontWeight: FontWeight.w500,
                                      ),
                                      // errorText: 'Select Sub VitalSigns',
                                    ),
                                  ),
                              ),
                            ),

                            const SizedBox(
                              height: 5.0,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const SizedBox(width: 0.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child:  Checkbox(
                                    activeColor: Colors.teal,
                                    value: VitalSign2Checked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        VitalSign2Checked = value!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 0.0),
                                // Profile Picture
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child:  Text(Sign2Title[LanguageData],
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ) ,
                                ),
                                const SizedBox(width: 50.0),
                              ],
                            ),

                            const SizedBox(
                              height: 0.0,
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Card(
                                color: VitalSign2Checked ? null :Colors.grey ,
                                shadowColor: Colors.grey,
                                elevation: 4.0,
                                margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                child:DropdownButtonFormField(
                                  isDense: true,
                                  isExpanded: true,
                                  items: VitalSigns.map((String VitalSign) {
                                    return  DropdownMenuItem(
                                        enabled: VitalSign2Checked,
                                        alignment: Alignment.center,
                                        value: VitalSign,
                                        child: Row(
                                          children: <Widget>[
                                            //Icon(Icons.star),
                                            Text(VitalSign,
                                              style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                                fontSize: 16,
                                                //fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    // do other stuff with _Symptom
                                    _VitalSigns2 = newValue;
                                    //AllergyID = VitalSigns.indexOf(newValue.toString());
                                  },
                                  value: _VitalSigns2,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                                    filled: false,
                                    fillColor: Colors.grey[200],
                                    prefixIcon: const Icon(Icons.monitor_heart_outlined) ,
                                    hintText: VitalTitle[LanguageData],
                                    hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                      fontSize: 16,
                                      //fontWeight: FontWeight.w500,
                                    ),
                                    // errorText: 'Select Sub VitalSigns',
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 5.0,
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child:  Card(
                                color: VitalSign2Checked ? null :Colors.grey ,
                                shadowColor: Colors.grey,
                                elevation: 4.0,
                                margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                child: DropdownButtonFormField(
                                  isDense: true,
                                  isExpanded: true,
                                  items: Rates.map((String Rate) {
                                    return  DropdownMenuItem(
                                        enabled: VitalSign2Checked,
                                        alignment: Alignment.center,
                                        value: Rate,
                                        child: Row(
                                          children: <Widget>[
                                            //Icon(Icons.star),
                                            Text(Rate,
                                              style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                                fontSize: 16,
                                                //fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    // do other stuff with _Symptom
                                    _Rates2 = newValue;
                                    //AllergyID = Rates.indexOf(newValue.toString());
                                  },
                                  value: _Rates2,
                                  decoration: InputDecoration(
                                    enabled: VitalSign2Checked,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                                    filled: false,
                                    fillColor: Colors.grey[200],
                                    prefixIcon: const Icon(Icons.access_time) ,
                                    hintText: RateTitle[LanguageData],
                                    hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                      fontSize: 16,
                                      //fontWeight: FontWeight.w500,
                                    ),
                                    // errorText: 'Select Sub VitalSigns',
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 5.0,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const SizedBox(width: 0.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child:  Checkbox(
                                    activeColor: Colors.teal,
                                    value: VitalSign3Checked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        VitalSign3Checked = value!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 0.0),
                                // Profile Picture
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child:  Text(Sign3Title[LanguageData],
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ) ,
                                ),
                                const SizedBox(width: 50.0),
                              ],
                            ),

                            const SizedBox(
                              height: 0.0,
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Card(
                                color: VitalSign3Checked ? null :Colors.grey ,
                                shadowColor: Colors.grey,
                                elevation: 4.0,
                                margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                child:DropdownButtonFormField(
                                  isDense: true,
                                  isExpanded: true,
                                  items: VitalSigns.map((String VitalSign) {
                                    return  DropdownMenuItem(
                                        enabled: VitalSign3Checked,
                                        alignment: Alignment.center,
                                        value: VitalSign,
                                        child: Row(
                                          children: <Widget>[
                                            //Icon(Icons.star),
                                            Text(VitalSign,
                                              style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                                fontSize: 16,
                                                //fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    // do other stuff with _Symptom
                                    _VitalSigns3 = newValue;
                                    //AllergyID = VitalSigns.indexOf(newValue.toString());
                                  },
                                  value: _VitalSigns3,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                                    filled: false,
                                    fillColor: Colors.grey[200],
                                    prefixIcon: const Icon(Icons.monitor_heart_outlined) ,
                                    hintText: VitalTitle[LanguageData],
                                    hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                      fontSize: 16,
                                      //fontWeight: FontWeight.w500,
                                    ),
                                    // errorText: 'Select Sub VitalSigns',
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 5.0,
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child:  Card(
                                color: VitalSign3Checked ? null :Colors.grey ,
                                shadowColor: Colors.grey,
                                elevation: 4.0,
                                margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                child: DropdownButtonFormField(
                                  isDense: true,
                                  isExpanded: true,
                                  items: Rates.map((String Rate) {
                                    return  DropdownMenuItem(
                                        enabled: VitalSign3Checked,
                                        alignment: Alignment.center,
                                        value: Rate,
                                        child: Row(
                                          children: <Widget>[
                                            //Icon(Icons.star),
                                            Text(Rate,
                                              style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                                fontSize: 16,
                                                //fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    // do other stuff with _Symptom
                                    _Rates3 = newValue;
                                    //AllergyID = Rates.indexOf(newValue.toString());
                                  },
                                  value: _Rates3,
                                  decoration: InputDecoration(
                                    enabled: VitalSign3Checked,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                                    filled: false,
                                    fillColor: Colors.grey[200],
                                    prefixIcon: const Icon(Icons.access_time) ,
                                    hintText: RateTitle[LanguageData],
                                    hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                      fontSize: 16,
                                      //fontWeight: FontWeight.w500,
                                    ),
                                    // errorText: 'Select Sub VitalSigns',
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

                            Container(
                                height: 50,
                                width: 300.0,
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  child: Text(SaveBtnTitle[LanguageData]),
                                  onPressed: ()  async {
                                    try {
                                      setState(() {
                                        showProgress = true;
                                      });

                                      if(VitalSign1Checked && !VitalSign2Checked && !VitalSign3Checked)
                                      {
                                        widget.storage._writeData("1"+","
                                            +_VitalSigns1+","
                                            +_Rates1+"\n", "icare_vital_signs");
                                      }
                                      else if(!VitalSign1Checked && VitalSign2Checked && !VitalSign3Checked)
                                      {
                                        widget.storage._writeData("1"+","
                                            +_VitalSigns2+","
                                            +_Rates2+"\n", "icare_vital_signs");
                                      }
                                      else if(!VitalSign1Checked && !VitalSign2Checked && VitalSign3Checked)
                                      {
                                        widget.storage._writeData("1"+","
                                            +_VitalSigns3+","
                                            +_Rates3+"\n", "icare_vital_signs");
                                      }
                                      else if(!VitalSign1Checked && VitalSign2Checked && VitalSign3Checked)
                                      {
                                        widget.storage._writeData("2"+","
                                            +_VitalSigns2+","
                                            +_Rates2+","
                                            +_VitalSigns3+","
                                            +_Rates3+"\n", "icare_vital_signs");
                                      }
                                      else if(VitalSign1Checked && !VitalSign2Checked && VitalSign3Checked)
                                      {
                                        widget.storage._writeData("2"+","
                                            +_VitalSigns1+","
                                            +_Rates1+","
                                            +_VitalSigns3+","
                                            +_Rates3+"\n", "icare_vital_signs");
                                      }
                                      else if(VitalSign1Checked && VitalSign2Checked && !VitalSign3Checked)
                                      {
                                        widget.storage._writeData("2"+","
                                            +_VitalSigns1+","
                                            +_Rates1+","
                                            +_VitalSigns2+","
                                            +_Rates2+"\n", "icare_vital_signs");
                                      }
                                      else if(VitalSign1Checked && VitalSign2Checked && VitalSign3Checked)
                                      {
                                        widget.storage._writeData("3"+","
                                            +_VitalSigns1+","
                                            +_Rates1+","
                                            +_VitalSigns2+","
                                            +_Rates2+","
                                            +_VitalSigns3+","
                                            +_Rates3+"\n", "icare_vital_signs");
                                      }
                                      else
                                        {
                                        Fluttertoast.showToast(
                                        msg: NoSelectedTitle[LanguageData],
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.teal,
                                        textColor: Colors.white,
                                        fontSize: 14.0);
                                        }
                                      widget.storage._writeData("false", "icare_vital_review");
                                      Fluttertoast.showToast(
                                          msg: SaveSuccessTitle[LanguageData],
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.teal,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder:
                                              (context) =>
                                                  Directionality( // use this
                                                      textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                      child: ReviewVitalSigns(storage: ReviewVitalSignsStorage(),)),
                                          )
                                      );
                                    }
                                    catch (e) {
                                      setState(() {
                                        showProgress = false;
                                        });
                                        Fluttertoast.showToast(
                                        msg: SaveFailedTitle[LanguageData],
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.teal,
                                        textColor: Colors.white,
                                        fontSize: 14.0);
                                      }

                                      setState(() {
                                        showProgress = false;
                                      });
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


class EditVitalSignsStorage
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
// Find the Documents path
  Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<String> createFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/VitalSigns');
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

}