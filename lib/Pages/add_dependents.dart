import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/HomePage.dart';
import 'package:icare/Pages/Dependents.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/ImageFromGalleryEx.dart';


class AddDependents extends StatefulWidget {
  final AddDependentsStorage storage;

  AddDependents({Key? key, required this.storage}) : super(key: key);
  @override
  _AddDependentsState createState() => _AddDependentsState();
}
class _AddDependentsState extends State<AddDependents>  {

  var LanguageData =0;
  var Title = ["Family Members","أفراد الأسرة",""];
  var AddTitle = ["Add Family Member","اضافة فرد أسرة",""];
  var NameTitle = ["Name**","الاسم**",""];
  var BirthDateTitle = ["Birth Date**","تاريخ الميلاد**",""];
  var AgeTitle = ["Age**","السن**",""];
  var GenderTitle = ["Gender**","النوع**",""];
  var WeightTitle = ["Weight**","الوزن**",""];
  var HeightTitle = ["Height**","الطول**",""];
  var BloodTypeTitle = ["Blood Type**","فصيلة الدم**",""];
  var RelationshipTitle = ["Relationship**","العلاقة",""];
  var ChrHealthTitle = ["Chronic Health Condition**","الحالة الصحية المزمنة**",""];
  var SaveBtnTitle = ["Save","حفظ",""];
  var SaveFailedTitle = ["Save Failed, Check Required Info.","فشل الحفظ ، تحقق من المعلومات المطلوبة.",""];


  final verticalScroll = ScrollController();

  TextEditingController DependentNameController = TextEditingController();
  TextEditingController DependentWeightController = TextEditingController();
  TextEditingController DependentBirthDateController = TextEditingController();
  TextEditingController DependentAgeController = TextEditingController();
  TextEditingController DependentHeightController = TextEditingController();
  TextEditingController DependentChrHealthController = TextEditingController();

  var BloodTypes = const ["A+","A-","B+","B-","AB+","AB-","O+","O-"];
  var Genders = const ["Male","Female","Unspecified"];
  var Relations = const ["father","mother","son","daughter","husband","wife","brother","sister","grandfather","grandmother","grandson","granddaughter","Spouse","Family Member"];

  var _BloodTypes;
  var _Relations;
  var _Genders;

  late String Name, weight, birthdate,age,height,chrhealth;

  String imagepath = "";
  String ImageData = "No Data";

  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String? _content;
  XFile? _image = null;
  final picker = ImagePicker();


