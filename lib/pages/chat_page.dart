import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:test/pages/show_profile.dart';
import 'package:test/pages/texting_service.dart';

class ChatPage extends StatefulWidget {
  final String docID;

  const ChatPage({Key? key, required this.docID}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState(docID: docID);
}

class ChatPageState extends State<ChatPage> {
  String docID;
  int selectedOptionIndex = 0;

  ChatPageState({Key? key, required this.docID});

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
                      child: Text(
                        "All Chats",
                        style: TextStyle(
                          color: selectedOptionIndex == 0 ? const Color(0xFF707070) : Colors.black,
                          fontSize: 23,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
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
                      child: Text(
                        "Read",
                        style: TextStyle(
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
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedOptionIndex = 2;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedOptionIndex == 2 ? Colors.pink : Colors.transparent,
                            width: 4.0,
                          ),
                        ),
                      ),
                      child: Text(
                        "Unread",
                        style: TextStyle(
                          color: selectedOptionIndex == 2 ? const Color(0xFF707070) : Colors.black,
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
            selectedOptionIndex == 0 ? const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  ChatMessage(imageLink: "imageLink", name: "Zara", lastMessage: "Hi! How Are You", time: "10:17 AM", read: false),
                  ChatMessage(imageLink: "imageLink", name: "Zara", lastMessage: "Hi! How Are You", time: "10:17 AM", read: false),
                ],
              ),
            ) :
            selectedOptionIndex == 1 ? const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  ChatMessage(imageLink: "imageLink", name: "Zara", lastMessage: "Hi! How Are You", time: "10:17 AM", read: false),
                  ChatMessage(imageLink: "imageLink", name: "Zara", lastMessage: "Hi! How Are You", time: "10:17 AM", read: false),
                ],
              ),
            )  :
            selectedOptionIndex == 2 ? const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  ChatMessage(imageLink: "imageLink", name: "Zara", lastMessage: "Hi! How Are You", time: "10:17 AM", read: false),
                  ChatMessage(imageLink: "imageLink", name: "Zara", lastMessage: "Hi! How Are You", time: "10:17 AM", read: false),
                ],
              ),
            ) : Container()
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

class ChatMessage extends StatelessWidget {
  final String imageLink;
  final String name;
  final String lastMessage;
  final String time;
  final bool read;

  const ChatMessage({super.key,
    required this.imageLink,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.read
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const TextingService(docID: "",)));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 84,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFF707070)),
              borderRadius: BorderRadius.circular(700),
            ),
            shadows: const [
             BoxShadow(
                color: Color(0x29000000),
                blurRadius: 3,
                offset: Offset(0, 3),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 10,),
                ClipOval(
                  child: Image.asset("assets/images/zara.png", width: 68, height: 68),
                ),
                const SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    Text(
                      lastMessage,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  ],
                ),
                const Expanded(child: SizedBox(width: 10,)),
                Opacity(
                  opacity: 0.41,
                  child: Text(
                    time,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
