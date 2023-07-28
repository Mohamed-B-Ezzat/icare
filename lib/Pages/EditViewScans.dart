import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/HomePage.dart';
import 'package:icare/Pages/Scans.dart';
import 'package:icare/Pages/add_scans.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/ImageFromGalleryEx.dart';
import 'package:share_plus/share_plus.dart';


class EditViewScansPage extends StatefulWidget {
  final  String Data;
  final bool type; // false for view and true for edit
  EditViewScansPage({Key? key, required this.type, required this.Data}) : super(key: key);
  @override
  _EditViewScansPageState createState() => _EditViewScansPageState();
}
class _EditViewScansPageState extends State<EditViewScansPage>  {


  TextEditingController DateController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController GeneralScanController = TextEditingController();

  var GeneralScans = const ["Scans","Computed Tomography (CT) - Head","Computed Tomography (CT) - Chest","Computed Tomography (CT) - Body","CT Angiography (CTA)","Cardiac CT for Calcium Scoring","CT Colonography","X-ray (Radiography) - Bone","X-ray (Radiography) - Chest","Bone Densitometry (DEXA, DXA)","Panoramic Dental X-ray","Ultrasound-Echocardiography-Doppler","Electrocardiography (ECG)","Exercise ECG","Mammography","Ultrasound - Breast","Magnetic Resonance Imaging (MRI) - Breast","Galactography (Ductography)","Ultrasound-Guided Breast Biopsy","Magnetic Resonance Imaging (MRI) - Head","X-ray (Radiography) - Upper GI Tract","X-ray (Radiography) - Lower GI Tract","Coronary Computed Tomography Angiography (CCTA)","Hysterosalpingography","Venography","Urography","Direct Arthrography","Pediatric Voiding Cystourethrogram","Angioplasty and Vascular Stenting","Biopsies - Overview","Catheter Embolization","Transarterial Chemoembolization (TACE)","Nerve Blocks","Radiofrequency Ablation (RFA) / Microwave Ablation (MWA) of Liver Tumors","General Nuclear Medicine","Positron Emission Tomography - Computed Tomography (PET/CT)","Magnetic Resonance Imaging (MRI)","Computed Tomography CT Scan","X-ray Scan","Ultrasound","Doppler ultrasound","Magnetic Resonance Imaging (MRI) - Abdomen and Pelvis","Magnetic Resonance Imaging (MRI) - Body","Magnetic Resonance Imaging (MRI) - Cardiac (Heart)","Magnetic Resonance Imaging (MRI) - Chest","Magnetic Resonance Imaging (MRI) - Dynamic Pelvic Floor","Magnetic Resonance Imaging (MRI) - Knee","Magnetic Resonance Imaging (MRI) - Musculoskeletal","Magnetic Resonance Imaging (MRI) - Prostate","Magnetic Resonance Imaging (MRI) - Shoulder","Magnetic Resonance Imaging (MRI) - Spine","Magnetic Resonance, Functional (fMRI) - Brain","MR Angiography (MRA)","MR Enterography","Computed Tomography (CT) - Abdomen and Pelvis","Computed Tomography (CT) - Sinuses","Computed Tomography (CT) - Spine","CT Enterography","Dental Cone Beam CT","Discography (Discogram)","Facet Joint Block","CT Perfusion of the Head","Myelography","Intravenous Pyelogram (IVP)","Fistulogram/Sinogram","X-ray (Radiography) - Abdomen","Pediatric X-ray (Radiography)"];

