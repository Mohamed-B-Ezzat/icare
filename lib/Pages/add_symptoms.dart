import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Pages/Symptoms.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/ImageFromGalleryEx.dart';



class AddSymptoms extends StatefulWidget {
  final AddSymptomsStorage storage;

  AddSymptoms({Key? key, required this.storage}) : super(key: key);

  @override
  _AddSymptomsState createState() => _AddSymptomsState();

}

class _AddSymptomsState extends State<AddSymptoms> {

  var LanguageData =0;
  var Title = ["Symptoms","الأعراض",""];
  var AddTitle = ["Add Symptom","اضافة عرض",""];
  var DateTitle = ["Date","التاريخ",""];
  var GeneralTitle = ["General Symptoms","الأعراض العامة",""];
  var SubTitle = ["Sub Symptoms","الأعراض الفرعية",""];
  var DescriptionTitle = ["Description","الوصف",""];
  var SaveBtnTitle = ["Save","حفظ",""];
  var SaveFailedTitle = ["Save Failed, Check Required Info.","فشل الحفظ ، تحقق من المعلومات المطلوبة.",""];



  TextEditingController DateController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();

  final verticalScroll = ScrollController();

  var Generalsymptoms = const ["Dermatological Rash","Head - Face and Neck","Ears and Hearing","Digestive and Excretory Systems","Muscoskeletal System","Respitory and Circulatory Systems","Neurologic System","Psychological Well‐Being","Mental Capability","Reproduction and Sexuality","General Well‐Being","Endocrine System"];

  var Subsymptoms = const [["Rash at site of bite","Rashes on other parts of body","Basically circular rash","Generalized or spread out rash","Raised rash disappearing and reoccurring"],
    ["Pressure in head","Headache mild or severe","Twitching of facial or other muscles","Facial paralysis (Bells Palsy)","Tingling of nose, tip of tongue","Cheek or facial flushing","Stiff or painful neck","Jaw pain or stiffness","Dental problems (unexplained)","Sore throat","Runny nose","Hoarseness","Clearing throat a lot (phlegm)","Double or blurry vision, increased floating spots","Pain in eyes or swelling around eyes","Sensitivity to light","Flashing lights, peripheral waves, phantom","images in corners of eyes","Unexplained hair loss","Seizures","White matter lesions in head (MRI)","Swollen glands"],
    ["Decreased hearing in one or both ears","Plugged ears","Buzzing in ears","Pain in ears","Oversensitivity to sounds","Ringing in one or both ears"],
    ["Diarrhea","Constipation","Irritable bladder (trouble starting or stopping) (interstitial cystitis)","Upset stomach (nausea or pain)","GERD (gastro esophageal reflux disease)","Bladder dysfunction","Change in bowel function","Hepatomegaly","Jaundice","enlargement of the spleen ‐ Splenomegaly","Abnormal Liver enzymes"],
    ["Bone pain","Joint pain or swelling","Carpal Tunnel Syndrome","Muscle pain or cramps (Fibromyalgia)","Stiffness of back, joints, neck or tennis elbow","Papular or Angiomatous rash","Skin sensitivity","Myalgias"],
    ["Shortness of breath","Cough","Chest pain or rib soreness","Night sweats or unexplained chills","Heart palpitations","Heart blockage","Endocarditis","Anemia","Can not get full satifying breath ‐ air hunger","Pulse skips","Myocarditis ‐ inflamation of the heart muscle","Cardiac imparment","Heart valve prolapse"],
    ["Tremors or unexplained shaking","Fatigue","Chronic Fatigue Syndrome","Weakness, peripheral neuropathy","Partial paralysis","Numbness in body (tingling or pinpricks)","Burning or stabbing sensations in the body","Light headedness","Poor balance","Dizziness","Difficulty walking","Increased motion sickness","Mild Encephalopathy","Immune deficiency"],
    ["Mood swings","Irritability","Bi‐Polar Disorder","Unusual depression","Disorientation (feeling or getting lost)","Feeling as if you are losing your mind","Overemotional reactions","Too much sleep","Insomnia","Difficulty falling or staying asleep","Sleep apnea (also known as Narcolepsy)","Panic attacks or anxiety","A strong desire to sleep ‐ somnolence"],
    ["Memory loss (short or long term)","Confusion, difficulty in thinking","Difficulty with concentration or reading","Going to the wrong place","Slurred or slow speech","Stammering speech","Forgetting how to perform simple tasks","Difficulty writing","Difficulty finding words; name blocking","Problem absorbing new information"],
    ["Loss of sex drive","Sexual dysfunction","Unexplained menstrual pain or irregularity","Unexplained breast pain or discharge","Testicular pain","Pelvic pain","Unexplained milk production"],
    ["Unexplained weight gain or loss","Extreme fatigue","Poor stamina","Swollen glands or lymph nodes","Unexplained fevers, high or low‐grade","Continual infections (sinus, kidney, eye, etc.)","Symptoms seem to change, or come and go","Pain migrates to different parts of the body","Experienced a flu‐like illnesss, after which you","have not since felt well","Low body temperature","Allergies or chemical sensitivities","Increased effect from alcohol and possible worse hang‐over","Veritgo","Upset stomach"],
    ["Immune deficiency","Lymphadenopathy","Weakened immune response","Persistent Leukopenia ‐ decreased white blood cells","Thrombocytopenia ‐ decrease of platelets in blood"]];

