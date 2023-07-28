import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Pages/EmergencyContacts.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/ImageFromGalleryEx.dart';


class AddEmergencyContacts extends StatefulWidget {
  final AddEmergencyContactsStorage storage;

  AddEmergencyContacts({Key? key, required this.storage}) : super(key: key);
  @override
  _AddEmergencyContactsState createState() => _AddEmergencyContactsState();
}

class _AddEmergencyContactsState extends State<AddEmergencyContacts>  {
  var LanguageData =0;

  var Title = ["Emergency Contacts","جهات اتصال للطوارئ",""];
  var AddDoctorTitle = ["Add Emergency Contact","اضافة جهة اتصال للطوارئ",""];
  var NameTitle = ["Name","الاسم",""];
  var CountryCodeTitle = ["Country Code","كود البلد",""];
  var PhoneNumberTitle = ["Phone Number","رقم التليفون",""];
  var RelationshipTitle = ["Relationship","العلاقة",""];
  var AddressTitle = ["Address","العنوان",""];
  var DescriptionTitle = ["Description","الوصف",""];
  var SaveBtnTitle = ["Save","حفظ",""];
  var SaveFailedTitle = ["Save Failed, Check Required Info.","فشل الحفظ ، تحقق من المعلومات المطلوبة.",""];


  TextEditingController DescriptionController = TextEditingController();
  TextEditingController PersonNameController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();

  final verticalScroll = ScrollController();