  var SubScans1 = const ["Rash at site of bite","Rashes on other parts of body","Basically circular rash","Generalized or spread out rash","Raised rash disappearing and reoccurring"];
  var SubScans2 = const ["Pressure in head","Headache mild or severe","Twitching of facial or other muscles","Facial paralysis (Bells Palsy)","Tingling of nose, tip of tongue","Cheek or facial flushing","Stiff or painful neck","Jaw pain or stiffness","Dental problems (unexplained)","Sore throat","Runny nose","Hoarseness","Clearing throat a lot (phlegm)","Double or blurry vision, increased floating spots","Pain in eyes or swelling around eyes","Sensitivity to light","Flashing lights, peripheral waves, phantom","images in corners of eyes","Unexplained hair loss","Seizures","White matter lesions in head (MRI)","Swollen glands"];
  var SubScans3 = const ["Decreased hearing in one or both ears","Plugged ears","Buzzing in ears","Pain in ears","Oversensitivity to sounds","Ringing in one or both ears"];
  var SubScans4 = const ["Diarrhea","Constipation","Irritable bladder (trouble starting or stopping) (interstitial cystitis)","Upset stomach (nausea or pain)","GERD (gastro esophageal reflux disease)","Bladder dysfunction","Change in bowel function","Hepatomegaly","Jaundice","enlargement of the spleen ‐ Splenomegaly","Abnormal Liver enzymes"];
  var SubScans5 = const ["Bone pain","Joint pain or swelling","Carpal Tunnel Syndrome","Muscle pain or cramps (Fibromyalgia)","Stiffness of back, joints, neck or tennis elbow","Papular or Angiomatous rash","Skin sensitivity","Myalgias"];
  var SubScans6 = const ["Shortness of breath","Cough","Chest pain or rib soreness","Night sweats or unexplained chills","Heart palpitations","Heart blockage","Endocarditis","Anemia","Can not get full satifying breath ‐ air hunger","Pulse skips","Myocarditis ‐ inflamation of the heart muscle","Cardiac imparment","Heart valve prolapse"];
  var SubScans7 = const ["Tremors or unexplained shaking","Fatigue","Chronic Fatigue Syndrome","Weakness, peripheral neuropathy","Partial paralysis","Numbness in body (tingling or pinpricks)","Burning or stabbing sensations in the body","Light headedness","Poor balance","Dizziness","Difficulty walking","Increased motion sickness","Mild Encephalopathy","Immune deficiency"];
  var SubScans8 = const ["Mood swings","Irritability","Bi‐Polar Disorder","Unusual depression","Disorientation (feeling or getting lost)","Feeling as if you are losing your mind","Overemotional reactions","Too much sleep","Insomnia","Difficulty falling or staying asleep","Sleep apnea (also known as Narcolepsy)","Panic attacks or anxiety","A strong desire to sleep ‐ somnolence"];
  var SubScans9 = const ["Memory loss (short or long term)","Confusion, difficulty in thinking","Difficulty with concentration or reading","Going to the wrong place","Slurred or slow speech","Stammering speech","Forgetting how to perform simple tasks","Difficulty writing","Difficulty finding words; name blocking","Problem absorbing new information"];
  var SubScans10 = const ["Loss of sex drive","Sexual dysfunction","Unexplained menstrual pain or irregularity","Unexplained breast pain or discharge","Testicular pain","Pelvic pain","Unexplained milk production"];
  var SubScans11 = const ["Unexplained weight gain or loss","Extreme fatigue","Poor stamina","Swollen glands or lymph nodes","Unexplained fevers, high or low‐grade","Continual infections (sinus, kidney, eye, etc.)","Scans seem to change, or come and go","Pain migrates to different parts of the body","Experienced a flu‐like illnesss, after which you","have not since felt well","Low body temperature","Allergies or chemical sensitivities","Increased effect from alcohol and possible worse hang‐over","Veritgo","Upset stomach"];
  var SubScans12 = const ["Immune deficiency","Lymphadenopathy","Weakened immune response","Persistent Leukopenia ‐ decreased white blood cells","Thrombocytopenia ‐ decrease of platelets in blood"];

  var _GeneralScans;
  String _GeneralScansTxt = "";
  var _SubScans;
  String _SubScansTxt = "";

  var ListData;
  var PageType; // false for view and true for edit
  final verticalScroll = ScrollController();

  String description = "";
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String? _content;
  XFile? _image = null;
  final picker = ImagePicker();


