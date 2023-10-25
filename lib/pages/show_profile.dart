import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/pages/edit_prefrences.dart';

class ShowProfile extends StatefulWidget {
  final String docID;
  final bool CP;
  final String name;

  const ShowProfile({Key? key, required this.docID, required this.name, required this.CP}) : super(key: key);

  @override
  ShowProfileState createState() => ShowProfileState(docID: docID);
}

class ShowProfileState extends State<ShowProfile> {
  String docID;
  ShowProfileState({Key? key, required this.docID});

  String username = "";


  String religion = "";
  String cast = "Not Defined";
  String country = "";
  String live = "";
  String education = "";
  String job = "";
  String salary = "";
  String bio = "";
  String livingArrangement = "";
  String martialStatus = "";
  String keepHalal = "";
  String kids = "";
  String smoke = "";
  String willingRelocate = "";
  String praySalah = "";
  String hairColor = "";
  String height = "";
  String bodyBuild = "";
  String eyesColor = "";
  String preferHijab = "";
  String anyDisability = "";
  String lookingFor = "";
  String partnerLive = "";
  String partnerReligion = "";
  String partnerCast = "";
  String partnerEducation = "";
  String partnerProfession = "";
  List<String> imageUrl = [];

  Future<Map<String, dynamic>> fetchUserData(String docID) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot document = await users.doc(docID).get();

