import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:test/pages/show_profile.dart';

class MarketPage extends StatefulWidget {
  final String docID;

  const MarketPage({Key? key, required this.docID}) : super(key: key);

  @override
  MarketPageState createState() => MarketPageState(docID: docID);
}

class MarketPageState extends State<MarketPage> {
  String docID;
  int selectedOptionIndex = 0;

  MarketPageState({Key? key, required this.docID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Image.asset("assets/icons/img_4.png", width: 30, height: 30,),
            onPressed: () {
              // Add your bell icon functionality here
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/boardB.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
        ),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedOptionIndex = 0;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedOptionIndex == 0 ? Colors.pink : Colors.transparent,
                            width: 4.0,
                          ),
                        ),
                      ),
                      child: Text("Subscription",
                        style: TextStyle(
                          color: selectedOptionIndex == 0 ? const Color(0xFF707070) : Colors.black,
                          fontSize: 23,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedOptionIndex = 1;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedOptionIndex == 1 ? Colors.pink : Colors.transparent,
                            width: 4.0,
                          ),
                        ),
                      ),
                      child: Text("Boost",style: TextStyle(
                          color: selectedOptionIndex == 1 ? const Color(0xFF707070) : Colors.black,
                          fontSize: 23,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            selectedOptionIndex == 0 ?
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 15,),
                  const Text(
                    'Subscription Plans',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    height: 380,
                    width: MediaQuery.of(context).size.width,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFF707070)),
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15,),
                        const Text(
                          'Silver',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 56,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const Text(
                          '1 month plan',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const Expanded(flex: 5, child: SizedBox(height: 10,)),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFF707070)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Buy Now',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox(height: 10,)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    height: 380,
                    width: MediaQuery.of(context).size.width,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFF707070)),
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15,),
                        const Text(
                          'Gold',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 56,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const Text(
                          '3 months plan',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const Expanded(flex: 5, child: SizedBox(height: 10,)),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFF707070)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Buy Now',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox(height: 10,)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    height: 380,
                    width: MediaQuery.of(context).size.width,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFF707070)),
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15,),
                        const Text(
                          'Platinum',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 56,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const Text(
                          '1 Year plan',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const Expanded(flex: 5, child: SizedBox(height: 10,)),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFF707070)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Buy Now',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox(height: 10,)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),
                ],
              ),
            )
                :
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 15,),
                  const Text(
                    'Subscription Plans',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    height: 255,
                    width: MediaQuery.of(context).size.width,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFF707070)),
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15,),
                        const Text(
                          '1 Week Boost',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const Expanded(flex: 5, child: SizedBox(height: 10,)),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFF707070)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Buy Now',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox(height: 10,)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    height: 255,
                    width: MediaQuery.of(context).size.width,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFF707070)),
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15,),
                        const Text(
                          '3 Weeks Boost',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const Expanded(flex: 5, child: SizedBox(height: 10,)),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFF707070)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Buy Now',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox(height: 10,)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    height: 255,
                    width: MediaQuery.of(context).size.width,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFF707070)),
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15,),
                        const Text(
                          '1 Month Boost',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const Expanded(flex: 5, child: SizedBox(height: 10,)),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFF707070)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Buy Now',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox(height: 10,)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFF337C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        height: 50,
        child: const Center(
          // Your content here
        ),
      ),
    );
  }
}
