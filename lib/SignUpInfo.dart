import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icare/HomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'RequestDrivePermissions.dart';
import 'Widgets/ImageFromGalleryEx.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


String imagepath = "";
String BloodData = "No Data";
String AgeData = "No Data";
String GenderData = "No Data";
String BirthdateData = "No Data";
String ChrhealthData = "No Data";
String WeightData = "No Data";
String HeightData = "No Data";
String PhoneData = "No Data";
String CountryData = "No Data";
String FullnameData = "No Data";
String UsernameData = "No Data";
String ImageData = "No Data";
String ImageType = "Local";

class SignUpInfoPage extends StatefulWidget {
  final ProfileInfoStorage storage;

  SignUpInfoPage({Key? key, required this.storage}) : super(key: key);

  @override
  _SignUpInfoPageState createState() => _SignUpInfoPageState();
}

class _SignUpInfoPageState extends State<SignUpInfoPage> {

  final verticalScroll = ScrollController();

  TextEditingController WeightController = TextEditingController();
  TextEditingController BirthDateController = TextEditingController();
  TextEditingController AgeController = TextEditingController();
  TextEditingController HeightController = TextEditingController();
  TextEditingController ChrHealthController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController FullNameController = TextEditingController();
  TextEditingController UserNameController = TextEditingController();

