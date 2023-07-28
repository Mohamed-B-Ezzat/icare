import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Pages/Scans.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/ImageFromGalleryEx.dart';
import 'package:dropdown_search/dropdown_search.dart';


class AddScans extends StatefulWidget {
  final AddScansStorage storage;

  AddScans({Key? key, required this.storage}) : super(key: key);
  @override
  _AddScansState createState() => _AddScansState();
}
class _AddScansState extends State<AddScans>  {


  var LanguageData =0;
  var Title = ["Scans","الأشعة",""];
  var AddTitle = ["Add Scan","اضافة أشعة",""];
  var DateTitle = ["Date","التاريخ",""];
  var ScansTitle = ["Scans","الأشعة",""];
  var SearchTitle = ["Search","بحث",""];
  var DescriptionTitle = ["Description","الوصف",""];
  var SaveBtnTitle = ["Save","حفظ",""];
  var SaveFailedTitle = ["Save Failed, Check Required Info.","فشل الحفظ ، تحقق من المعلومات المطلوبة.",""];



  TextEditingController DateController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();

  final verticalScroll = ScrollController();

  var GeneralScans = const ["Computed Tomography (CT) - Head","Computed Tomography (CT) - Chest","Computed Tomography (CT) - Body","CT Angiography (CTA)","Cardiac CT for Calcium Scoring","CT Colonography","X-ray (Radiography) - Bone","X-ray (Radiography) - Chest","Bone Densitometry (DEXA, DXA)","Panoramic Dental X-ray","Ultrasound-Echocardiography-Doppler","Electrocardiography (ECG)","Exercise ECG","Mammography","Ultrasound - Breast","Magnetic Resonance Imaging (MRI) - Breast","Galactography (Ductography)","Ultrasound-Guided Breast Biopsy","Magnetic Resonance Imaging (MRI) - Head","X-ray (Radiography) - Upper GI Tract","X-ray (Radiography) - Lower GI Tract","Coronary Computed Tomography Angiography (CCTA)","Hysterosalpingography","Venography","Urography","Direct Arthrography","Pediatric Voiding Cystourethrogram","Angioplasty and Vascular Stenting","Biopsies - Overview","Catheter Embolization","Transarterial Chemoembolization (TACE)","Nerve Blocks","Radiofrequency Ablation (RFA) / Microwave Ablation (MWA) of Liver Tumors","General Nuclear Medicine","Positron Emission Tomography - Computed Tomography (PET/CT)","Magnetic Resonance Imaging (MRI)","Computed Tomography CT Scan","X-ray Scan","Ultrasound","Doppler ultrasound","Magnetic Resonance Imaging (MRI) - Abdomen and Pelvis","Magnetic Resonance Imaging (MRI) - Body","Magnetic Resonance Imaging (MRI) - Cardiac (Heart)","Magnetic Resonance Imaging (MRI) - Chest","Magnetic Resonance Imaging (MRI) - Dynamic Pelvic Floor","Magnetic Resonance Imaging (MRI) - Knee","Magnetic Resonance Imaging (MRI) - Musculoskeletal","Magnetic Resonance Imaging (MRI) - Prostate","Magnetic Resonance Imaging (MRI) - Shoulder","Magnetic Resonance Imaging (MRI) - Spine","Magnetic Resonance, Functional (fMRI) - Brain","MR Angiography (MRA)","MR Enterography","Computed Tomography (CT) - Abdomen and Pelvis","Computed Tomography (CT) - Sinuses","Computed Tomography (CT) - Spine","CT Enterography","Dental Cone Beam CT","Discography (Discogram)","Facet Joint Block","CT Perfusion of the Head","Myelography","Intravenous Pyelogram (IVP)","Fistulogram/Sinogram","X-ray (Radiography) - Abdomen","Pediatric X-ray (Radiography)"];

  var _GeneralScans;
  var ScanID;