  @override
  void initState() {
    // TODO: implement initState

    PageType = widget.type;
    ListData = widget.Data;
    if (ListData != "") {
      LineSplitter ls = new LineSplitter();
      List<String> DataToDisplay = ls.convert(ListData);
      if (DataToDisplay.isEmpty) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                ScansPage(storage: ScansStorage())
            )
        );
      }
      else
        {
          DateController.text = DataToDisplay[0];
          _GeneralScansTxt = DataToDisplay[1];
          GeneralScanController.text = DataToDisplay[1];
          DescriptionController.text = DataToDisplay[2];
        }
      super.initState();
    }
  }


  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx("/Scans", type,storage: ImageStorage(),)));
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
          title: const Text('Scans',
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
                              child: PageType != false
                                  ? const Card(
                                  color: Color.fromRGBO(32, 116, 150, 1.0),
                                  shadowColor: Colors.grey,
                                  elevation: 4.0,
                                  margin: EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                  child: ListTile(
                                    title:Text("Edit Scan",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ) ,
                                  )
                              )
                                  :const Card(
                                  color: Color.fromRGBO(32, 116, 150, 1.0),
                                  shadowColor: Colors.grey,
                                  elevation: 4.0,
                                  margin: EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                  child: ListTile(
                                    title:Text("View Scan",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white,
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
                                enabled: PageType,
                                controller: DateController, //editing controller of this TextField
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.date_range), //icon of text field
                                  labelText: "Date",
                                  labelStyle: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
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
                              child: PageType != false
                                  ? DropdownButtonFormField(
                                isDense: true,
                                isExpanded: true,
                                items: GeneralScans.map((String Scan) {
                                  return  DropdownMenuItem(
                                    enabled: PageType,
                                    alignment: Alignment.centerLeft,
                                    value: Scan,
                                    child: Text(Scan,
                                        style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                          fontSize: 16,
                                          //fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  // do other stuff with _Scan
                                  _GeneralScans = newValue;
                                },
                                value: _GeneralScansTxt,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                                  filled: false,
                                  fillColor: Colors.grey[200],
                                  prefixIcon: const Icon(Icons.medical_services_outlined) ,
                                  hintText: 'Scans',
                                  helperText: 'Scans',
                                  hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  // errorText: 'Select Sub Scans',
                                ),
                              )
                                  :TextField(
                                enabled: PageType,
                                keyboardType: TextInputType.multiline,
                                controller: GeneralScanController,
                                onChanged: (value) {
                                  _GeneralScansTxt = value;
                                  //get value from textField
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Scan',
                                  labelStyle: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Icon(Icons.notes),
                                ),
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w500,
                                ),
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
                                enabled: PageType,
                                keyboardType: TextInputType.multiline,
                                controller: DescriptionController,
                                onChanged: (value) {
                                  description = value;
                                  //get value from textField
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Description',
                                  labelStyle: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Icon(Icons.notes),
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
                                PageType != false
                                 ? Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _handleURLButtonPress(context, ImageSourceType.camera);
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
                                )
                                :const Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1, child: Text('',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Color.fromRGBO(66, 133, 244, 1.0))
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

                                PageType != false
                                ? Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _handleURLButtonPress(context, ImageSourceType.gallery);
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
                                )
                                : const Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1, child: Text('',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Color.fromRGBO(66, 133, 244, 1.0))
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
                                  child: PageType != false
                                      ? const Text('Save')
                                  :const Text('Edit'),
                                  onPressed: ()  async {
                                    try {
                                      if (ListData != "") {
                                        LineSplitter ls = new LineSplitter();
                                        List<String> DataToDisplay = ls.convert(ListData);

                                        if(PageType != false)
                                        {

                                        }
                                        else
                                        {
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder:
                                                  (context) =>
                                                  EditViewScansPage(type: true, Data: DataToDisplay[0]+"\n"+DataToDisplay[1]+"\n"+DataToDisplay[2])
                                              )
                                          );
                                        }
                                      }

                                    } catch (e) {
                                      setState(() {
                                        showProgress = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Save Failed, Check Required Info.",
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