  var RelationsEmergencyContacts = const ["Doctor","father","mother","son","daughter","husband","wife","brother","sister","grandfather","grandmother","grandson","granddaughter","Spouse","Family Member"];
  var CountryCodes = ["Albania (+355)","Afghanistan (+93)","Åland Islands (+358 18)","Algeria (+213)","American Samoa (+1 684)","Andorra (+376)","Angola (+244)","Anguilla (+1 264)","Antigua and Barbuda (+1 268)","Argentina (+54)","Armenia (+374)","Aruba (+297)","Ascension (+247)","Australia (+61)","Australian Antarctic Territory (+672 1)","Australian External Territories (+672)","Austria (+43)","Azerbaijan (+994)","Bahamas (+1 242)","Bahrain (+973)","Bangladesh (+880)","Barbados (+1 246)","Barbuda (+1 268)","Belarus (+375)","Belgium (+32)","Belize (+501)","Benin (+229)","Bermuda (+1 441)","Bhutan (+975)","Bolivia (+591)","Bonaire (+599 7)","Bosnia and Herzegovina (+387)","Botswana (+267)","Brazil (+55)","British Indian Ocean Territory (+246)","British Virgin Islands (+1 284)","Brunei Darussalam (+673)","Bulgaria (+359)","Burkina Faso (+226)","Burundi (+257)","Cape Verde (+238)","Cambodia (+855)","Cameroon (+237)","Canada (+1)","Caribbean Netherlands (+599 3, 599 4, 599 7)","Cayman Islands (+1 345)","Central African Republic (+236)","Chad (+235)","Chatham Island, New Zealand (+64)","Chile (+56)","China (+86)","Christmas Island (+61 89164)","Cocos (Keeling) Islands (+61 89162)","Colombia (+57)","Comoros (+269)","Congo (+242)","Congo, Democratic Republic of the (+243)","Cook Islands (+682)","Costa Rica (+506)","Ivory Coast (Côte d’Ivoire) (+225)","Croatia (+385)","Cuba (+53)","Curaçao (+599 9)","Cyprus (+357)","Czech Republic (+420)","Denmark (+45)","Diego Garcia (+246)","Djibouti (+253)","Dominica (+1 767)","Dominican Republic (+1 809, 1 829,)"," (+1 849)","Easter Island (+56)","Ecuador (+593)","Egypt (+20)","El Salvador (+503)","Ellipso (Mobile Satellite service) (+881 2, 881 3)","EMSAT (Mobile Satellite service) (+882 13)","Equatorial Guinea (+240)","Eritrea (+291)","Estonia (+372)","Eswatini (+268)","Ethiopia (+251)","Falkland Islands (+500)","Faroe Islands (+298)","Fiji (+679)","Finland (+358)","France (+33)","French Antilles (+596)","French Guiana (+594)","French Polynesia (+689)","Gabon (+241)","Gambia (+220)","Georgia (+995)","Germany (+49)","Ghana (+233)","Gibraltar (+350)","Global Mobile Satellite System (GMSS) (+881)","Globalstar (Mobile Satellite Service) (+881 8, 881 9)","Greece (+30)","Greenland (+299)","Grenada (+1 473)","Guadeloupe (+590)","Guam (+1 671)","Guatemala (+502)","Guernsey (+44 1481, 44 7781,)"," (+44 7839, 44 7911)","Guinea (+224)","Guinea-Bissau (+245)","Guyana (+592)","Haiti (+509)","Honduras (+504)","Hong Kong (+852)","Hungary (+36)","Iceland (+354)","ICO Global (Mobile Satellite Service) (+881 0, 881 1)","India (+91)","Indonesia (+62)","Inmarsat SNAC (+870)","International Freephone Service (UIFN) (+800)","International Networks (+882, 883)","International Premium Rate Service (+979)","International Shared Cost Service (ISCS) (+808)","Iran (+98)","Iraq (+964)","Ireland (+353)","Iridium (Mobile Satellite service) (+881 6, 881 7)","Isle of Man (+44 1624, 44 7524,)"," (+44 7624, 44 7924)","Israel (+972)","Italy (+39)","Jamaica (+1 658 , 1 876,)","Jan Mayen (+47 79)","Japan (+81)","Jersey (+44 1534)","Jordan (+962)","Kazakhstan (+76, 7 7)","Kenya (+254)","Kiribati (+686)","Korea, North (+850)","Korea, South (+82)","Kosovo (+383)","Kuwait (+965)","Kyrgyzstan (+996)","Laos (+856)","Latvia (+371)","Lebanon (+961)","Lesotho (+266)","Liberia (+231)","Libya (+218)","Liechtenstein (+423)","Lithuania (+370)","Luxembourg (+352)","Macau (+853)","Madagascar (+261)","Malawi (+265)","Malaysia (+60)","Maldives (+960)","Mali (+223)","Malta (+356)","Marshall Islands (+692)","Martinique (+596)","Mauritania (+222)","Mauritius (+230)","Mayotte (+262 269, 262 639)","Mexico (+52)","Micronesia, Federated States of (+691)","Midway Island, USA (+1 808)","Moldova (+373)","Monaco (+377)","Mongolia (+976)","Montenegro (+382)","Montserrat (+1 664)","Morocco (+212)","Mozambique (+258)","Myanmar (+95)","Artsakh (+374 47, 374 97)","Namibia (+264)","Nauru (+674)","Nepal (+977)","Netherlands (+31)","Nevis (+1 869)","New Caledonia (+687)","New Zealand (+64)","Nicaragua (+505)","Niger (+227)","Nigeria (+234)","Niue (+683)","Norfolk Island (+6723)","North Macedonia (+389)","Northern Cyprus (+90 392)","Northern Ireland (+44 28)","Northern Mariana Islands (+1 670)","Norway (+47)","Oman (+968)","Pakistan (+92)","Palau (+680)","Palestine, State of (+970)","Panama (+507)","Papua New Guinea (+675)","Paraguay (+595)","Peru (+51)","Philippines (+63)","Pitcairn Islands (+64)","Poland (+48)","Portugal (+351)","Puerto Rico (+1 787, 1 939)","Qatar (+974)","Réunion (+262)","Romania (+40)","Russia (+7)","Rwanda (+250)","Saba (+5994)","Saint Barthélemy (+590)","Saint Helena (+290)","Saint Kitts and Nevis (+1869)","Saint Lucia (+1758)","Saint Martin (France) (+590)","Saint Pierre and Miquelon (+508)","Saint Vincent and the Grenadines (+1784)","Samoa (+685)","San Marino (+378)","São Tomé and Príncipe (+239)","Saudi Arabia (+966)","Senegal (+221)","Serbia (+381)","Seychelles (+248)","Sierra Leone (+232)","Singapore (+65)","Sint Eustatius (+599 3)","Sint Maarten (Netherlands) (+1 721)","Slovakia (+421)","Slovenia (+386)","Solomon Islands (+677)","Somalia (+252)","South Africa (+27)","South Georgia and the South Sandwich Islands (+500)","South Ossetia (+995 34)","South Sudan (+211)","Spain (+34)","Sri Lanka (+94)","Sudan (+249)","Suriname (+597)","Svalbard (+47 79)","Sweden (+46)","Switzerland (+41)","Syria (+963)","Taiwan (+886)","Tajikistan (+992)","Tanzania (+255)","Telecommunications for Disaster Relief by OCHA (+888)","Thailand (+66)","Thuraya (Mobile Satellite service) (+882 16)","East Timor (Timor-Leste) (+670)","Togo (+228)","Tokelau (+690)","Tonga (+676)","Transnistria (+373 2, 373 5)","Trinidad and Tobago (+1 868)","Tristan da Cunha (+290 8)","Tunisia (+216)","Turkey (+90)","Turkmenistan (+993)","Turks and Caicos Islands (+1 649)","Tuvalu (+688)","Uganda (+256)","Ukraine (+380)","United Arab Emirates (+971)","United Kingdom (+44)","United States (+1)","Universal Personal Telecommunications (UPT) (+878)","Uruguay (+598)","US Virgin Islands (+1 340)","Uzbekistan (+998)","Vanuatu (+678)"," Vatican City State (+39 06 698,)"," Vatican City State (+assigned 379)","Venezuela (+58)","Vietnam (+84)","Wake Island, USA (+1 808)","Wallis and Futuna (+681)","Yemen (+967)","Zambia (+260)","Zanzibar (+259)","Zimbabwe (+263)"];