    if (document.exists) {
      // Convert the data to a map
      Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
      fetchUserData(docID).then((userData) {
        if (userData.isNotEmpty) {
          religion = userData['religion'];
          country = userData['country'];
          live = userData['country'];
          bio = userData['bio'];
          education = userData['education'];
          job = userData['job'];
          salary = userData['income'];
          livingArrangement = userData['livingArrange'];
          martialStatus = userData['maritalStatus'];
          keepHalal = userData['halal'];
          kids = userData['children'];
          smoke = userData['smokeFreq'];
          willingRelocate = userData['relocate'];
          praySalah = userData['salah'];
          hairColor = userData['hair'];
          height = userData['height'];
          bodyBuild = userData['buildCont'];
          eyesColor = userData['eyes'];
          preferHijab = userData['hijab'];
          anyDisability = userData['disability'];
          lookingFor = userData['partnerType'];
          partnerLive = userData['partnerLocation'];
          partnerReligion = userData['partnerReligion'];
          partnerCast = userData['partnerSect'];
          partnerEducation = userData['partnerEducation'];
          username = userData['username'];
          partnerProfession = userData['partnerProfession'];
          imageUrl = List<String>.from(userData['imageUrls']);
          //print("LOL:$imageUrl");
        } else {
          print('Document does not exist.');
        }
      });
      return userData;
    } else {
      return {}; // Return an empty map if the document doesn't exist
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FutureBuilder(
        future: fetchUserData(docID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.black,)); // Display a loader while waiting for data.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            imageUrl = List<String>.from(snapshot.data?['imageUrls']);
            religion = snapshot.data?['religion'];
            //cast = snapshot.data?['cast'];
            live = snapshot.data?['country'];
            bio = snapshot.data?['bio'];
            education = snapshot.data?['education'];
            job = snapshot.data?['job'];
            salary = snapshot.data?['income'];
            livingArrangement = snapshot.data?['livingArrange'];
            martialStatus = snapshot.data?['maritalStatus'];
            keepHalal = snapshot.data?['halal'];
            kids = snapshot.data?['children'];
            smoke = snapshot.data?['smokeFreq'];
            willingRelocate = snapshot.data?['relocate'];
            praySalah = snapshot.data?['salah'];
            hairColor = snapshot.data?['hair'];
            height = snapshot.data?['height'];
            bodyBuild = snapshot.data?['buildCont'];
            eyesColor = snapshot.data?['eyes'];
            preferHijab = snapshot.data?['hijab'];
            anyDisability = snapshot.data?['disability'];
            lookingFor = snapshot.data?['partnerType'];
            partnerLive = snapshot.data?['partnerLocation'];
            partnerReligion = snapshot.data?['partnerReligion'];
            partnerCast = snapshot.data?['partnerSect'];
            partnerEducation = snapshot.data?['partnerEducation'];
            partnerProfession = snapshot.data?['partnerProfession'];

            // Continue with your UI structure using the fetched data.
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 14,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            height: 0,
                          ),
                        ),
                        Image.asset("assets/icons/img_6.png", width: 80, fit: BoxFit.fitWidth,)
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      width: 150, // Adjust the size as needed
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 4, color: const Color(0xFF707070)),
                        image: DecorationImage(
                          image: NetworkImage(
                            imageUrl[0],
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18,),
                    Center(
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          height: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28,),
                    Container(
                      //height: 1000,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFF707070)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/img.png'), // Provide the image path
                          fit: BoxFit.cover, // You can choose how the image fits within the container
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x29000000),
                            blurRadius: 4.50,
                            offset: Offset(-6, -6),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 28,),
                            const Text(
                              'About me',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 28,),
                            Text(
                              bio,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                //height: 0.07,
                              ),
                            ),
                            const SizedBox(height: 28,),
                            Row(
                              children: [
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Religion",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                     SizedBox(height: 28,),

                                    Text(
                                      "Cast",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                     SizedBox(height: 28,),

                                    Text(
                                      "Live",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                     SizedBox(height: 28,),

                                    Text(
                                      "Education",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                     SizedBox(height: 28,),

                                    Text(
                                      "Job",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                     SizedBox(height: 28,),

                                    Text(
                                      "Salary",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                     SizedBox(height: 28,),

                                    Text(
                                      "Living Arrangement",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                     SizedBox(height: 28,),

                                    Text(
                                      "Marital Status",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                     SizedBox(height: 28,),

                                    Text(
                                      "Smoke",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                     SizedBox(height: 28,),

                                    Text(
                                      "Keep Halal",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                     SizedBox(height: 28,),

                                    Text(
                                      "Do You Want Kids",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),
                                    Text(
                                      "Willing to Relocate",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),
                                    Text(
                                      "Pray Salah",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                  ],
                                ),
                                const Expanded(child: SizedBox(width: 10,),),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      religion,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),
                                    Text(
                                      cast,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      country,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      education.length>10?education.replaceRange(10, education.length, ".."):education,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      job.length>10?job.replaceRange(10, job.length, ".."):job,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      salary.length>10?salary.replaceRange(10, salary.length, ".."):salary,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      livingArrangement,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      martialStatus,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      smoke,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      keepHalal,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      kids,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      willingRelocate,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      praySalah,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35,),
                    Container(
                      //height: 1000,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFF707070)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/img.png'), // Provide the image path
                          fit: BoxFit.cover, // You can choose how the image fits within the container
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x29000000),
                            blurRadius: 4.50,
                            offset: Offset(-6, -6),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 28,),
                            const Text(
                              'Body Type',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 28,),
                            Row(
                              children: [
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hair Color",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),

                                    Text(
                                      "Height",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),

                                    Text(
                                      "Body Build",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),

                                    Text(
                                      "Eyes Color",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),

                                    Text(
                                      "Prefer Hijab",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),

                                    Text(
                                      "Any Disability",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),
                                  ],
                                ),
                                const Expanded(child: SizedBox(width: 10,),),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        hairColor.length>10?hairColor.replaceRange(10, hairColor.length, ".."):hairColor,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 0.10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      height.length>10?height.replaceRange(10, height.length, ".."):height,

                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      bodyBuild.length>10?bodyBuild.replaceRange(10, bodyBuild.length, ".."):bodyBuild,

                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      eyesColor.length>10?eyesColor.replaceRange(10, eyesColor.length, ".."):eyesColor,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      preferHijab.length>10?preferHijab.replaceRange(10, preferHijab.length, ".."):preferHijab,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      anyDisability.length>10?anyDisability.replaceRange(10, anyDisability.length, ".."):anyDisability,

                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35,),
                    Container(
                      //height: 1000,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFF707070)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x29000000),
                            blurRadius: 4.50,
                            offset: Offset(-6, -6),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 28,),
                            const Text(
                              'Looking For',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 28,),
                            Text(
                              lookingFor,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                //height: 0.07,
                              ),
                            ),

                            const SizedBox(height: 30,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35,),
                    Container(
                      //height: 1000,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFF707070)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/img.png'), // Provide the image path
                          fit: BoxFit.cover, // You can choose how the image fits within the container
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x29000000),
                            blurRadius: 4.50,
                            offset: Offset(-6, -6),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 28,),
                            const Text(
                              'Type of Partner',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 28,),
                            Row(
                              children: [
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Partner Live",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),

                                    Text(
                                      "Partner Religion",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),

                                    Text(
                                      "Partner Cast",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),

                                    Text(
                                      "Partner Education",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),

                                    Text(
                                      "Partner Profession",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    SizedBox(height: 28,),
                                  ],
                                ),
                                const Expanded(child: SizedBox(width: 10,),),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      partnerLive,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      partnerReligion,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      partnerCast,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      partnerEducation.length>10?partnerEducation.replaceRange(10, partnerEducation.length, ".."):partnerEducation,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),

                                    Text(
                                      partnerProfession.length>10?partnerProfession.replaceRange(10, partnerProfession.length, ".."):partnerProfession,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                    const SizedBox(height: 28,),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 45,),
                  ],
                ),
              ),
            );
          } else {
            return const Text('Data not found');
          }
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
            icon: Image.asset("assets/icons/img_4.png", width: 30, height: 30,), // You can use any bell icon you prefer
            onPressed: () {
              // Add your bell icon functionality here
            },
          ),
          if(widget.CP==true)
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> EditPreferences(docID: docID)));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: const Icon(Icons.edit),
              )
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

        ),
      ),
    );
  }
}