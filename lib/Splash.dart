import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'DemoPage.dart';
import 'RequestLocationPermissions.dart';
import 'RequestMicrophonePermissions.dart';
import 'RequestStoragePermissions.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  Future<void> navigateUser() async {
    // if (await Permission.storage.status.isGranted == false)
    // {
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder:
    //           (context) => RequestStoragePermissionsPage()
    //       )
    //   );
    // }
    // else if (await Permission.microphone.status.isGranted == false) {
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder:
    //           (context) => RequestMicrophonePermissionsPage()
    //       )
    //   );
    //
    // }
    // else if (await Permission.location.status.isGranted == false) {
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder:
    //           (context) => RequestLocationPermissionsPage()
    //       )
    //   );
    // }
    // else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) => DemoPage(storage: DemoStorage())
          )
      );
    // }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img/icaresplash.png'),
              fit: BoxFit.fill),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/img/whitelogo.png',
                  //alignment: Alignment.center,
                ),

              ],
            ),

            Image.asset(
              'assets/img/beats.gif',
              //alignment: Alignment.center,
            ),
            //Image.network('https://firebasestorage.googleapis.com/v0/b/icare-f8e84.appspot.com/o/Gif%2Fbeats.gif?alt=media&token=4ca6a13a-fa40-4224-bec9-b94da0f60bf5')

          ],
        ),
      ),
    );
  }
}


