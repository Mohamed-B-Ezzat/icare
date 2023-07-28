import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:icare/SignUpInfo.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  bool terms_value = false;

  late String email, password;
  String? _content;
  var LanguageData =0;
  var PrivacyPolicyTitle = ["","",""];


  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }


  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<String> createFolder() async {
    const folderName = "ICare";
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
  Future<String?> _readData(String Filename) async {
    final dirPath = await createFolder();
    final myFile = File('$dirPath/'+Filename+'.txt');
    final data = await myFile.readAsString(encoding: utf8);
    setState(() {
      _content = data;
    });
    return _content;
  }

  // This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData(String Data, String Filename) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/'+Filename+'.txt');
    // If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString(Data);
  }

  @override
  Widget build(BuildContext context) {
    final Uri Privacyurl =
    Uri(scheme: 'https', host: 'drive.google.com', path: 'file/d/1ZI3A5NAHP4NJ3QYh6VjmloqTzp1EjtH6/view?usp=sharing');

    final Uri Termsurl =
    Uri(scheme: 'https', host: 'drive.google.com', path: 'file/d/1zC26h1OrJb5IGYJcB4xPzOMUyVOtaoM5/view?usp=sharing');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/signup_login.png'),
                fit: BoxFit.fill
            )
        ),
          child: BlurryModalProgressHUD(
            blurEffectIntensity: 2,
            inAsyncCall: showProgress,
            progressIndicator: const CircularProgressIndicator(
              color: Colors.tealAccent,
            ),
            dismissible: false,
            opacity: 0.7,
            color: Colors.black54,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // const Text(
                //   "Sign Up",
                //   style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0, color: Color.fromRGBO(32, 116, 150, 1.0)),
                // ),

                const SizedBox(
                  height: 60.0,
                ),

                // Form Title
                Container(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.transparent,
                    child: Image.asset(
                      'assets/img/icareicon.png',
                      width: 50,
                      height: 50,
                      alignment: AlignmentDirectional.center,
                      // color: Colors.white,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextField(
                    controller: EmailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value; // get value from TextField
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail Address',
                      prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextField(
                    obscureText: true,
                    controller: PasswordController,
                    onChanged: (value) {
                      password = value; //get value from textField
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 5.0,
                ),

                Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 15,
                    ),
                    Checkbox(
                      value: terms_value,
                      onChanged: (value) {
                        setState(() {
                          terms_value = value!;
                        });
                      },
                    ),
                    const Text(
                      'I am of legal age, and I agree to ',
                      style: TextStyle(fontSize: 15.0,color: Color.fromRGBO(32, 116, 150, 1.0)),
                    ),
                    //Text
                  ], //<Widget>[]
                ),

                Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                        onTap: () async {
                          _launchInBrowser(Termsurl);
                        },
                        child: const Text(
                          'Terms & Conditions',
                          style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline, fontWeight: FontWeight.bold,fontSize: 15.0,color: Color.fromRGBO(32, 116, 150, 1.0)),
                        )
                    ),
                    const Text(
                      ' and ',
                      style: TextStyle(fontSize: 15.0,color: Color.fromRGBO(32, 116, 150, 1.0)),
                    ),
                    GestureDetector(
                        onTap: () async {
                          _launchInBrowser(Privacyurl);
                        },
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.underline,  fontWeight: FontWeight.bold,fontSize: 15.0,color: Color.fromRGBO(32, 116, 150, 1.0)),
                        )
                    ),//Text
                  ], //<Widget>[]
                ),

                const SizedBox(
                  height: 20.0,
                ),

                Container(
                    height: 50,
                    width: 300.0,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Register'),
                      onPressed: ()  async {
                        try {
                          if (await Permission.storage.request().isGranted == false) {
                            Map<Permission, PermissionStatus> statuses = await [
                              Permission.notification,
                              Permission.storage,
                              Permission.photos
                            ].request();
                          }
                          if (await Permission.storage.request().isGranted) {
                            if (email != "" && email != null && password != "" && password != null &&
                                terms_value == true) {
                              setState(() {
                                showProgress = true;
                              });
                              final newuser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);

                              if (newuser != null) {
                                Fluttertoast.showToast(
                                    msg: "Registered Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.teal,
                                    textColor: Colors.white,
                                    fontSize: 14.0);

                                _writeData(email, "icare_email");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Directionality( // use this
                                            textDirection: LanguageData == 1
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                            child: SignUpInfoPage(
                                              storage: ProfileInfoStorage(), key: null,)
                                        ),),
                                );

                                setState(() {
                                  showProgress = false;
                                });
                              }
                            }
                            else {
                              setState(() {
                                showProgress = false;
                              });
                              Fluttertoast.showToast(
                                  msg: "Registration Failed!!"
                                      "Check Required Information",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.teal,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                            }
                          }
                          else{
                            Fluttertoast.showToast(
                                msg: "Registration Failed, Permissions required!!.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.teal,
                                textColor: Colors.white,
                                fontSize: 14.0);
                            Map<Permission, PermissionStatus> statuses = await [
                              Permission.notification,
                              Permission.storage,
                              Permission.photos
                            ].request();
                          }
                        } catch (e) {
                          setState(() {
                            showProgress = false;
                          });
                          Fluttertoast.showToast(
                              msg: e.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.teal,
                              textColor: Colors.white,
                              fontSize: 14.0);
                          Fluttertoast.showToast(
                              msg: "Registration Failed!!"
                                  "Check Required Information",
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
                  height: 15.0,
                ),

                const Text(
                    "Already Registred?",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),

                const SizedBox(
                  height: 10.0,
                ),

                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Directionality( // use this
                              textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                              child: LoginPage(storage: LoginStorage()),
                          ),
                        ));
                  },
                  child: Container(
                  height: 45,
                  width: 150.0,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Color.fromRGBO(32, 116, 150, 1.0),
                            Color.fromRGBO(32, 116, 150, 1.0),
                            // Color.fromRGBO(32, 116, 150, 1.0),
                            // Color.fromRGBO(43, 162, 164, 1.0),
                            // Color.fromRGBO(32, 116, 150, 1.0)
                          ]
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 15.0,bottom: 5.0, right:20.0, left:20.0),
                      child: Text('Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // onPressed: ()  async {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => Directionality( // use this
                      //                         textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                      //                         child: RegisterScreen()
                      //                       ),),
                      //   );
                      // },
                    ),
                  ),
                ),
                ),
              ],
            ),
          ),
      ),

    );
  }
}