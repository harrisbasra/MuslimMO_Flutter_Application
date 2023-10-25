


import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:test/pages/sign_in.dart';

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
        return const SelectHording();
      },
      duration: 1700,
      splashIconSize: 10000.0,
      // pageTransitionType: PageTransitionType.rightToLeftWithFade,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
