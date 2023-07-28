import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:icare/HomePage.dart';
import 'package:icare/RegisterScreen.dart';
import 'package:icare/SignUpInfo.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'RequestDrivePermissions.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(storage: LoginStorage()),
    );
  }
}

class LoginPage extends StatefulWidget {
  final LoginStorage storage;

  LoginPage({ Key? key, required this.storage}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? _status;
  bool showProgress = false;
  late String email, password;
  String GuestEmail = "guest_icare@gmail.com";
  String GuestPassword = "Guest@Icare#12345";
  String _email = "" , _age = "";
  var LanguageData =0;
  var DrivePermission = "false";

  final googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive']);

  TextEditingController ResetMailController = TextEditingController();
  String ResetMail = "";



  @override
  void initState() {

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

    widget.storage._readData("icare_email").then((String icare_email) async{
      setState(() {
        _email = icare_email;
      });
      if(icare_email != "No Data")
      {
        widget.storage._readData("icare_age").then((String icare_age) {
          setState(() {
            _age = icare_age;
          });
          if(icare_age == "No Data")
          {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                        Directionality( // use this
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            child: SignUpInfoPage(storage: ProfileInfoStorage(), key: null,)
                        ),


                )
            );
          }
          else
          {
            if(DrivePermission != "false")
              {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder:
                        (context) =>
                        Directionality( // use this
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            child: HomePage(storage: HomeStorage(),Location: GetLocation(), key: null,)
                        ),
                    )
                );
              }
            else
              {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder:
                        (context) =>
                        Directionality( // use this
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            child: RequestDrivePermissionsPage(storage: DrivePermisssionStorage(),)
                        ),
                    )
                );
              }

          }
        });
      }
      else {
        if (await Permission.storage.request().isGranted == false) {
      // Either the permission was already granted before or the user just granted it.
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.storage,
      Permission.photos
      ].request();
      }
        super.initState();
      }
    });


  }



  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    //final UserData = await FacebookAuth.instance.getUserData();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);


    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }



  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
              const SizedBox(
                height: 50.0,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
              TextButton(
                onPressed: () async{
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
                          title: const Text(
                            "Reset your password",
                            style: TextStyle(fontSize: 24.0,color: Color.fromRGBO(32, 116, 150, 1.0),),
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
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      controller: ResetMailController,
                                      onChanged: (value) {
                                        ResetMail = value;
                                        //get value from textField
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Enter E-mail here",
                                        labelText: "E-mail",
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

                                        try{
                                          await _auth
                                              .sendPasswordResetEmail(email: ResetMail);
                                          Fluttertoast.showToast(
                                              msg: "Reset link sent to your E-mail",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.teal,
                                              textColor: Colors.white,
                                              fontSize: 14.0);
                                          Fluttertoast.showToast(
                                              msg: "Sent Successfully, Check your spam or junk",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.teal,
                                              textColor: Colors.white,
                                              fontSize: 14.0);
                                          Navigator.pop(context, false);
                                        }
                                        catch(e){
                                          Fluttertoast.showToast(
                                              msg: e.toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.teal,
                                              textColor: Colors.white,
                                              fontSize: 14.0);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.teal,
                                        // fixedSize: Size(250, 50),
                                      ),
                                      child: const Text(
                                        "Send Reset Link",
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
                child: const Text('Forget Password ?',
                    style: TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0)),
              ),
              ),
              Container(
                  height: 50,
                  width: 300.0,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: ()  async {
                      try {
                        if (await Permission.storage.request().isGranted == false) {
                          // Either the permission was already granted before or the user just granted it.
                          // You can request multiple permissions at once.
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.notification,
                            Permission.storage,
                            Permission.photos
                          ].request();
                        }
                        if (await Permission.storage.request().isGranted) {
                          if (email != "" && password != "") {
                            setState(() {
                              showProgress = true;
                            });
                            final newUser = await _auth
                                .signInWithEmailAndPassword(
                                email: email, password: password);
                            print(newUser.toString());
                            if (newUser != null) {
                              Fluttertoast.showToast(
                                  msg: "Login Successful",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.teal,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                              widget.storage._writeData(email,"icare_email");
                              widget.storage._writeData("Local","icare_pictype");

                              widget.storage._writeLoginTypeData("Email");

                              if(_age == "")
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Directionality( // use this
                                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                          child: SignUpInfoPage(storage: ProfileInfoStorage(), key: null,)),
                                      ),
                                );
                              }
                              else
                                {
                                  if(DrivePermission != "false")
                                  {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder:
                                            (context) =>
                                            Directionality( // use this
                                                textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                child: HomePage(storage: HomeStorage(),Location: GetLocation(), key: null,)
                                            ),
                                        )
                                    );
                                  }
                                  else
                                  {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder:
                                            (context) =>
                                            Directionality( // use this
                                                textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                child: RequestDrivePermissionsPage(storage: DrivePermisssionStorage(),)
                                            ),
                                        )
                                    );
                                  }

                                }
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
                                msg: "E-mail and password are required",
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
                              msg: "Login Failed, Permissions required!!.",
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
                        Fluttertoast.showToast(
                            msg: e.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                            fontSize: 14.0);
                        setState(() {
                          showProgress = false;
                        });
                        Fluttertoast.showToast(
                          msg: "Login Failed, Check Required Info.",
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
                height: 5.0,
              ),
              const Text(
                "ـــــــــــــــــــــــــــــــــــ   or   ـــــــــــــــــــــــــــــــــــ",
                style: TextStyle(fontSize: 14.0, color: Colors.blue),
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Text(
                "Sign in with",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0, color: Colors.blue),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 50.0,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async{
                      setState(() {
                        showProgress = true;
                      });
                      try{
                        if (await Permission.storage.request().isGranted == false) {
                          // Either the permission was already granted before or the user just granted it.
                          // You can request multiple permissions at once.
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.notification,
                            Permission.storage,
                            Permission.photos
                          ].request();
                        }
                        if (await Permission.storage.request().isGranted) {
                          final newuser = await signInWithGoogle();
                          googleSignIn.signIn();

                          await googleSignIn.isSignedIn().then((value) {
                            DrivePermission = value.toString();
                          }
                          );
                          widget.storage._writeSettingsData(DrivePermission);

                          if (newuser != null) {
                            Fluttertoast.showToast(
                                msg: "Login Successful",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.teal,
                                textColor: Colors.white,
                                fontSize: 14.0);

                            widget.storage._writeData(FirebaseAuth.instance
                                .currentUser!.photoURL.toString(),
                                "icare_picture");
                            widget.storage._writeData("Network", "icare_pictype");
                            widget.storage._writeData(FirebaseAuth.instance
                                .currentUser!.email.toString(), "icare_email");
                            widget.storage._writeData(FirebaseAuth.instance
                                .currentUser!.displayName.toString(),
                                "icare_username");
                            widget.storage._writeData(FirebaseAuth.instance
                                .currentUser!.displayName.toString(),
                                "icare_fullname");
                            widget.storage._writeLoginTypeData("Google");

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Directionality( // use this
                                        textDirection: LanguageData == 1
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                        child: SignUpInfoPage(
                                          storage: ProfileInfoStorage(),
                                          key: null,)),
                              ),
                            );

                            setState(() {
                              showProgress = false;
                            });
                          }
                        }
                        else{
                          Fluttertoast.showToast(
                              msg: "Login Failed, Permissions required!!.",
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
                      }
                      catch(e)
                      {
                        Fluttertoast.showToast(
                            msg: e.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      }

                    },
                    icon: SvgPicture.asset(
                      'assets/img/google.svg',
                      height: 20.0,
                      width: 20.0,
                      allowDrawingOutsideViewBox: true,
                      // color : Colors.white,
                    ),
                    label: const Text('Google',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Color.fromRGBO(66, 133, 244, 1.0))
                    ),
                    style: ElevatedButton.styleFrom(
                      // primary: Color.fromRGBO(66, 133, 244, 1.0),
                      primary: Colors.white,
                      side: const BorderSide(width: 1.0, color: Color.fromRGBO(66, 133, 244, 1.0)),
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        showProgress = true;
                      });
                      try {
                        if (await Permission.storage.request().isGranted == false) {
                          // Either the permission was already granted before or the user just granted it.
                          // You can request multiple permissions at once.
                          Map<Permission, PermissionStatus> statuses = await [

                            Permission.location,
                            Permission.camera,
                            Permission.microphone,
                            Permission.notification,
                            Permission.storage,
                            Permission.photos
                          ].request();
                        }
                        if (await Permission.storage.request().isGranted) {
                          final newuser = await signInWithFacebook();

                          if (newuser != null) {
                            Fluttertoast.showToast(
                                msg: "Login Successful",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.teal,
                                textColor: Colors.white,
                                fontSize: 14.0);

                            widget.storage._writeData(FirebaseAuth.instance
                                .currentUser!.photoURL.toString(),
                                "icare_picture");
                            widget.storage._writeData("Network", "icare_pictype");
                            widget.storage._writeData(FirebaseAuth.instance
                                .currentUser!.email.toString(), "icare_email");
                            widget.storage._writeData(FirebaseAuth.instance
                                .currentUser!.displayName.toString(),
                                "icare_username");
                            widget.storage._writeData(FirebaseAuth.instance
                                .currentUser!.displayName.toString(),
                                "icare_fullname");
                            widget.storage._writeLoginTypeData("Facebook");


                            if (DrivePermission != "false") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Directionality( // use this
                                          textDirection: LanguageData == 1
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                          child: SignUpInfoPage(
                                            storage: ProfileInfoStorage(),
                                            key: null,)),
                                ),
                              );
                            }
                            else {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder:
                                      (context) =>
                                      Directionality( // use this
                                          textDirection: LanguageData == 1
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                          child: RequestDrivePermissionsPage(
                                            storage: DrivePermisssionStorage(),)
                                      ),
                                  )
                              );
                            }

                            setState(() {
                              showProgress = false;
                            });
                          }
                        }
                        else{
                          Fluttertoast.showToast(
                              msg: "Login Failed, Permissions required!!.",
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
                      }
                      catch(e)
                      {
                        Fluttertoast.showToast(
                            msg: e.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      }


                    },
                    icon: SvgPicture.asset(
                      'assets/img/facebook.svg',
                      height: 20.0,
                      width: 20.0,
                      allowDrawingOutsideViewBox: true,
                      color : Colors.white,
                    ),
                    label: const Text('Facebook',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white)
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(66, 103, 178, 1.0),
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 40.0,
                  ),
                  // ElevatedButton.icon(
                  //   onPressed: () {},
                  //   icon: SvgPicture.asset(
                  //     'assets/img/apple.svg',
                  //     height: 20.0,
                  //     width: 20.0,
                  //     allowDrawingOutsideViewBox: true,
                  //     color : Colors.white,
                  //   ),
                  //   label: const Text('Apple',
                  //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white)
                  //   ),
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.black,
                  //     textStyle: const TextStyle(fontSize: 15),
                  //   ),
                  // ),
                ], //<Widget>[]
              ),
              const SizedBox(
                height: 5.0,
              ),
              Container(
                  height: 50,
                  width: 300.0,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login as guest'),
                    onPressed: ()  async {

                      try {
                        if (await Permission.storage.request().isGranted == false) {
                          // Either the permission was already granted before or the user just granted it.
                          // You can request multiple permissions at once.
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.notification,
                            Permission.storage,
                            Permission.photos
                          ].request();
                        }

                        if (await Permission.storage.request().isGranted) {
                          setState(() {
                            showProgress = true;
                          });
                          final newUser = await _auth
                              .signInWithEmailAndPassword(
                              email: GuestEmail, password: GuestPassword);
                          print(newUser.toString());
                          if (newUser != null) {
                            Fluttertoast.showToast(
                                msg: "Login Successful",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.teal,
                                textColor: Colors.white,
                                fontSize: 14.0);
                            widget.storage._writeData(GuestEmail,"icare_email");
                            widget.storage._writeData("Local","icare_pictype");
                            widget.storage._writeData("Guest User", "icare_fullname");
                            widget.storage._writeData("Guest", "icare_username");
                            widget.storage._writeData("AB+", "icare_bloodtype");
                            widget.storage._writeData("30", "icare_age");
                            widget.storage._writeData("Male", "icare_gender");
                            widget.storage._writeData("23/10/1992", "icare_birthdate");
                            widget.storage._writeData("good", "icare_chrhealth");
                            widget.storage._writeData("90", "icare_weight");
                            widget.storage._writeData("170", "icare_height");
                            widget.storage._writeData("+20-1234567890", "icare_phone");
                            widget.storage._writeData("Egypt", "icare_country");
                            widget.storage._writeLoginTypeData("Guest");

                            if(DrivePermission != "false")
                            {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder:
                                      (context) =>
                                      Directionality( // use this
                                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                          child: HomePage(storage: HomeStorage(),Location: GetLocation(), key: null,)
                                      ),
                                  )
                              );
                            }
                            else
                            {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder:
                                      (context) =>
                                      Directionality( // use this
                                          textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                          child: RequestDrivePermissionsPage(storage: DrivePermisssionStorage(),)
                                      ),
                                  )
                              );
                            }

                            setState(() {
                              showProgress = false;
                            });

                          }

                        }
                        else{
                          Fluttertoast.showToast(
                              msg: "Login Failed, Permissions required!!.",
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
                        Fluttertoast.showToast(
                            msg: e.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                            fontSize: 14.0);
                        setState(() {
                          showProgress = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Login Failed, Check Required Info.",
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
                  "Does not have account?",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w900),
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
                        child: RegisterScreen(),
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
                    child: Text('Sign Up',
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
                    //                         child: RegisterScreen()),
                    //                       ),
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








class LoginStorage
{
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

    // This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData(String Data, String Filename) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/'+Filename+'.txt');
    // If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString(Data);
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
  Future<void> _writeSettingsData(String Data) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/icare_Drive_Permission.txt');
    // If data.txt doesn't exist, it will be created automatically
    if ((await _myFile.exists())) {
      await _myFile.writeAsString(Data,  mode: FileMode.append);
    } else {
      await _myFile.writeAsString(Data);

    }
  }

  // This function is triggered when the "Write" buttion is pressed
  Future<void> _writeLoginTypeData(String Data) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/icare_Login_Type.txt');
    // If data.txt doesn't exist, it will be created automatically
    if ((await _myFile.exists())) {
      await _myFile.writeAsString(Data,  mode: FileMode.append);
    } else {
      await _myFile.writeAsString(Data);

    }
  }





}