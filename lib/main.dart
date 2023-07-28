import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:icare/HomePage.dart';
import 'package:icare/Splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future BackgroundMessage(RemoteMessage message) async{
  print("===========================Background Message============================");
  print("${message.notification?.body}");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
  ));
  FirebaseMessaging.onBackgroundMessage(BackgroundMessage);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ICare',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Directionality( // use this
        textDirection: TextDirection.rtl, // set it to rtl
        child: SplashScreen(),
      ),
       //home: SignUpInfoPage(storage: ProfileInfoStorage(), key: null,),
      //home: LoginPage(),
    );
  }
}