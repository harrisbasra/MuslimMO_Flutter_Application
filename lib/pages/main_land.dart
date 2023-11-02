import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:test/pages/chat_page.dart';
import 'package:test/pages/filter_application.dart';
import 'package:test/pages/show_profile.dart';

class Person {
  final String imageLink;
  final String name;
  final String profession;
  final String birthdate;
  final String documentId;
  final String rec_ID;
  final String country;
  final String Gender;

  Person({
    required this.imageLink,
    required this.name,
    required this.profession,
    required this.birthdate,
    required this.documentId,
    required this.rec_ID,
    required this.country,
    required this.Gender,
  });
}

class MainLand extends StatefulWidget {
  final String docID;
  final String filters;
  const MainLand({Key? key, required this.docID, required this.filters}) : super(key: key);

  @override
  MainLandState createState() => MainLandState(docID: docID, filters: filters);
}

class MainLandState extends State<MainLand> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String docID;
  String filters;
  MainLandState({Key? key, required this.docID, required this.filters});


  String myCountry = "";

  Future<Map<String, dynamic>> getUserProfile(String documentId) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot document = await users.doc(documentId).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (data.containsKey('imageUrls') && data.containsKey('username')) {
          return {
            'image': data['imageUrls'][0],
            'name': data['username'],
          };
        }
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }

    return {
      'image': 'default_image_url',
      'name': 'Name Not Set',
    };
  }

  void writeFile(String dat, String filN) {
    String string = dat;
    String filename = filN;
    String path = "${Directory.systemTemp.path}/.my_files";
    Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    File file = File("$path/$filename");
    file.writeAsString(string);
  }

  Future<String> fetchNameFromFirestore(String docID) async {
    // Reference to your Firestore collection and document
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot = await users.doc(docID).get();

    if (snapshot.exists) {
      // If the document exists, extract the 'username' field
      String username = snapshot['username'];
      return username;
    } else {
      // Handle the case where the document does not exist or any errors.
      return "User not found";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Builder(
        builder: (BuildContext context) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No data available.'));
              }

              if (snapshot.hasData) {
                List<Person> people = [];

                for (int i = 0; i < snapshot.data!.docs.length; i += 2) {

                  if(snapshot.data!.docs[i].id==widget.docID){
                    myCountry = snapshot.data!.docs[i]['country'];
                  }

                  if(snapshot.data!.docs[i].id!=widget.docID){
                 //if(true){
                    people.add(
                        Person(
                          imageLink: snapshot.data!.docs[i]['imageUrls'][0] ??
                              'https://...',
                          name: snapshot.data!.docs[i]['username'] ?? 'Name Not Set',
                          profession: snapshot.data!.docs[i]['profession'] ?? 'Profession Not Set',
                          birthdate: snapshot.data!.docs[i]['birth_date'] ?? '',
                          documentId: snapshot.data!.docs[i].id,
                          rec_ID: widget.docID,
                          Gender: snapshot.data!.docs[i]['gender'] ?? '',
                          country: snapshot.data!.docs[i]['country'] ?? '',
                        ));
                  }
                  if(i + 1 < snapshot.data!.docs.length && snapshot.data!.docs[i+1].id==widget.docID){
                    myCountry = snapshot.data!.docs[i + 1]['country'];
                    i=i+1;
                  }


                  if (i + 1 < snapshot.data!.docs.length) {
                    people.add(
                        Person(
                      imageLink: snapshot.data!.docs[i + 1]['imageUrls'][0] ??
                          'https://...',
                      name: snapshot.data!.docs[i + 1]['username'] ?? 'Name Not Set',
                      profession: snapshot.data!.docs[i + 1]['profession'] ?? 'Profession Not Set',
                      birthdate: snapshot.data!.docs[i + 1]['birth_date'] ?? '',
                      documentId: snapshot.data!.docs[i + 1].id,
                      rec_ID: widget.docID,
                      Gender: snapshot.data!.docs[i+1]['gender'] ?? '',
                      country: snapshot.data!.docs[i+1]['country'] ?? '',
                    ));
                  }


                }

                if (filters.isEmpty) {

                }
                else {
                  List<String> filtees = filters.split("|");


                  // PROFESSION

                  if(filtees[3]!=""){
                    people.removeWhere((person) => person.profession != filtees[3]);
                  }

                  // COUNTRY

                  if(filtees[0]!=""){
                    people.removeWhere((person) => person.country != filtees[0]);
                  }

                  // GENDER

                  if(filtees[2]!=""){
                    people.removeWhere((person) => person.Gender !=  filtees[2]);
                  }

                  // AGE

                  if(filtees[1]!=""){
                    DateTime now = DateTime.now();
                    people.removeWhere((person) => (now.year - parseCustomDate(person.birthdate).year) >  double.parse(filtees[1]));
                  }

                }

                people.sort((a, b) {
                  String targetCountry = myCountry;
                  print("FFFFFFFFFFF"+myCountry);
                  double similarityA = a.country.toLowerCase().contains(targetCountry.toLowerCase()) ? 1 : 0;
                  double similarityB = b.country.toLowerCase().contains(targetCountry.toLowerCase()) ? 1 : 0;
                  // Compare based on similarity to the target country
                  return similarityB.compareTo(similarityA);
                });




                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 14,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(child: SizedBox(width: 10,)),
                          Expanded(
                            child: Image.asset("assets/icons/img_5.png", width: 90, height: 90,),
                          ),
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FilterApplication(docID: '',)));
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 12.0),
                                  child: Icon(Icons.filter_alt, size: 27,),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      const Text(
                        'Find Your Soulmate',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 34,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          height: 0,
                        ),
                      ),
                      const Text(
                        'Find Your Perfect Match',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          height: 0,
                        ),
                      ),
                      const SizedBox(height: 35,),
                      for (var i = 0; i < people.length; i += 2)
                        Row(
                          children: [
                            Expanded(
                              child: PersonRow(
                                imageLink: people[i].imageLink,
                                name: people[i].name,
                                profession: people[i].profession,
                                birthdate: people[i].birthdate,
                                documentId: people[i].documentId,
                                rec_ID: people[i].rec_ID,
                              ),
                            ),
                            if (i + 1 < people.length)
                              Expanded(
                                child: PersonRow(
                                  imageLink: people[i + 1].imageLink,
                                  name: people[i + 1].name,
                                  profession: people[i + 1].profession,
                                  birthdate: people[i + 1].birthdate,
                                  documentId: people[i + 1].documentId,
                                  rec_ID: people[i + 1].rec_ID,
                                ),
                              ),
                            if (i + 1 >= people.length)
                              Expanded(child: Container())
                          ],
                        ),
                      const SizedBox(height: 18,),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFF337C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/icons/img_11.png", width: 40, height: 40,),
            Image.asset("assets/icons/img_12.png", width: 40, height: 40,),
            Image.asset("assets/icons/img_13.png", width: 40, height: 40,),
            InkWell(
                onTap: () async {
                  String username = await fetchNameFromFirestore(widget.docID);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(docID: widget.docID)));
                },
                child: Image.asset("assets/icons/img_14.png", width: 40, height: 40,)
            ),
            InkWell(
                onTap: () async {
                  String username = await fetchNameFromFirestore(widget.docID);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShowProfile(docID: widget.docID, name: username, CP: true)));
                },
                child: Image.asset("assets/icons/img_15.png", width: 40, height: 40,)
            ),
          ],
        )
      ),
      drawer: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 150,
          child: Drawer(
            width: 200,
            child: Align(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  FutureBuilder<Map<String, dynamic>>(
                    future: getUserProfile(widget.docID),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(snapshot.data?['image']),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  snapshot.data?['name'] ?? 'Name Not Set',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 35,),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Home",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ShowProfile(docID: widget.docID, name: snapshot.data?['name'], CP: true)));
                              },
                              child: const Text(
                                "Profile",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            InkWell(
                              onTap: () {

                              },
                              child: const Text(
                                "Messaging",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,

                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            InkWell(
                              onTap: () {

                              },
                              child: const Text(
                                "Gallery",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,

                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            InkWell(
                              onTap: () {

                              },
                              child: const Text(
                                "Setting",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,

                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            InkWell(
                              onTap: () {

                              },
                              child: const Text(
                                "Contact Us",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,

                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            InkWell(
                              onTap: () {
                                writeFile("", "log.in");
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),

                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

DateTime parseCustomDate(String date) {
  List<String> parts = date.split('/');
  final day = int.parse(parts[0]);
  final month = DateFormat.MMMM().parse(parts[1]).month;
  final year = int.parse(parts[2]);
  return DateTime(year, month, day);
}

class PersonRow extends StatelessWidget {
  final String imageLink;
  final String name;
  final String profession;
  final String birthdate;
  final String documentId;
  final String rec_ID;

  PersonRow({
    Key? key,
    required this.imageLink,
    required this.name,
    required this.profession,
    required this.birthdate,
    required this.documentId,
    required this.rec_ID,
  });



  @override
  Widget build(BuildContext context) {
    DateTime parsedBirthDate = parseCustomDate(birthdate);
    DateTime now = DateTime.now();
    int age = now.year - parsedBirthDate.year;

    return InkWell(
      onTap: () async {
        bool hasChildren = await checkForChildrenAttribute(documentId);

        if (hasChildren) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowProfile(docID: documentId, CP: (rec_ID == documentId), name: name,)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User hasn\'t Provided details yet'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 14.0, bottom: 14.0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFF707070)),
                ),
              ),
              child: Image.network(
                imageLink,
                height: 150,
                width: (MediaQuery.of(context).size.width * 0.5) - 20,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 6,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(width: 55,),
                Text(
                  '$age yr old',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ],
            ),
            Text(
              profession,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkForChildrenAttribute(String documentId) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot document = await users.doc(documentId).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (data.containsKey('children')) {
          return true;
        }
      }
    } catch (e) {
      print("Error checking for 'children' attribute: $e");
    }

    return false;
  }
}