  var _RelationsEmergencyContacts;

  String description = "";
  String PersonName = "";
  String Address = "";
  String Phone = "";
  String? _Country;
  String? _CountryCode;
  String? _PhoneNumber;
  String? _CountryAbreviation;

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

  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Directionality( // use this
        textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
        child: ImageFromGalleryEx("/EmergencyContacts", type,storage: ImageStorage(),),)));
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
                                    title:Text(AddDoctorTitle[LanguageData],
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
                                keyboardType: TextInputType.multiline,
                                controller: PersonNameController,
                                onChanged: (value) {
                                  PersonName = value;
                                  //get value from textField
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: NameTitle[LanguageData],
                                  labelStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: const Icon(Icons.account_box),
                                ),
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
                                items: RelationsEmergencyContacts.map((String EmergencyContact) {
                                  return  DropdownMenuItem(
                                    alignment: Alignment.centerLeft,
                                    value: EmergencyContact,
                                    child: Text(EmergencyContact,
                                        style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                          fontSize: 16,
                                          //fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  // do other stuff with _EmergencyContact
                                  _RelationsEmergencyContacts = newValue;
                                },
                                value: _RelationsEmergencyContacts,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                                  filled: false,
                                  fillColor: Colors.grey[200],
                                  prefixIcon: const Icon(Icons.volunteer_activism) ,
                                  hintText: RelationshipTitle[LanguageData],
                                  hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  // errorText: 'Select Sub EmergencyContacts',
                                ),
                              ),
                            ),



                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: IntlPhoneField(
                                showCountryFlag: true,
                                controller: PhoneController,
                                initialCountryCode: "US",
                                decoration: InputDecoration(
                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                  alignLabelWithHint: true,
                                  labelText: PhoneNumberTitle[LanguageData],
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                  suffixIcon: const Icon(Icons.phone_android),
                                ),
                                onSubmitted:(phone) {
                                  setState(() {
                                    _PhoneNumber = phone;
                                  });
                                } ,
                                onCountryChanged: (country) {
                                  setState(() {
                                    _CountryCode = "+"+country.dialCode;
                                    _CountryAbreviation = country.code;
                                    _Country = country.name;
                                  });
                                },
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                controller: AddressController,
                                onChanged: (value) {
                                  Address = value;
                                  //get value from textField
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: AddressTitle[LanguageData],
                                  labelStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: const Icon(Icons.add_location_alt_outlined),
                                ),
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w500,
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

                                      widget.storage._writeData(PersonNameController.text+"#"
                                          +_RelationsEmergencyContacts+"#"
                                          +_CountryCode.toString()+"-"+_PhoneNumber.toString()+"#"
                                          +_CountryAbreviation.toString()+"-"+_Country.toString()+"#"
                                          +AddressController.text+"#"
                                          +DescriptionController.text+"\n",
                                          "icare_EmergencyContacts");
                                      _image != null
                                          ?widget.storage._writeData(_image!.path+"\n", "icare_pictures")
                                          :widget.storage._writeData(""+"\n", "icare_pictures");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Directionality( // use this
                                                textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                child: EmergencyContactsPage(storage: EmergencyContactsStorage(), key: null,)),),
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


class AddEmergencyContactsStorage
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