  var BloodTypes = const ["A+","A-","B+","B-","AB+","AB-","O+","O-"];
  var Countries = const ["Albania","Afghanistan","Åland Islands","Algeria","American Samoa","Andorra","Angola","Anguilla","Antigua and Barbuda","Argentina","Armenia","Aruba","Ascension","Australia","Australian Antarctic Territory","Australian External Territories","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Barbuda","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bonaire","Bosnia and Herzegovina","Botswana","Brazil","British Indian Ocean Territory","British Virgin Islands","Brunei Darussalam","Bulgaria","Burkina Faso","Burundi","Cape Verde","Cambodia","Cameroon","Canada","Caribbean Netherlands","Cayman Islands","Central African Republic","Chad","Chatham Island, New Zealand","Chile","China","Christmas Island","Cocos (Keeling) Islands","Colombia","Comoros","Congo","Congo, Democratic Republic of the","Cook Islands","Costa Rica","Ivory Coast (Côte d’Ivoire)","Croatia","Cuba","Curaçao","Cyprus","Czech Republic","Denmark","Diego Garcia","Djibouti","Dominica","Dominican Republic","","Easter Island","Ecuador","Egypt","El Salvador","Ellipso (Mobile Satellite service)","EMSAT (Mobile Satellite service)","Equatorial Guinea","Eritrea","Estonia","Eswatini","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Antilles","French Guiana","French Polynesia","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Global Mobile Satellite System (GMSS)","Globalstar (Mobile Satellite Service)","Greece","Greenland","Grenada","Guadeloupe","Guam","Guatemala","Guernsey","","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","ICO Global (Mobile Satellite Service)","India","Indonesia","Inmarsat SNAC","International Freephone Service (UIFN)","International Networks","International Premium Rate Service","International Shared Cost Service (ISCS)","Iran","Iraq","Ireland","Iridium (Mobile Satellite service)","Isle of Man","","Israel","Italy","Jamaica","Jan Mayen","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kiribati","Korea, North","Korea, South","Kosovo","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Martinique","Mauritania","Mauritius","Mayotte","Mexico","Micronesia, Federated States of","Midway Island, USA","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Myanmar","Artsakh","Namibia","Nauru","Nepal","Netherlands","Nevis","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Niue","Norfolk Island","North Macedonia","Northern Cyprus","Northern Ireland","Northern Mariana Islands","Norway","Oman","Pakistan","Palau","Palestine, State of","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Pitcairn Islands","Poland","Portugal","Puerto Rico","Qatar","Réunion","Romania","Russia","Rwanda","Saba","Saint Barthélemy","Saint Helena","Saint Kitts and Nevis","Saint Lucia","Saint Martin (France)","Saint Pierre and Miquelon","Saint Vincent and the Grenadines","Samoa","San Marino","São Tomé and Príncipe","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Sint Eustatius","Sint Maarten (Netherlands)","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Georgia and the South Sandwich Islands","South Ossetia","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Svalbard","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Telecommunications for Disaster Relief by OCHA","Thailand","Thuraya (Mobile Satellite service)","East Timor (Timor-Leste)","Togo","Tokelau","Tonga","Transnistria","Trinidad and Tobago","Tristan da Cunha","Tunisia","Turkey","Turkmenistan","Turks and Caicos Islands","Tuvalu","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States","Universal Personal Telecommunications (UPT)","Uruguay","US Virgin Islands","Uzbekistan","Vanuatu","Vatican City State","Vatican City State","Venezuela","Vietnam","Wake Island, USA","Wallis and Futuna","Yemen","Zambia","Zanzibar","Zimbabwe"];
  var CountryCodes = ["Albania (+355)","Afghanistan (+93)","Åland Islands (+358 18)","Algeria (+213)","American Samoa (+1 684)","Andorra (+376)","Angola (+244)","Anguilla (+1 264)","Antigua and Barbuda (+1 268)","Argentina (+54)","Armenia (+374)","Aruba (+297)","Ascension (+247)","Australia (+61)","Australian Antarctic Territory (+672 1)","Australian External Territories (+672)","Austria (+43)","Azerbaijan (+994)","Bahamas (+1 242)","Bahrain (+973)","Bangladesh (+880)","Barbados (+1 246)","Barbuda (+1 268)","Belarus (+375)","Belgium (+32)","Belize (+501)","Benin (+229)","Bermuda (+1 441)","Bhutan (+975)","Bolivia (+591)","Bonaire (+599 7)","Bosnia and Herzegovina (+387)","Botswana (+267)","Brazil (+55)","British Indian Ocean Territory (+246)","British Virgin Islands (+1 284)","Brunei Darussalam (+673)","Bulgaria (+359)","Burkina Faso (+226)","Burundi (+257)","Cape Verde (+238)","Cambodia (+855)","Cameroon (+237)","Canada (+1)","Caribbean Netherlands (+599 3, 599 4, 599 7)","Cayman Islands (+1 345)","Central African Republic (+236)","Chad (+235)","Chatham Island, New Zealand (+64)","Chile (+56)","China (+86)","Christmas Island (+61 89164)","Cocos (Keeling) Islands (+61 89162)","Colombia (+57)","Comoros (+269)","Congo (+242)","Congo, Democratic Republic of the (+243)","Cook Islands (+682)","Costa Rica (+506)","Ivory Coast (Côte d’Ivoire) (+225)","Croatia (+385)","Cuba (+53)","Curaçao (+599 9)","Cyprus (+357)","Czech Republic (+420)","Denmark (+45)","Diego Garcia (+246)","Djibouti (+253)","Dominica (+1 767)","Dominican Republic (+1 809, 1 829,)"," (+1 849)","Easter Island (+56)","Ecuador (+593)","Egypt (+20)","El Salvador (+503)","Ellipso (Mobile Satellite service) (+881 2, 881 3)","EMSAT (Mobile Satellite service) (+882 13)","Equatorial Guinea (+240)","Eritrea (+291)","Estonia (+372)","Eswatini (+268)","Ethiopia (+251)","Falkland Islands (+500)","Faroe Islands (+298)","Fiji (+679)","Finland (+358)","France (+33)","French Antilles (+596)","French Guiana (+594)","French Polynesia (+689)","Gabon (+241)","Gambia (+220)","Georgia (+995)","Germany (+49)","Ghana (+233)","Gibraltar (+350)","Global Mobile Satellite System (GMSS) (+881)","Globalstar (Mobile Satellite Service) (+881 8, 881 9)","Greece (+30)","Greenland (+299)","Grenada (+1 473)","Guadeloupe (+590)","Guam (+1 671)","Guatemala (+502)","Guernsey (+44 1481, 44 7781,)"," (+44 7839, 44 7911)","Guinea (+224)","Guinea-Bissau (+245)","Guyana (+592)","Haiti (+509)","Honduras (+504)","Hong Kong (+852)","Hungary (+36)","Iceland (+354)","ICO Global (Mobile Satellite Service) (+881 0, 881 1)","India (+91)","Indonesia (+62)","Inmarsat SNAC (+870)","International Freephone Service (UIFN) (+800)","International Networks (+882, 883)","International Premium Rate Service (+979)","International Shared Cost Service (ISCS) (+808)","Iran (+98)","Iraq (+964)","Ireland (+353)","Iridium (Mobile Satellite service) (+881 6, 881 7)","Isle of Man (+44 1624, 44 7524,)"," (+44 7624, 44 7924)","Israel (+972)","Italy (+39)","Jamaica (+1 658 , 1 876,)","Jan Mayen (+47 79)","Japan (+81)","Jersey (+44 1534)","Jordan (+962)","Kazakhstan (+76, 7 7)","Kenya (+254)","Kiribati (+686)","Korea, North (+850)","Korea, South (+82)","Kosovo (+383)","Kuwait (+965)","Kyrgyzstan (+996)","Laos (+856)","Latvia (+371)","Lebanon (+961)","Lesotho (+266)","Liberia (+231)","Libya (+218)","Liechtenstein (+423)","Lithuania (+370)","Luxembourg (+352)","Macau (+853)","Madagascar (+261)","Malawi (+265)","Malaysia (+60)","Maldives (+960)","Mali (+223)","Malta (+356)","Marshall Islands (+692)","Martinique (+596)","Mauritania (+222)","Mauritius (+230)","Mayotte (+262 269, 262 639)","Mexico (+52)","Micronesia, Federated States of (+691)","Midway Island, USA (+1 808)","Moldova (+373)","Monaco (+377)","Mongolia (+976)","Montenegro (+382)","Montserrat (+1 664)","Morocco (+212)","Mozambique (+258)","Myanmar (+95)","Artsakh (+374 47, 374 97)","Namibia (+264)","Nauru (+674)","Nepal (+977)","Netherlands (+31)","Nevis (+1 869)","New Caledonia (+687)","New Zealand (+64)","Nicaragua (+505)","Niger (+227)","Nigeria (+234)","Niue (+683)","Norfolk Island (+6723)","North Macedonia (+389)","Northern Cyprus (+90 392)","Northern Ireland (+44 28)","Northern Mariana Islands (+1 670)","Norway (+47)","Oman (+968)","Pakistan (+92)","Palau (+680)","Palestine, State of (+970)","Panama (+507)","Papua New Guinea (+675)","Paraguay (+595)","Peru (+51)","Philippines (+63)","Pitcairn Islands (+64)","Poland (+48)","Portugal (+351)","Puerto Rico (+1 787, 1 939)","Qatar (+974)","Réunion (+262)","Romania (+40)","Russia (+7)","Rwanda (+250)","Saba (+5994)","Saint Barthélemy (+590)","Saint Helena (+290)","Saint Kitts and Nevis (+1869)","Saint Lucia (+1758)","Saint Martin (France) (+590)","Saint Pierre and Miquelon (+508)","Saint Vincent and the Grenadines (+1784)","Samoa (+685)","San Marino (+378)","São Tomé and Príncipe (+239)","Saudi Arabia (+966)","Senegal (+221)","Serbia (+381)","Seychelles (+248)","Sierra Leone (+232)","Singapore (+65)","Sint Eustatius (+599 3)","Sint Maarten (Netherlands) (+1 721)","Slovakia (+421)","Slovenia (+386)","Solomon Islands (+677)","Somalia (+252)","South Africa (+27)","South Georgia and the South Sandwich Islands (+500)","South Ossetia (+995 34)","South Sudan (+211)","Spain (+34)","Sri Lanka (+94)","Sudan (+249)","Suriname (+597)","Svalbard (+47 79)","Sweden (+46)","Switzerland (+41)","Syria (+963)","Taiwan (+886)","Tajikistan (+992)","Tanzania (+255)","Telecommunications for Disaster Relief by OCHA (+888)","Thailand (+66)","Thuraya (Mobile Satellite service) (+882 16)","East Timor (Timor-Leste) (+670)","Togo (+228)","Tokelau (+690)","Tonga (+676)","Transnistria (+373 2, 373 5)","Trinidad and Tobago (+1 868)","Tristan da Cunha (+290 8)","Tunisia (+216)","Turkey (+90)","Turkmenistan (+993)","Turks and Caicos Islands (+1 649)","Tuvalu (+688)","Uganda (+256)","Ukraine (+380)","United Arab Emirates (+971)","United Kingdom (+44)","United States (+1)","Universal Personal Telecommunications (UPT) (+878)","Uruguay (+598)","US Virgin Islands (+1 340)","Uzbekistan (+998)","Vanuatu (+678)"," Vatican City State (+39 06 698,)"," Vatican City State (+assigned 379)","Venezuela (+58)","Vietnam (+84)","Wake Island, USA (+1 808)","Wallis and Futuna (+681)","Yemen (+967)","Zambia (+260)","Zanzibar (+259)","Zimbabwe (+263)"];
  var Genders = const ["Male","Female","Unspecified"];
  // var CountryCodes = const["+93 --- Afghanistan","+355 --- Albania","+213 --- Algeria","+684 --- American Samoa","+376 --- Andorra","+244 --- Angola","+809 --- Anguilla","+268 --- Antigua","+54 --- Argentina","+374 --- Armenia","+297 --- Aruba","+247 --- Ascension Island","+61 --- Australia","+672 --- Australian External Territories","+43 --- Austria","+994 --- Azerbaijan","+242 --- Bahamas","+246 --- Barbados","+973 --- Bahrain","+880 --- Bangladesh","+375 --- Belarus","+32 --- Belgium","+501 --- Belize","+229 --- Benin","+809 --- Bermuda","+975 --- Bhutan","+284 --- British Virgin Islands","+591 --- Bolivia","+387 --- Bosnia and Hercegovina","+267 --- Botswana","+55 --- Brazil","+284 --- British V.I.","+673 --- Brunei Darussalm","+359 --- Bulgaria","+226 --- Burkina Faso","+257 --- Burundi","+855 --- Cambodia","+237 --- Cameroon","+1 --- Canada","+238 --- CapeVerde Islands","+1 --- Caribbean Nations","+345 --- Cayman Islands","+238 --- Cape Verdi","+236 --- Central African Republic","+235 --- Chad","+56 --- Chile","+86 --- China (People's Republic)","+886 --- China-Taiwan","+57 --- Colombia","+269 --- Comoros and Mayotte","+242 --- Congo","+682 --- Cook Islands","+506 --- Costa Rica","+385 --- Croatia","+53 --- Cuba","+357 --- Cyprus","+420 --- Czech Republic","+45 --- Denmark","+246 --- Diego Garcia","+767 --- Dominca","+809 --- Dominican Republic","+253 --- Djibouti","+593 --- Ecuador","+20 --- Egypt","+503 --- El Salvador","+240 --- Equatorial Guinea","+291 --- Eritrea","+372 --- Estonia","+251 --- Ethiopia","+500 --- Falkland Islands","+298 --- Faroe (Faeroe) Islands (Denmark)","+679 --- Fiji","+358 --- Finland","+33 --- France","+596 --- French Antilles","+594 --- French Guiana","+241 --- Gabon (Gabonese Republic)","+220 --- Gambia","+995 --- Georgia","+49 --- Germany","+233 --- Ghana","+350 --- Gibraltar","+30 --- Greece","+299 --- Greenland","+473 --- Grenada/Carricou","+671 --- Guam","+502 --- Guatemala","+224 --- Guinea","+245 --- Guinea-Bissau","+592 --- Guyana","+509 --- Haiti","+504 --- Honduras","+852 --- Hong Kong","+36 --- Hungary","+354 --- Iceland","+91 --- India","+62 --- Indonesia","+98 --- Iran","+964 --- Iraq","+353 --- Ireland (Irish Republic; Eire)","+972 --- Israel","+39 --- Italy","+225 --- Ivory Coast (La Cote d'Ivoire)","+876 --- Jamaica","+81 --- Japan","+962 --- Jordan","+7 --- Kazakhstan","+254 --- Kenya","+855 --- Khmer Republic (Cambodia/Kampuchea)","+686 --- Kiribati Republic (Gilbert Islands)","+82 --- Korea, Republic of (South Korea)","+850 --- Korea, People's Republic of (North Korea)","+965 --- Kuwait","+996 --- Kyrgyz Republic","+371 --- Latvia","+856 --- Laos","+961 --- Lebanon","+266 --- Lesotho","+231 --- Liberia","+370 --- Lithuania","+218 --- Libya","+423 --- Liechtenstein","+352 --- Luxembourg","+853 --- Macao","+389 --- Macedonia","+261 --- Madagascar","+265 --- Malawi","+60 --- Malaysia","+960 --- Maldives","+223 --- Mali","+356 --- Malta","+692 --- Marshall Islands","+596 --- Martinique (French Antilles)","+222 --- Mauritania","+230 --- Mauritius","+269 --- Mayolte","+52 --- Mexico","+691 --- Micronesia (F.S. of Polynesia)","+373 --- Moldova","+33 --- Monaco","+976 --- Mongolia","+473 --- Montserrat","+212 --- Morocco","+258 --- Mozambique","+95 --- Myanmar (former Burma)","+264 --- Namibia (former South-West Africa)","+674 --- Nauru","+977 --- Nepal","+31 --- Netherlands","+599 --- Netherlands Antilles","+869 --- Nevis","+687 --- New Caledonia","+64 --- New Zealand","+505 --- Nicaragua","+227 --- Niger","+234 --- Nigeria","+683 --- Niue","+850 --- North Korea","+1 670 --- North Mariana Islands (Saipan)","+47 --- Norway","+968 --- Oman","+92 --- Pakistan","+680 --- Palau","+507 --- Panama","+675 --- Papua New Guinea","+595 --- Paraguay","+51 --- Peru","+63 --- Philippines","+48 --- Poland","+351 --- Portugal (includes Azores)","+1 787 --- Puerto Rico","+974 --- Qatar","+262 --- Reunion (France)","+40 --- Romania","+7 --- Russia","+250 --- Rwanda (Rwandese Republic)","+670 --- Saipan","+378 --- San Marino","+239 --- Sao Tome and Principe","+966 --- Saudi Arabia","+221 --- Senegal","+381 --- Serbia and Montenegro","+248 --- Seychelles","+232 --- Sierra Leone","+65 --- Singapore","+421 --- Slovakia","+386 --- Slovenia","+677 --- Solomon Islands","+252 --- Somalia","+27 --- South Africa","+34 --- Spain","+94 --- Sri Lanka","+290 --- St. Helena","+869 --- St. Kitts/Nevis","+508 --- St. Pierre &(et) Miquelon (France)","+249 --- Sudan","+597 --- Suriname","+268 --- Swaziland","+46 --- Sweden","+41 --- Switzerland","+963 --- Syrian Arab Republic (Syria)","+689 --- Tahiti (French Polynesia)","+886 --- Taiwan","+7 --- Tajikistan","+255 --- Tanzania (includes Zanzibar)","+66 --- Thailand","+228 --- Togo (Togolese Republic)","+690 --- Tokelau","+676 --- Tonga","+1 868 --- Trinidad and Tobago","+216 --- Tunisia","+90 --- Turkey","+993 --- Turkmenistan","+688 --- Tuvalu (Ellice Islands)","+256 --- Uganda","+380 --- Ukraine","+971 --- United Arab Emirates","+44 --- United Kingdom","+598 --- Uruguay","+1 --- USA","+7 --- Uzbekistan","+678 --- Vanuatu (New Hebrides)","+39 --- Vatican City","+58 --- Venezuela","+84 --- Viet Nam","+1 340 --- Virgin Islands","+681 --- Wallis and Futuna","+685 --- Western Samoa","+381 --- Yemen (People's Democratic Republic of)","+967 --- Yemen Arab Republic (North Yemen)","+381 --- Yugoslavia (discontinued)","+243 --- Zaire","+260 --- Zambia","+263 --- Zimbabwe"];
  //var CountryCodes = const["+93","+355","+213","+684","+376","+244","+809","+268","+54","+374","+297","+247","+61","+672","+43","+994","+242","+246","+973","+880","+375","+32","+501","+229","+809","+975","+284","+591","+387","+267","+55","+284","+673","+359","+226","+257","+855","+237","+1","+238","+1","+345","+238","+236","+235","+56","+86","+886","+57","+269","+242","+682","+506","+385","+53","+357","+420","+45","+246","+767","+809","+253","+593","+20","+503","+240","+291","+372","+251","+500","+298","+679","+358","+33","+596","+594","+241","+220","+995","+49","+233","+350","+30","+299","+473","+671","+502","+224","+245","+592","+509","+504","+852","+36","+354","+91","+62","+98","+964","+353","+972","+39","+225","+876","+81","+962","+7","+254","+855","+686","+82","+850","+965","+996","+371","+856","+961","+266","+231","+370","+218","+423","+352","+853","+389","+261","+265","+60","+960","+223","+356","+692","+596","+222","+230","+269","+52","+691","+373","+33","+976","+473","+212","+258","+95","+264","+674","+977","+31","+599","+869","+687","+64","+505","+227","+234","+683","+850","+1","+47","+968","+92","+680","+507","+675","+595","+51","+63","+48","+351","+1","+974","+262","+40","+7","+250","+670","+378","+239","+966","+221","+381","+248","+232","+65","+421","+386","+677","+252","+27","+34","+94","+290","+869","+508","+249","+597","+268","+46","+41","+963","+689","+886","+7","+255","+66","+228","+690","+676","+1","+216","+90","+993","+688","+256","+380","+971","+44","+598","+1","+7","+678","+39","+58","+84","+1","+681","+685","+381","+967","+381","+243","+260","+263"];

