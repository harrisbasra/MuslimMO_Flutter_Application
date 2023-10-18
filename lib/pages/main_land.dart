import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:test/pages/show_profile.dart';

class MainLand extends StatefulWidget {
  final String docID;

  const MainLand({Key? key, required this.docID}) : super(key: key);

  @override
  MainLandState createState() => MainLandState(docID: docID);
}

class MainLandState extends State<MainLand> {
  String docID;
  MainLandState({Key? key, required this.docID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available.'));
          }

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
                    const Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Icon(Icons.filter_alt, size: 27,),
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
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 8,),
                const Text(
                  'Find Your Perfect Match',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 35,),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                  child: Column(
                    children: [
                      for (var i = 0; i < snapshot.data!.docs.length; i += 2)
                        Row(
                          children: [
                            Expanded(
                              child: PersonRow(
                                imageLink: snapshot.data!.docs[i]['imageUrls'][0] ?? 'https://firebasestorage.googleapis.com/v0/b/muslimmatt-270d5.appspot.com/o/profile_images%2Fimage_2023-10-19_000724079.png?alt=media&token=0111fcb2-b173-4a64-9ef6-70dee846d447&_gl=1*1tk9lym*_ga*MTc0MTQzMTkwLjE2OTI4MjAwNTA.*_ga_CW55HF8NVT*MTY5NzY1NjAzMC4zMy4xLjE2OTc2NTYwNzAuMjAuMC4w',
                                name: snapshot.data!.docs[i]['username'] ?? 'Name Not Set',
                                profession: snapshot.data!.docs[i]['profession'] ?? 'Profession Not Set',
                                birthdate: snapshot.data!.docs[i]['birth_date'] ?? '',
                                documentId: snapshot.data!.docs[i].id,
                              ),
                            ),
                            const SizedBox(width: 14),
                            if (i + 1 < snapshot.data!.docs.length)
                              Expanded(
                                child: PersonRow(
                                  imageLink: snapshot.data!.docs[i + 1]['imageUrls'][0] ?? 'https://firebasestorage.googleapis.com/v0/b/muslimmatt-270d5.appspot.com/o/profile_images%2Fimage_2023-10-19_000724079.png?alt=media&token=0111fcb2-b173-4a64-9ef6-70dee846d447&_gl=1*1tk9lym*_ga*MTc0MTQzMTkwLjE2OTI4MjAwNTA.*_ga_CW55HF8NVT*MTY5NzY1NjAzMC4zMy4xLjE2OTc2NTYwNzAuMjAuMC4w',
                                  name: snapshot.data!.docs[i + 1]['username'] ?? 'Name Not Set',
                                  profession: snapshot.data!.docs[i + 1]['profession'] ?? 'Profession Not Set',
                                  birthdate: snapshot.data!.docs[i + 1]['birth_date'] ?? '',
                                  documentId: snapshot.data!.docs[i + 1].id,
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18,),

              ],
            ),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
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
        child: const Center(
          // Your content here
        ),
      ),
    );
  }
}

class PersonRow extends StatelessWidget {
  final String imageLink;
  final String name;
  final String profession;
  final String birthdate;
  final String documentId;

  const PersonRow({
    super.key,
    required this.imageLink,
    required this.name,
    required this.profession,
    required this.birthdate,
    required this.documentId,
  });

  DateTime parseCustomDate(String date) {
    List<String> parts = date.split('/');
    final day = int.parse(parts[0]);
    final month = DateFormat.MMMM().parse(parts[1]).month;
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedBirthDate = parseCustomDate(birthdate);
    DateTime now = DateTime.now();
    int age = now.year - parsedBirthDate.year;

    return InkWell(
      onTap: () async {
        // Check if the document has the 'children' attribute
        bool hasChildren = await checkForChildrenAttribute(documentId);

        if (hasChildren) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ShowProfile(docID: documentId)));
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
        padding: const EdgeInsets.only(top: 14.0, bottom: 14.0,),
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
                const SizedBox(width: 20,),
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
      // Get a reference to the Firestore collection and document
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot document = await users.doc(documentId).get();

      // Check if the document exists and has a 'children' attribute
      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (data.containsKey('children')) {
          // The 'children' attribute exists in the document
          return true;
        }
      }
    } catch (e) {
      print("Error checking for 'children' attribute: $e");
    }

    // If the attribute doesn't exist or there was an error, return false
    return false;
  }

}
