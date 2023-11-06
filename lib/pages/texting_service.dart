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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();

  final FocusNode messageFocusNode = FocusNode();

  void deleteChats() async {
    // Display an alert dialog for confirmation
    bool reportConfirmed = await showDialog(
      context: context, // Replace 'context' with your build context
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report User'),
          content: Text('Are you sure you want to delete this chat?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No, don't report
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes, report
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (reportConfirmed == true) {

      await _firestore
          .collection('messages')
          .where('sender', isEqualTo: meDocID)
          .where('receiver', isEqualTo: otrDocID)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      await _firestore
          .collection('messages')
          .where('sender', isEqualTo: otrDocID)
          .where('receiver', isEqualTo: meDocID)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chat Deleted Successfully'),
          duration: Duration(seconds: 3), // Adjust the duration as needed
        ),
      );
    }
    Navigator.pop(context);
  }

  void reportUser() async {
    // Display an alert dialog for confirmation
    bool reportConfirmed = await showDialog(
      context: context, // Replace 'context' with your build context
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report User'),
          content: Text('Are you sure you want to report this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No, don't report
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes, report
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (reportConfirmed == true) {

      // Save the information in 'reports' section
      await _firestore.collection('reports').add({
        'reporter': meDocID,
        'reported': otrDocID,
        'timestamp': FieldValue.serverTimestamp(), // Current date and time
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Reported Successfully'),
          duration: Duration(seconds: 3), // Adjust the duration as needed
        ),
      );
    }
    Navigator.pop(context);
  }


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
                      position.dx - button.size.width + 1000,
                      position.dy - button.size.height + 100,
                      position.dx,
                      position.dy,
                    ),
                    items: [
                      PopupMenuItem(
                        value: 1,
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShowProfile(docID: otrDocID, name: username, CP: false, meID: meDocID)),
                        );
                      },
                        child: const Text("View Profile"),
                      ),
                      PopupMenuItem(
                        value: 2,
                        onTap: reportUser,
                        child: const Text("Report User"),
                      ),
                      PopupMenuItem(
                        value: 3,
                        onTap: deleteChats,
                        child: const Text("Delete Chats"),
                      ),
                    ],
                  );
                },
                child: Row(
                  children: [
                    const SizedBox(width: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShowProfile(docID: otrDocID, name: username, CP: false, meID: meDocID)),
                          );
                        },
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
                    try{
                      final messageText = message.get('text');
                      final messageSender = message.get('sender');
                      final messageReceiver = message.get('receiver');
                      final messageTimestamp = message.get('timestamp') as Timestamp?;
                      final isSent = messageSender == meDocID;

                      // Check if the message is for the current user or sent by them
                      if (messageSender == meDocID && messageReceiver == otrDocID ||
                          messageSender == otrDocID && messageReceiver == meDocID) {
                        final messageBubble = MessageBubble(
                          text: messageText,
                          isSent: isSent,
                          timestamp: DateFormat('hh:mm a').format(messageTimestamp!.toDate()),
                        );

                        messageWidgets.add(messageBubble);
                      }
                    }
                    catch(e){
                      1;
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
                    InkWell(
                        onTap: (){
                          FocusScope.of(context).requestFocus(messageFocusNode);
                        },
                        child: Image.asset("assets/icons/img_16.png", width: 40, height: 40,)
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextFormField(
                          controller: messageController,
                          focusNode: messageFocusNode,
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
                        try{
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
                        }
                        catch(e){
                          1;
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
  final String? timestamp;

  const MessageBubble({super.key, required this.text, required this.isSent, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(244, 97, 147, 1),
              borderRadius: BorderRadius.circular(1000),
              border: Border.all(color: const Color.fromRGBO(112, 112, 112, 1),),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          Text(
            timestamp!,
            style: const TextStyle(color: Colors.grey, fontSize: 8),
          ),
        ],
      ),
    );
  }
}