  var _BloodTypes;
  var _Countries;
  String? _Country;
  String? _CountryCode;
  String? _PhoneNumber;
  String? _CountryAbreviation;
  var _Genders;
  var _Age;

  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  late String weight, birthdate,age,height,PhoneNumber,CountryCode,CountryName,CountryAbreviation,chrhealth;
  late String fullname, username;
  String? _content;
  XFile? _image = null;

  final picker = ImagePicker();
  var DrivePermission = "false";

  var imagePicker;
  Future<void> _getDirPath(var type) async {
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile imagefile = await imagePicker.pickImage(
        source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = imagefile;
      ImageData = _image!.path;
    });
  }

  @override
  void initState() {
    imagePicker = new ImagePicker();

    // TODO: implement initState
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

    widget.storage._readData("icare_phone").then((String value) async{
      if(value != "No Data" && value != "")
      {
        List<String> result =  value.split('-');
        setState(() {
          _PhoneNumber = result[1];
          PhoneController.text = result[1];
          PhoneData = value;
        });

      }
      else
      {
        setState(() {
          PhoneController.text = "";
          _PhoneNumber = "";
        });
      }

    });

    widget.storage._readData("icare_country").then((String value) async{
      if(value != "No Data" && value != "")
      {
        List<String> result =  value.split('-');
        setState(() {
          _CountryAbreviation = result[0];
          CountryData = value;
        });

      }
      else
      {
        setState(() {

          CountryData = "No Data";
        });
      }

    });

    widget.storage._readData("icare_bloodtype").then((String value) async{
      if(value != "No Data" && value != "")
      {
        setState(() {
          _BloodTypes = value;
          BloodData = value;
        });

      }
      else
      {
        setState(() {
          BloodData = "No Data";
        });
      }

    });


    // widget.storage._readData("icare_age").then((String value) async{
    //   if(value != "No Data" && value != "")
    //   {
    //     setState(() {
    //       AgeController.text = value;
    //       AgeData = value;
    //     });
    //
    //   }
    //   else
    //   {
    //     setState(() {
    //       AgeData = "No Data";
    //     });
    //   }
    //
    // });

    widget.storage._readData("icare_gender").then((String value) async{
      if(value != "No Data" && value != "")
      {
        setState(() {
          _Genders = value;
          GenderData = value;
        });

      }
      else
      {
        setState(() {
          GenderData = "No Data";
        });
      }

    });

    widget.storage._readData("icare_birthdate").then((String value) async{
      if(value != "No Data" && value != "")
      {
        setState(() {
          BirthDateController.text = value;
          BirthdateData = value;
        });

      }
      else
      {
        setState(() {
          BirthdateData = "No Data";
        });
      }

    });

    widget.storage._readData("icare_chrhealth").then((String value) async{
      if(value != "No Data" && value != "")
      {
        setState(() {
          ChrHealthController.text = value;
          ChrhealthData = value;
        });

      }
      else
      {
        setState(() {
          ChrhealthData = "No Data";
        });
      }

    });

    widget.storage._readData("icare_weight").then((String value) async{
      if(value != "No Data" && value != "")
      {
        setState(() {
          WeightController.text = value;
          WeightData = value;
        });

      }
      else
      {
        setState(() {
          WeightData = "No Data";
        });
      }

    });

    widget.storage._readData("icare_height").then((String value) async{
      if(value != "No Data" && value != "")
      {
        setState(() {
          HeightController.text = value;
          HeightData = value;
        });

      }
      else
      {
        setState(() {
          HeightData = "No Data";
        });
      }

    });


    widget.storage._readData("icare_fullname").then((String value) async{
      if(value != "No Data" && value != "")
      {
        setState(() {
          FullNameController.text = value;
          FullnameData = value;
        });

      }
      else
      {
        setState(() {
          FullnameData = "No Data";
        });
      }

    });


    widget.storage._readData("icare_username").then((String value) async{
      if(value != "No Data" && value != "")
      {
        setState(() {
          UserNameController.text = value;
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

    super.initState();


  }


  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx("", type,storage: ImageStorage(),)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/signup_login.png'),
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

                const SizedBox(
                  height: 160.0,
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
                          child:  const Card(
                              color: Color.fromRGBO(32, 116, 150, 1.0),
                              shadowColor: Colors.grey,
                              elevation: 4.0,
                              margin: EdgeInsets.only(top:0.0,left:0.0,bottom:0.0,right:0.0),
                              child: ListTile(
                                title:Text("Profile Information",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ) ,
                              )
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextField(
                            controller: FullNameController,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              fullname = value; // get value from TextField
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Full Name **',
                              labelStyle: TextStyle(color: Color.fromRGBO(
                                  103, 103, 103, 1.0),
                                fontSize: 16,),
                              prefixIcon: Icon(Icons.account_box_outlined),
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: TextField(
                            controller: UserNameController,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              username = value; // get value from TextField
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'User Name **',
                              labelStyle: TextStyle(color: Color.fromRGBO(
                                  103, 103, 103, 1.0),
                                fontSize: 16,),
                              prefixIcon: Icon(Icons.account_circle),
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
                              child: ImageType != "Network"
                                  ?ElevatedButton.icon(
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
                              )
                                  :const SizedBox(width: 20.0),
                            ),
                            const SizedBox(width: 10.0),
                            // Profile Picture
                            Container(
                              padding: const EdgeInsets.only(top: 5.0),
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
                            const SizedBox(width: 10.0),
                            Expanded(
                              // optional flex property if flex is 1 because the default flex is 1
                              flex: 1,
                              child: ImageType != "Network"
                                  ?ElevatedButton.icon(
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
                              )
                                  :const SizedBox(width: 20.0),
                            ),
                            const SizedBox(width: 20.0),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child:TextField(
                            controller: BirthDateController, //editing controller of this TextField
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.date_range), //icon of text field
                              labelText: "Birth Date",
                              labelStyle: TextStyle(color: Color.fromRGBO(
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
                                BirthDateController.text =  outputDate.toString();
                                setState(() {
                                  BirthDateController.text = outputDate.toString();
                                  _Age = (DateTime.now().year - int.parse(outputDate.toString().split("/")[2])).toString();//set output date to TextField value.
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
                          child:DropdownButtonFormField(
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
                              contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 17),
                              filled: false,
                              fillColor: Colors.grey[200],
                              prefixIcon: const Icon(Icons.merge_type) ,
                              hintText: "Gender**",
                              hintStyle: const TextStyle(
                                // color: Color.fromRGBO(32, 116, 150, 1.0),
                                fontSize: 16,
                                //fontWeight: FontWeight.w500,
                              ),
                              // errorText: 'Select Sub Prescriptions',
                            ),
                          ),
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: <Widget>[
                        //     const SizedBox(width: 20.0),
                        //     Expanded(
                        //       // optional flex property if flex is 1 because the default flex is 1
                        //       flex: 3,
                        //       child: DropdownButtonFormField(
                        //         isDense: true,
                        //         isExpanded: true,
                        //         items: Genders.map((String Value) {
                        //           return  DropdownMenuItem(
                        //             alignment: Alignment.centerLeft,
                        //             value: Value,
                        //             child: Text(Value,
                        //                 style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                        //                   fontSize: 16,
                        //                   //fontWeight: FontWeight.w500,
                        //                 ),
                        //                 overflow: TextOverflow.ellipsis
                        //             ),
                        //           );
                        //         }).toList(),
                        //         onChanged: (newValue) {
                        //           // do other stuff with _Prescription
                        //           _Genders = newValue;
                        //         },
                        //         value: _Genders,
                        //         decoration: InputDecoration(
                        //           border: const OutlineInputBorder(),
                        //           contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 17),
                        //           filled: false,
                        //           fillColor: Colors.grey[200],
                        //           prefixIcon: const Icon(Icons.merge_type) ,
                        //           hintText: GenderTitle[LanguageData],
                        //           hintStyle: const TextStyle(
                        //             // color: Color.fromRGBO(32, 116, 150, 1.0),
                        //             fontSize: 16,
                        //             //fontWeight: FontWeight.w500,
                        //           ),
                        //           // errorText: 'Select Sub Prescriptions',
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 10.0),
                        //     Expanded(
                        //       // optional flex property if flex is 1 because the default flex is 1
                        //       flex: 2,
                        //       child: TextField(
                        //         controller: AgeController,
                        //         keyboardType: TextInputType.number,
                        //         onChanged: (value) {
                        //           age = value; //get value from textField
                        //         },
                        //         decoration: InputDecoration(
                        //           border: const OutlineInputBorder(),
                        //           labelText: AgeTitle[LanguageData],
                        //           prefixIcon: const Icon(Icons.view_agenda_outlined),
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 20.0),
                        //   ],
                        // ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                              contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 17),
                              filled: false,
                              fillColor: Colors.grey[200],
                              prefixIcon: const Icon(Icons.bloodtype) ,
                              hintText: "Blood Type**",
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
                            const SizedBox(width: 20.0),
                            Expanded(
                              // optional flex property if flex is 1 because the default flex is 1
                              flex: 1,
                              child: TextField(
                                controller: WeightController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  weight = value; //get value from textField
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Weight**",
                                  prefixIcon: Icon(Icons.line_weight),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              // optional flex property if flex is 1 because the default flex is 1
                              flex: 1,
                              child: TextField(
                                controller: HeightController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  height = value; //get value from textField
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Height**",
                                  prefixIcon: Icon(Icons.height),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20.0),
                          ],
                        ),

                        // Container(
                        //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        //   child:  DropdownSearch<String>(
                        //     popupProps: const PopupProps.dialog(
                        //       showSelectedItems: true,
                        //       showSearchBox: true,
                        //       // disabledItemFn: (String s) => s.startsWith('I'),
                        //     ),
                        //     items: Countries,
                        //       dropdownDecoratorProps: DropDownDecoratorProps(
                        //         dropdownSearchDecoration: InputDecoration(
                        //       border: const OutlineInputBorder(),
                        //       contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                        //       filled: false,
                        //       // prefixIcon: Icon(Icons.settings_overscan) ,
                        //       labelText: CountryTitle[LanguageData],
                        //       hintText: CountryTitle[LanguageData],
                        //       hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                        //         fontSize: 12,
                        //         //fontWeight: FontWeight.w500,
                        //       ),
                        //       // errorText: 'Select Sub Prescriptions',
                        //     ),
                        //       ),
                        //     onChanged: (newValue) {
                        //       // do other stuff with _Prescription
                        //       _Countries = newValue;
                        //     },
                        //     //show selected item
                        //     selectedItem: _Countries,
                        //   )
                        //
                        //
                        // ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: IntlPhoneField(
                            showCountryFlag: true,
                            controller: PhoneController,
                            initialValue: _PhoneNumber ,
                            initialCountryCode: _CountryAbreviation,
                            decoration: const InputDecoration(
                              floatingLabelAlignment: FloatingLabelAlignment.center,
                              alignLabelWithHint: true,
                              labelText: "** Country & Phone Number",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              suffixIcon: Icon(Icons.phone_android),
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

                        // const SizedBox(
                        //   height: 10.0,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     const SizedBox(width: 20.0),
                        //     Expanded(
                        //       // optional flex property if flex is 1 because the default flex is 1
                        //       flex: 1,
                        //       child: PhoneNumberInput(
                        //         initialCountry: 'TN',
                        //         locale: 'ar',
                        //         controller: PhoneNumberInputController(
                        //           context,
                        //         ),
                        //         countryListMode: CountryListMode.dialog,
                        //         contactsPickerPosition: ContactsPickerPosition.suffix,
                        //         enabledBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(10),
                        //             borderSide: const BorderSide(color: Colors.purple)),
                        //         focusedBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(10),
                        //             borderSide: const BorderSide(color: Colors.purple)),
                        //         errorText: 'error',
                        //       ),
                        //     ),
                        //     const SizedBox(width: 10.0),
                        //     Expanded(
                        //       // optional flex property if flex is 1 because the default flex is 1
                        //       flex: 1,
                        //       child: TextField(
                        //         controller: PhoneController,
                        //         keyboardType: TextInputType.phone,
                        //         onChanged: (value) {
                        //           phone = value; //get value from textField
                        //         },
                        //         decoration: InputDecoration(
                        //           border: const OutlineInputBorder(),
                        //           labelText: PhoneNumberTitle[LanguageData],
                        //           prefixIcon: const Icon(Icons.phone_android),
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 20.0),
                        //   ],
                        // ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: TextField(
                            controller: ChrHealthController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              chrhealth = value; //get value from textField
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Chronic Health Condition',
                              prefixIcon: Icon(Icons.health_and_safety),
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
                              child: const Text('Save'),
                              onPressed: ()  async {
                                try {
                                  if(FullNameController.text != "" && UserNameController.text != "" && BirthDateController.text != ""
                                      && _BloodTypes != "" && _Genders != ""
                                      && WeightController.text != "" && HeightController.text != "" &&_CountryCode.toString() !="" &&_PhoneNumber.toString() !=""
                                      &&_CountryAbreviation.toString() !="" &&_Country.toString() !="" )
                                  {
                                    setState(() {
                                      showProgress = true;
                                    });
                                    widget.storage._writeData(FullNameController.text, "icare_fullname");
                                    widget.storage._writeData(UserNameController.text, "icare_username");
                                    widget.storage._writeData(_BloodTypes, "icare_bloodtype");
                                    widget.storage._writeData(_Age.toString(), "icare_age");
                                    widget.storage._writeData(_Genders, "icare_gender");
                                    widget.storage._writeData(BirthDateController.text, "icare_birthdate");
                                    widget.storage._writeData(ChrHealthController.text!="" ?ChrHealthController.text:"No added Chronic Health Conditions", "icare_chrhealth");
                                    widget.storage._writeData(WeightController.text, "icare_weight");
                                    widget.storage._writeData(HeightController.text, "icare_height");
                                    widget.storage._writeData(_CountryCode.toString()+"-"+_PhoneNumber.toString(), "icare_phone");
                                    widget.storage._writeData(_CountryAbreviation.toString()+"-"+_Country.toString(), "icare_country");
                                    ImageData != "No Data"
                                        ?widget.storage._writeData(ImageData, "icare_picture")
                                        :widget.storage._writeData("No Data", "icare_picture");
                                    if(DrivePermission != "false")
                                    {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder:
                                              (context) =>
                                               HomePage(storage: HomeStorage(),Location: GetLocation(), key: null,)
                                          )
                                      );
                                    }
                                    else
                                    {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder:
                                              (context) =>
                                                  RequestDrivePermissionsPage(storage: DrivePermisssionStorage(),)

                                          )
                                      );
                                    }
                                    setState(() {
                                      showProgress = false;
                                    });

                                  }
                                  else {
                                    setState(() {
                                      showProgress = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: "Error,Saving failed!!! Check Required Data with **",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.teal,
                                        textColor: Colors.white,
                                        fontSize: 14.0);
                                  }
                                } catch (e) {
                                  setState(() {
                                    showProgress = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Error,Saving failed!!! Check Required Data with **",
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


                const SizedBox(
                  height: 10.0,
                ),
            ],
          ),
        ),
      ),
        ),
        );
  }
}





class ProfileInfoStorage
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