  var _Generalsymptoms;
  var _Subsymptoms;
  var SymptomID = 0;
  String description = "";
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String? _content;
  XFile? _image = null;
  final picker = ImagePicker();

  bool _isLoading = false;


  Future<void> PopulateSubSymptoms(String value) async{
    setState(() {
      _isLoading = true;
    });
    // do other stuff with _Symptom
    _Generalsymptoms = value;
    SymptomID = Generalsymptoms.indexOf(value.toString());
    setState(() {
      _Subsymptoms = Subsymptoms[SymptomID][0];
      _isLoading = false;
      SymptomID = Generalsymptoms.indexOf(value.toString());
    });
  }


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
        child: ImageFromGalleryEx("/Symptoms", type,storage: ImageStorage(),))),);
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
                        child: DropdownButtonFormField(
                          isDense: true,
                          isExpanded: true,
                          items: Generalsymptoms.map((String Symptom) {
                            return  DropdownMenuItem(
                              alignment: Alignment.centerLeft,
                              value: Symptom,
                              child: Text(Symptom,
                                  style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) async{
                            PopulateSubSymptoms(newValue.toString());
                          },
                          value: _Generalsymptoms,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                            filled: false,
                            fillColor: Colors.grey[200],
                            prefixIcon: const Icon(Icons.medical_services_outlined) ,
                            hintText: GeneralTitle[LanguageData],
                            hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                          fontSize: 16,
                          //fontWeight: FontWeight.w500,
                        ),
                            // errorText: 'Select Sub Symptoms',
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : DropdownButtonFormField(
                          isExpanded: true,
                          items: Subsymptoms[SymptomID].map((String Symptom) {
                            return  DropdownMenuItem(
                              alignment: Alignment.centerLeft,
                              value: Symptom,
                              child: Text(Symptom,
                                  style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            // do other stuff with _Symptom
                            _Subsymptoms = newValue;
                          },
                          value: _Subsymptoms,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                              filled: true,
                              fillColor: Colors.grey[200],
                            prefixIcon: const Icon(Icons.medical_services),
                            hintText: SubTitle[LanguageData],
                              hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                          fontSize: 16,
                          //fontWeight: FontWeight.w500,
                        ),
                              // errorText: 'Select Sub Symptoms',
                        ),
                      ),
                      ),

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
                              +_Generalsymptoms+"#"
                              +_Subsymptoms+"#"
                              +description+"#"
                              +SymptomID.toString()+"\n",
                              "icare_symptoms");
                          _image != null
                              ?widget.storage._writeData(_image!.path+"\n", "icare_pictures")
                              :widget.storage._writeData(""+"\n", "icare_pictures");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Directionality( // use this
                                    textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                    child: SymptomsPage(storage: SymptomsStorage(), key: null,)),),
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



class AddSymptomsStorage
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
    final path = Directory('${dir.path}/ICare/Symptoms');
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

