import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:test/pages/show_profile.dart';

class TextingService extends StatefulWidget {
  final String docID;

  const TextingService({Key? key, required this.docID}) : super(key: key);

  @override
  TextingServiceState createState() => TextingServiceState(docID: docID);
}

class TextingServiceState extends State<TextingService> {
  String docID;
  int selectedOptionIndex = 0;

  TextingServiceState({Key? key, required this.docID});

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
                final RenderBox button = context.findRenderObject() as RenderBox;
                final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    position.dx - button.size.width+1000, // Adjust the X position to the left
                    position.dy - button.size.height +100, // Adjust the Y position to the top
                    position.dx,
                    position.dy,
                  ),
                  items: [
                    const PopupMenuItem(
                      value: 1,
                      child: Text("View Profile"),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text("Report User"),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text("Delete Chats"),
                    ),
                  ],
                );
              },
              child: Row(
                children: [
                  const SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: Image.asset("assets/images/zara.png", width: 40, height: 40),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  const Text(
                    'Hamail',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  const Expanded(child: SizedBox(width: 10,)),
                  Image.asset("assets/icons/img_18.png", height: 6, width: 24,),
                  const SizedBox(width: 10,),
                ],
              ),
            ),
            const Divider(color: Colors.black, height: 1,)
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10,),
                Image.asset("assets/icons/img_16.png", width: 40, height: 40,),
                const SizedBox(width: 10,),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextFormField(
                      cursorColor: const Color.fromRGBO(255, 0, 239, 1.0),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Enter your Message',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(800),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(255, 0, 239, 1.0),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(800),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(255, 0, 239, 1.0),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Image.asset("assets/icons/img_17.png", width: 40, height: 40,),
                const SizedBox(width: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}