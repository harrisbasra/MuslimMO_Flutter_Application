import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:test/pages/show_profile.dart';

class TextingService extends StatefulWidget {
  final String meDocID;
  final String otrDocID;
  const TextingService({Key? key, required this.meDocID, required this.otrDocID}) : super(key: key);

  @override
  TextingServiceState createState() => TextingServiceState(meDocID: meDocID, otrDocID: otrDocID);
}

class TextingServiceState extends State<TextingService> {
  String meDocID;
  String otrDocID;
  int selectedOptionIndex = 0;

  TextingServiceState({Key? key, required this.meDocID, required this.otrDocID});


  List<MessageBubble> messages = [
    MessageBubble(text: "Hello, how are you?", isSent: true, timestamp: "12:30 PM"),
    MessageBubble(text: "Hello, how are you?", isSent: true, timestamp: "12:30 PM"),
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(otrDocID).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Display a loading indicator
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return const Text('Data not found');
              }

              final data = snapshot.data?.data() as Map<String, dynamic>;

              final imageUrls = data['imageUrls'] as List<dynamic>;
              final username = data['username'] as String;

              return InkWell(
                onTap: () {
                  final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
                  final RenderBox button = context.findRenderObject() as RenderBox;
                  final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx - button.size.width + 1000, // Adjust the X position to the left
                      position.dy - button.size.height + 100, // Adjust the Y position to the top
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
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1
                          ),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: ClipOval(
                          child: Image.network(imageUrls.isNotEmpty ? imageUrls[0] : 'placeholder_url', width: 40, height: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      username,
                      style: const TextStyle(
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
              );
            },
          ),
          const Divider(color: Colors.black, height: 1,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .where('sender', whereIn: [meDocID, otrDocID])
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final messages = snapshot.data?.docs;
                  List<Widget> messageWidgets = [];

                  for (var message in messages!) {
                    final messageText = message.get('text');
                    final messageSender = message.get('sender');
                    final messageReceiver = message.get('receiver');
                    final messageTimestamp = message.get('timestamp') as Timestamp;
                    final isSent = messageSender == meDocID;

                    // Check if the message is for the current user or sent by them
                    if (messageSender == meDocID && messageReceiver == otrDocID ||
                        messageSender == otrDocID && messageReceiver == meDocID) {
                      final messageBubble = MessageBubble(
                        text: messageText,
                        isSent: isSent,
                        timestamp: DateFormat('hh:mm a').format(messageTimestamp.toDate()),
                      );

                      messageWidgets.add(messageBubble);
                    }
                  }

                  return ListView(
                    children: messageWidgets,
                  );
                },
              ),


            ),
          ),
          SizedBox(
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
                          controller: messageController,
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
                    IconButton(
                      icon: Image.asset("assets/icons/img_17.png", width: 40, height: 40,),
                      onPressed: () {
                        // Add your send message functionality here
                        final textEditingController = messageController; // Replace with your actual TextEditingController
                        final messageText = textEditingController.text;

                        if (messageText.isNotEmpty) {
                          // Create a new message document in Firestore
                          _firestore.collection('messages').add({
                            'sender': meDocID, // Your ID
                            'receiver': otrDocID, // Other user's ID
                            'text': messageText,
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                          textEditingController.clear(); // Clear the text input field
                        }
                      },
                    ),

                    const SizedBox(width: 10,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String text;
  final bool isSent;
  final String timestamp;

  const MessageBubble({super.key, required this.text, required this.isSent, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(244, 97, 147, 1),
              borderRadius: BorderRadius.circular(1000),
              border: Border.all(color: const Color.fromRGBO(112, 112, 112, 1),),
            ),
            child: Text(text),
          ),
          Text(
            timestamp,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
