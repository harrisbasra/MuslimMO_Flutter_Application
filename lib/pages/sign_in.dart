import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/pages/log_in.dart';
import 'package:test/pages/main_land.dart';
import 'package:test/pages/set_prefrences.dart';
import 'package:test/pages/sign_up.dart';

import 'market_page.dart';

class SelectHording extends StatefulWidget{
  const SelectHording({super.key});

  @override
  State<SelectHording> createState() => SelectHordingState();
}

class SelectHordingState extends State<SelectHording> {
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/board.png',),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const MarketPage(docID: "2NjYXcULWl7arhvw5Shn",)));
                },
                child: Image.asset('assets/images/logoBeta.png',
                  //width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const Expanded(child: SizedBox(height: 20,)),
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                  },
                  child: Image.asset("assets/images/logB1.png", height: 40, fit: BoxFit.fitHeight,)
              ),
              const SizedBox(height: 25,),
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUp(email: "",)));
                  },
                  child: Image.asset("assets/images/logB2.png", height: 40, fit: BoxFit.fitHeight,)),
              const Expanded(child: SizedBox(height: 20,)),
            ],
          ),
        ),
      ),
    );
  }
}