  String description = "";
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String? _content;
  XFile? _image = null;

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


  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Directionality( // use this
        textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
        child: ImageFromGalleryEx("/Scans", type,storage: ImageStorage(),)),));
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
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child:TextField(
                                controller: DateController, //editing controller of this TextField
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.date_range), //icon of text field
                                  labelText: DateTitle[LanguageData],
                                  labelStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),  //label text of field
                                ),
                                readOnly: true,  //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context, initialDate: DateTime.now(),
                                      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101)
                                  );

                                  if(pickedDate != null ){
                                    //var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
                                    var outputFormat = DateFormat('MM/dd/yyyy');
                                    var outputDate = outputFormat.format(pickedDate);
                                    DateController.text =  outputDate.toString();
                                    setState(() {
                                      DateController.text = outputDate.toString(); //set output date to TextField value.
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
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: DropdownSearch<String>(
                                popupProps: const PopupProps.dialog(
                                  showSelectedItems: true,
                                  showSearchBox: true,
                                  //disabledItemFn: (String s) => s.startsWith('I'),
                                ),
                                items: GeneralScans,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.settings_overscan) ,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    filled: false,
                                    labelText: ScansTitle[LanguageData],
                                    hintText: ScansTitle[LanguageData],
                                    hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                      fontSize: 12,
                                      //fontWeight: FontWeight.w500,
                                    ),
                                    // errorText: 'Select Sub Prescriptions',
                                  ),
                                ),
                                onChanged: (newValue) {
                                  // do other stuff with _Prescription
                                  _GeneralScans = newValue;
                                  ScanID = GeneralScans.indexOf(newValue.toString());
                                },
                                //show selected item
                                selectedItem: SearchTitle[LanguageData],
                              ),
                            ),

                            // Container(
                            //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            //   child: DropdownButtonFormField(
                            //     isExpanded: true,
                            //     items: SubScans1.map((String Scan) {
                            //       return  DropdownMenuItem(
                            //           value: Scan,
                            //           child: Row(
                            //             children: <Widget>[
                            //               //Icon(Icons.star),
                            //               Text(Scan,
                            //                 style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                            //                   fontSize: 16,
                            //                   //fontWeight: FontWeight.w500,
                            //                 ),
                            //               ),
                            //             ],
                            //           )
                            //       );
                            //     }).toList(),
                            //     onChanged: (newValue) {
                            //       // do other stuff with _Scan
                            //       _SubScans = newValue;
                            //     },
                            //     value: _SubScans,
                            //     decoration: InputDecoration(
                            //       border: OutlineInputBorder(),
                            //       contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            //       filled: true,
                            //       fillColor: Colors.grey[200],
                            //       prefixIcon: const Icon(Icons.medical_services),
                            //       hintText: 'Sub Scans',
                            //       hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                            //         fontSize: 16,
                            //         //fontWeight: FontWeight.w500,
                            //       ),
                            //       // errorText: 'Select Sub Scans',
                            //     ),
                            //   ),
                            // ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                controller: DescriptionController,
                                onChanged: (value) {
                                  description = value;
                                  //get value from textField
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: DescriptionTitle[LanguageData],
                                  labelStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: const Icon(Icons.notes),
                                ),
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),

                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const SizedBox(width: 20.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
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
                                const SizedBox(width: 10.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
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

                                      widget.storage._writeData(DateController.text+"#"
                                          +_GeneralScans+"#"
                                          +ScanID.toString()+"#"
                                          +description+"\n",
                                          "icare_scans");

                                      _image != null
                                          ?widget.storage._writeData(_image!.path+"\n", "icare_pictures")
                                          :widget.storage._writeData(""+"\n", "icare_pictures");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Directionality( // use this
                                                textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                child: ScansPage(storage: ScansStorage(), key: null,)),),
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


class AddScansStorage
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
    final path = Directory('${dir.path}/ICare/Scans');
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