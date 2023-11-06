import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/pages/texting_service.dart';

class ChatPage extends StatefulWidget {
  final String docID;

  const ChatPage({Key? key, required this.docID}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState(docID: docID);
}

String meID = "";

class ChatPageState extends State<ChatPage> {
  String docID;
  List<String> usersList = [];

  ChatPageState({Key? key, required this.docID});

  @override
  void initState() {
    super.initState();
    meID = widget.docID;
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
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.pink,
                        width: 4.0,
                      ),
                    ),
                  ),
                  child: const Text(
                    "All Chats",
                    style: TextStyle(
                      color: Color(0xFF707070),
                      fontSize: 23,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                FutureBuilder<void>(
                  future: loadUsersList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          children: usersList.map((user) {
                            return FutureBuilder<String>(
                              future: getUsernameFromDocumentId(user),
                              builder: (context, usernameSnapshot) {
                                if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                                  return Container();
                                } else if (usernameSnapshot.hasError) {
                                  return Text('Error: ${usernameSnapshot.error}');
                                } else {
                                  String username = usernameSnapshot.data ?? "User not found";

                                  return FutureBuilder<String>(
                                    future: getImageUrlFromDocumentId(user),
                                    builder: (context, imageSnapshot) {
                                      if (imageSnapshot.connectionState == ConnectionState.waiting) {
                                        return Container();
                                      } else if (imageSnapshot.hasError) {
                                        return Text('Error: ${imageSnapshot.error}');
                                      } else {
                                        String imageLink = imageSnapshot.data ?? "DefaultImageLink";

                                        return Column(
                                          children: [
                                            ChatMessage(
                                              imageLink: imageLink,
                                              name: username,
                                              otrID: user,
                                              read: false,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => TextingService(
                                                      meDocID: meID,
                                                      otrDocID: user,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  );
                                }
                              },
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
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
        child: const Center(),
      ),
    );
  }


  Future<void> loadUsersList() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final senderQuery = await firestore.collection('messages').where('sender', isEqualTo: meID).get();
    final receiverQuery = await firestore.collection('messages').where('receiver', isEqualTo: meID).get();

    for (var doc in senderQuery.docs) {
      final otherUser = doc['receiver'];
      if (!usersList.contains(otherUser)) {
        usersList.add(otherUser);
      }
    }

    for (var doc in receiverQuery.docs) {
      final otherUser = doc['sender'];
      if (!usersList.contains(otherUser)) {
        usersList.add(otherUser);
      }
    }
  }

  Future<String> getUsernameFromDocumentId(String documentId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final document = await firestore.collection('users').doc(documentId).get();
      if (document.exists) {
        final username = document.data()?['username'];
        return username;
      } else {
        return "User not found";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String> getImageUrlFromDocumentId(String documentId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final document = await firestore.collection('users').doc(documentId).get();
      if (document.exists) {
        final imageUrls = document.data()?['imageUrls'];
        if (imageUrls != null && imageUrls is List && imageUrls.isNotEmpty) {
          return imageUrls[0];
        }
      }
      return "DefaultImageLink";
    } catch (e) {
      return "Error: $e";
    }
  }
}

class ChatMessage extends StatelessWidget {
  final String imageLink;
  final String name;
  final bool read;
  final Function onTap;
  final String otrID;

  const ChatMessage({
    Key? key,
    required this.imageLink,
    required this.name,
    required this.read,
    required this.onTap,
    required this.otrID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0,),
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
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(800),
                    border: Border.all(
                      color: Colors.black,
                      width: 1
                    )
                  ),
                  child: ClipOval(
                    child: Image.network(imageLink, width: 68, height: 68, fit: BoxFit.fitWidth,), // Use Image.network for network images
                  ),
                ),
                const SizedBox(width: 10),
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
                    FutureBuilder<String>(
                      future: fetchLatestMessageInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text(
                            'Loading...', // You can display a loading message while fetching the latest message.
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                          return Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          );
                        }
                        return Text(
                          snapshot.data != null
                              ? snapshot.data!.length > 10
                              ? '${snapshot.data!.substring(0, 10)}...'
                              : snapshot.data!
                              : 'No messages yet',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Expanded(child: SizedBox(width: 10)),
                FutureBuilder<String>(
                  future: fetchLatestTimeInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Opacity(
                        opacity: 0.41,
                        child: Text(
                          'Loading...', // You can display a loading message while fetching the latest time.
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Opacity(
                        opacity: 0.41,
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      );
                    }
                    return Opacity(
                      opacity: 0.41,
                      child: Text(
                        snapshot.data != null
                            ? snapshot.data!.length > 10
                            ? '${snapshot.data!.substring(0, 10)}...'
                            : snapshot.data!
                            : 'No messages yet',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 8,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getLatestMessage(String user1DocID, String user2DocID) async {
    final messagesCollection = FirebaseFirestore.instance.collection('messages');

    final user1ToUser2 = await messagesCollection
        .where('sender', isEqualTo: user1DocID)
        .where('receiver', isEqualTo: user2DocID)
        .get();

    final user2ToUser1 = await messagesCollection
        .where('sender', isEqualTo: user2DocID)
        .where('receiver', isEqualTo: user1DocID)
        .get();

    final allMessages = [
      ...user1ToUser2.docs,
      ...user2ToUser1.docs,
    ];

    if (allMessages.isEmpty) {
      return {
        'messageText': '',
        'timestamp': null,
      };
    }

    allMessages.sort((a, b) {
      final aTimestamp = (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp;
      final bTimestamp = (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp;
      return bTimestamp.compareTo(aTimestamp);
    });

    final latestMessage = allMessages[0].data() as Map<String, dynamic>;

    return {
      'messageText': latestMessage['text'],
      'timestamp': latestMessage['timestamp'],
    };
  }


  Future<String> fetchLatestMessageInfo() async {
    String user1DocID = meID; // Replace with the actual document ID of the first user
    String user2DocID = otrID; // Replace with the actual document ID of the second user

    Map<String, dynamic> latestMessageInfo = await getLatestMessage(user1DocID, user2DocID);

    String latestMessageText = latestMessageInfo['messageText'];

    return latestMessageText;
  }

  Future<String> fetchLatestTimeInfo() async {
    String user1DocID = meID; // Replace with the actual document ID of the first user
    String user2DocID = otrID; // Replace with the actual document ID of the second user

    Map<String, dynamic> latestMessageInfo = await getLatestMessage(user1DocID, user2DocID);

    String latestMessageTimestamp = latestMessageInfo['timestamp'] != null
        ? DateFormat('hh:mm a').format((latestMessageInfo['timestamp'] as Timestamp).toDate())
        : '';

    return latestMessageTimestamp;
  }
}