  var imagePicker;
  Future<void> _getDirPath(var type) async {
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile imagefile = await imagePicker.pickImage(
        source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = imagefile;
    });
  }

  @override
  void initState() {
    imagePicker = new ImagePicker();

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

    super.initState();


  }

  Future<void> _handleURLButtonPress(BuildContext context, var type) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => Directionality( // use this
        textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
        child: ImageFromGalleryEx("/Dependents", type,storage: ImageStorage(),)),));
  }

  @override
  Widget build(BuildContext context) {

    double edge = 120.0;
    double padding = edge / 10.0;
    var now =  DateTime.now();
    var outputFormat = DateFormat('MM/dd/yyyy');
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
                          'assets/svg/dependents.svg',
                          width: 50,
                          height: 50,
                          alignment: AlignmentDirectional.center,
                          // color: Colors.white,
                          allowDrawingOutsideViewBox: false,
                        ),
                        // SvgPicture.asset(
                        //   'assets/svg/dependents.svg',
                        //   width: 50,
                        //   height: 50,
                        //   alignment: AlignmentDirectional.center,
                        //   // color: Colors.white,
                        //   allowDrawingOutsideViewBox: false,
                        //   // fit: BoxFit.cover,
                        // ),
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
                                    title:Text(AddTitle[LanguageData],
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const SizedBox(width: 20.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      //_handleURLButtonPress(context, ImageSourceType.camera);
                                      _getDirPath(ImageSourceType.camera);
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/camera.svg',
                                      height: 30.0,
                                      width: 30.0,
                                      allowDrawingOutsideViewBox: true,
                                      // color : Colors.white,
                                    ),
                                    label: const Text('',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Color.fromRGBO(66, 133, 244, 1.0))
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      // primary: Color.fromRGBO(66, 133, 244, 1.0),
                                      primary: Colors.white,
                                      // side: const BorderSide(width: 1.0, color: Color.fromRGBO(32, 116, 150, 1.0)),
                                      side: const BorderSide(width: 1.0, color: Colors.transparent),
                                      textStyle: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                // Profile Picture
                                Container(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    color: Colors.transparent,
                                    child:
                                    _image != null
                                        ? Image.file(
                                      File(_image!.path),
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
                                const SizedBox(width: 10.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      // _handleURLButtonPress(context, ImageSourceType.gallery);
                                      _getDirPath(ImageSourceType.gallery);
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/gallery.svg',
                                      height: 30.0,
                                      width: 30.0,
                                      allowDrawingOutsideViewBox: true,
                                      // color : Colors.white,
                                    ),
                                    label: const Text('',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Color.fromRGBO(66, 133, 244, 1.0))
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      // primary: Color.fromRGBO(66, 133, 244, 1.0),
                                      primary: Colors.white,
                                      //side: const BorderSide(width: 1.0, color: Color.fromRGBO(32, 116, 150, 1.0)),
                                      side: const BorderSide(width: 1.0, color: Colors.transparent),
                                      textStyle: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                              ],
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child:TextField(
                                controller: DependentNameController,
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  Name = value; //get value from textField
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: NameTitle[LanguageData],
                                  prefixIcon: const Icon(Icons.account_box),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child:TextField(
                                controller: DependentBirthDateController, //editing controller of this TextField
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.date_range), //icon of text field
                                  labelText: BirthDateTitle[LanguageData],
                                  //labelStyle: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                  labelStyle: const TextStyle(color: Color.fromRGBO(
                                      103, 103, 103, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),  //label text of field
                                ),
                                readOnly: true,  //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context, initialDate: DateTime.now(),
                                      firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101)
                                  );

                                  if(pickedDate != null ){
                                    //var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
                                    var outputFormat = DateFormat('MM/dd/yyyy');
                                    var outputDate = outputFormat.format(pickedDate);
                                    DependentBirthDateController.text =  outputDate.toString();
                                    setState(() {
                                      DependentBirthDateController.text = outputDate.toString(); //set output date to TextField value.
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

                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child:  DropdownButtonFormField(
                                isDense: true,
                                isExpanded: true,
                                items: BloodTypes.map((String Value) {
                                  return  DropdownMenuItem(
                                    alignment: Alignment.centerLeft,
                                    value: Value,
                                    child: Text(Value,
                                        style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                          fontSize: 16,
                                          //fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  // do other stuff with _Prescription
                                  _BloodTypes = newValue;
                                },
                                value: _BloodTypes,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.fromLTRB(5, 20, 0, 17),
                                  filled: false,
                                  fillColor: Colors.grey[200],
                                  prefixIcon: const Icon(Icons.bloodtype) ,
                                  hintText: BloodTypeTitle[LanguageData],
                                  hintStyle: const TextStyle(
                                    // color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  // errorText: 'Select Sub Prescriptions',
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const SizedBox(width: 10.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: DropdownButtonFormField(
                                    isDense: true,
                                    isExpanded: true,
                                    items: Genders.map((String Value) {
                                      return  DropdownMenuItem(
                                        alignment: Alignment.centerLeft,
                                        value: Value,
                                        child: Text(Value,
                                            style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                              fontSize: 16,
                                              //fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      // do other stuff with _Prescription
                                      _Genders = newValue;
                                    },
                                    value: _Genders,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 17),
                                      filled: false,
                                      fillColor: Colors.grey[200],
                                      prefixIcon: const Icon(Icons.merge_type) ,
                                      hintText: GenderTitle[LanguageData],
                                      hintStyle: const TextStyle(
                                        // color: Color.fromRGBO(32, 116, 150, 1.0),
                                        fontSize: 16,
                                        //fontWeight: FontWeight.w500,
                                      ),
                                      // errorText: 'Select Sub Prescriptions',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: TextField(
                                    controller: DependentAgeController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      age = value; //get value from textField
                                    },
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: AgeTitle[LanguageData],
                                      prefixIcon: const Icon(Icons.view_agenda_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child:  DropdownButtonFormField(
                                isDense: true,
                                isExpanded: true,
                                items: Relations.map((String Value) {
                                  return  DropdownMenuItem(
                                    alignment: Alignment.centerLeft,
                                    value: Value,
                                    child: Text(Value,
                                        style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                          fontSize: 16,
                                          //fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  // do other stuff with _Prescription
                                  _Relations = newValue;
                                },
                                value: _Relations,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 17),
                                  filled: false,
                                  fillColor: Colors.grey[200],
                                  prefixIcon: const Icon(Icons.volunteer_activism) ,
                                  hintText: RelationshipTitle[LanguageData],
                                  hintStyle: const TextStyle(
                                    // color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  // errorText: 'Select Sub Prescriptions',
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const SizedBox(width: 10.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: TextField(
                                    controller: DependentWeightController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      weight = value; //get value from textField
                                    },
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: WeightTitle[LanguageData],
                                      prefixIcon: const Icon(Icons.line_weight),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: TextField(
                                    controller: DependentHeightController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      height = value; //get value from textField
                                    },
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: HeightTitle[LanguageData],
                                      prefixIcon: const Icon(Icons.height),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                controller: DependentChrHealthController,
                                onChanged: (value) {
                                  chrhealth = value;
                                  //get value from textField
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: ChrHealthTitle[LanguageData],
                                  labelStyle: const TextStyle(color: Color.fromRGBO(
                                      103, 103, 103, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: const Icon(Icons.health_and_safety),
                                ),
                                style: const TextStyle(color: Color.fromRGBO(
                                    103, 103, 103, 1.0),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),

                            ),


                            const SizedBox(
                              height: 15.0,
                            ),
                            Container(
                                height: 50,
                                width: 300.0,
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  child: Text(SaveBtnTitle[LanguageData]),
                                  onPressed: ()  async {
                                    try {
                                      // if(fullname != "" && username != "") {
                                      setState(() {
                                        showProgress = true;
                                      });

                                      widget.storage._writeData(Name+"#"
                                          +_Relations+"#"
                                          +_Genders+"#"
                                          +_BloodTypes+"#"
                                          +DependentBirthDateController.text+"#"
                                          +age+"#"
                                          +weight+"#"
                                          +height+"#"
                                          +chrhealth+"\n",
                                          "icare_Dependents");
                                      _image != null
                                          ?widget.storage._writeData(_image!.path+"\n", "icare_pictures")
                                          :widget.storage._writeData(""+"\n", "icare_pictures");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Directionality( // use this
                                                textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                child: DependentsPage(storage: DependentsStorage(), key: null,)),),
                                      );
                                      setState(() {
                                        showProgress = false;
                                      });

                                      // }
                                      // else {
                                      //   setState(() {
                                      //     showProgress = false;
                                      //   });
                                      //   Fluttertoast.showToast(
                                      //       msg: "E-mail and password are required",
                                      //       toastLength: Toast.LENGTH_SHORT,
                                      //       gravity: ToastGravity.BOTTOM,
                                      //       timeInSecForIosWeb: 1,
                                      //       backgroundColor: Colors.teal,
                                      //       textColor: Colors.white,
                                      //       fontSize: 14.0);
                                      // }
                                    } catch (e) {
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



class AddDependentsStorage
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

        await _myFile.writeAsString(Data,mode: FileMode.append);
  }

}