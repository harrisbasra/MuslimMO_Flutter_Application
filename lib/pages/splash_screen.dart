import 'dart:async';
import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:test/pages/sign_in.dart';

import 'main_land.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/board.png',),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
            child: Image.asset('assets/images/logo.png',
              width: MediaQuery.of(context).size.width*0.7,
              fit: BoxFit.fitWidth,
            )
        ),
      ),
      screenFunction: () async {
        FutureOr<Widget> oic = SelectHording();
        //writeFile("", "log.in");
        //return SelectHording();
        String commit = readFile("log.in");
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        if(commit!=""){
          QuerySnapshot querySnapshot = await firestore
              .collection('users') // Replace with your Firestore collection name
              .where('email', isEqualTo: commit)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            // Email exists in Firestore, you can print the document IDs
            for (QueryDocumentSnapshot doc in querySnapshot.docs) {
              oic = MainLand(docID: doc.id);
            }
          }
        }
        else {
          oic = SelectHording();
        }
        return oic;
      },
      duration: 1700,
      splashIconSize: 10000.0,
      // pageTransitionType: PageTransitionType.rightToLeftWithFade,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 1),
    );
  }
}

String readFile(String filN) {
  String filename = filN;
  String path = "${Directory.systemTemp.path}/.my_files/$filename";
  File file = File(path);

  try {
    String string = file.readAsStringSync();
    return string;
  } catch (e) {
    // Handle the case where the file is not present
    return "";
  }
}

void writeFile(String dat, String fil_n){

  String string = dat;
  String filename = fil_n;
  String path = Directory.systemTemp.path + "/.my_files";
  Directory directory = Directory(path);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
  File file = File(path + "/" + filename);
  file.writeAsString(string);
}
