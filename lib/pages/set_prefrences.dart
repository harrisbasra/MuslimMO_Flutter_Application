import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:test/pages/show_profile.dart';
import 'package:test/pages/sign_in.dart';

class SetPreferences extends StatefulWidget {
  final String docID;

  const SetPreferences({Key? key, required this.docID}) : super(key: key);

  @override
  SetPreferencesState createState() => SetPreferencesState(docID: docID);
}

class SetPreferencesState extends State<SetPreferences> {
  String docID;
  SetPreferencesState({Key? key, required this.docID});

  final emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,4})$',
  );

  final TextEditingController headlineController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController tongueController = TextEditingController();
  final TextEditingController slangController = TextEditingController();

  final TextEditingController citizenshipController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController relocateController = TextEditingController();
  final TextEditingController childrenController = TextEditingController();

  final TextEditingController heightController = TextEditingController();
  final TextEditingController hairController = TextEditingController();
  final TextEditingController eyesController = TextEditingController();
  final TextEditingController disabilityController = TextEditingController();

  final TextEditingController revertController = TextEditingController();


  final TextEditingController partnerEducation = TextEditingController();
  final TextEditingController partnerProfession = TextEditingController();
  final TextEditingController partnerTypeController = TextEditingController();



  bool isMaleSelected = true; // Male radio button value
  bool isFemaleSelected = false; // Female radio button value
  bool isNonBinarySelected = false; // Non-Binary radio button value

  bool yesChildren = true; // Male radio button value
  bool noChildren = false; // Female radio button value
  bool maybeChildren = false; // Non-Binary radio button value

  bool yesHijab = true;
  bool noHijab = false;
  bool ocasHijab = false;

  bool yesBeard = true;
  bool noBeard = false;
  bool trendBeard = false;

  bool yesSalah = true;
  bool noSalah = false;
  bool ocasSalah = false;

  bool yesZakat = true;
  bool noZakat = false;
  bool someZakat = false;

  bool yesRamadan = true;
  bool noRamadan = false;
  bool fewRamadan = false;

  String? maritalStatus;
  String? maritalTime;
  String? livingArrange;

  String? smokeFreq;
  String? buildCont;

  String? religionController;
  String? sectController;
  String? halalController;

  String? partnerLocation;
  String? partnerReligion;
  String? partnerSect;

  List<String> imageUrls = [];
  List<String> allCountries = [
    "Doesn't Matter",
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Argentina',
    'Australia',
    'Austria',
    'Bahrain',
    'Bangladesh',
    'Belgium',
    'Brazil',
    'Canada',
    'Chile',
    'China',
    'Colombia',
    'Czech Republic',
    'Denmark',
    'Egypt',
    'Estonia',
    'Finland',
    'France',
    'Germany',
    'Greece',
    'Hungary',
    'India',
    'Indonesia',
    'Ireland',
    'Israel',
    'Italy',
    'Japan',
    'Kenya',
    'Kuwait',
    'Lebanon',
    'Malaysia',
    'Mexico',
    'Netherlands',
    'New Zealand',
    'Nigeria',
    'Norway',
    'Pakistan',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Saudi Arabia',
    'Singapore',
    'South Africa',
    'South Korea',
    'Spain',
    'Sweden',
    'Switzerland',
    'Taiwan',
    'Thailand',
    'Turkey',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Vietnam',
    'Zimbabwe',
  ];

  late XFile? selectedImage = null;

  List<XFile?> plusImages = [null, null, null, null]; // Store selected images for plus icons

  Future<void> uploadImagesToFirebase(String docID) async {
    final firebaseStorage = FirebaseStorage.instance;
    final storage = firebaseStorage.ref();

     // Create an empty list to store download URLs

    if (selectedImage != null) {
      final profileImageRef = storage.child('profile_images/${selectedImage?.name}).jpg');
      final profileImageTask = await profileImageRef.putFile(File(selectedImage!.path));
      final profileImageDownloadURL = await profileImageTask.ref.getDownloadURL();
      imageUrls.add(profileImageDownloadURL); // Add the URL to the list
    }

    // Upload the plus images and get their download URLs
    for (int i = 0; i < plusImages.length; i++) {
      if (plusImages[i] != null) {
        final plusImageRef = storage.child('profile_images/${plusImages[i]?.name}.jpg');
        final plusImageTask = await plusImageRef.putFile(File(plusImages[i]!.path));
        final plusImageDownloadURL = await plusImageTask.ref.getDownloadURL();
        imageUrls.add(plusImageDownloadURL); // Add the URL to the list
      }
    }

    // Now, store the 'imageUrls' list in Firestore as an array
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(docID).update({
      'imageUrls': imageUrls,
    });
  }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  Future<void> pickPlusImage(int index) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        plusImages[index] = pickedImage;
      });
    }
  }

  void informPreferences() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Create a map with the information you want to update
    Map<String, dynamic> data = {
      'headline': headlineController.text,
      'bio': bioController.text,
      'education': educationController.text,
      'profession': professionController.text,
      'job': jobController.text,
      'tongue': tongueController.text,
      'slang': slangController.text,
      'citizenship': citizenshipController.text,
      'income': incomeController.text,
      'relocate': relocateController.text,
      'children': childrenController.text,
      'height': heightController.text,
      'hair': hairController.text,
      'eyes': eyesController.text,
      'disability': disabilityController.text,
      'revert': revertController.text,
      'partnerEducation': partnerEducation.text,
      'partnerProfession': partnerProfession.text,
      'partnerType': partnerTypeController.text,
      'gender': isMaleSelected ? 'Male' : isFemaleSelected ? 'Female' : 'Non-Binary',
      'children': yesChildren ? 'Yes' : noChildren ? 'No' : 'Maybe',
      'hijab': yesHijab ? 'Yes' : noHijab ? 'No' : 'Occasionally',
      'beard': yesBeard ? 'Yes' : noBeard ? 'No' : 'Trendy',
      'salah': yesSalah ? 'Yes' : noSalah ? 'No' : 'Occasionally',
      'zakat': yesZakat ? 'Yes' : noZakat ? 'No' : 'Some',
      'ramadan': yesRamadan ? 'Yes' : noRamadan ? 'No' : 'A Few',
      'maritalStatus': maritalStatus,
      'maritalTime': maritalTime,
      'livingArrange': livingArrange,
      'smokeFreq': smokeFreq,
      'buildCont': buildCont,
      'religion': religionController,
      'sect': sectController,
      'halal': halalController,
      'partnerLocation': partnerLocation,
      'partnerReligion': partnerReligion,
      'partnerSect': partnerSect,
      'imageUrls': imageUrls,
    };

    users.doc(docID).update(data).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preferences Saved Successfully'),
          duration: Duration(seconds: 3), // Adjust the duration as needed
        ),
      );
      //Navigator.push(context, MaterialPageRoute(builder: (context) => ShowProfile(docID: docID)));
    }).catchError((error) {
      print("LOL ERROR 1: "+error);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connect to Internet'),
          duration: Duration(seconds: 3), // Adjust the duration as needed
        ),
      );
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const SelectHording()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 25,),
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
              const SizedBox(height: 18,),
              InkWell(
                onTap: () {
                  pickImage(); // Open image picker
                },
                child: selectedImage == null
                    ? Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle
                      ),
                      child: ClipOval(
                          child: Image.asset(
                            'assets/images/user.png',
                            width: 7.5,
                            height: 350,
                            fit: BoxFit.contain, // Use 'cover' to ensure it covers the circle
                          ),
                  ),
                    )
                    : ClipOval(
                        child: Image.file(
                          File(selectedImage!.path),
                          width: 7.5,
                          height: 320,
                          fit: BoxFit.cover, // Use 'cover' to ensure it covers the circle
                        ),
                ),
              ),
              const SizedBox(height: 12,),
              const Center(
                child: Text(
                  'Upload Profile Image',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12,),
              Container(
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
                      const SizedBox(height: 10,),
                      const Center(
                        child: Text(
                          'Profile Info',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Headline',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: headlineController,
                                cursorColor: const Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Enter a Headline',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'About Me',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              //height: 48,
                              child: TextField(
                                controller: bioController,
                                maxLines: 8,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Tell Something About Your-self, Family & career',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'What I am looking for',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Male',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isMaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                isMaleSelected = newValue!;
                                isFemaleSelected = false; // Set the other options to false
                                isNonBinarySelected = false;
                              });
                            },
                            groupValue: isMaleSelected, // Use isMaleSelected as the group value
                          ),
                          const Text(
                            'Female',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isFemaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                isMaleSelected = false; // Set the other options to false
                                isFemaleSelected = newValue!;
                                isNonBinarySelected = false;
                              });
                            },
                            groupValue: isFemaleSelected, // Use isFemaleSelected as the group value
                          ),
                          const Text(
                            'Non-Binary',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isNonBinarySelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                isMaleSelected = false; // Set the other options to false
                                isFemaleSelected = false;
                                isNonBinarySelected = newValue!;
                              });
                            },
                            groupValue: isNonBinarySelected, // Use isNonBinarySelected as the group value
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Education Level',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: educationController,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'My Job Title',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: jobController,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'My Profession',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: professionController,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Mother Tongue',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: tongueController,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Second Language',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: slangController,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22,),
                    ],
                  ),
                ),
              ),  // Container 1
              const SizedBox(height: 18,),
              Container(
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
                      const SizedBox(height: 10,),
                      const Center(
                        child: Text(
                          'Personal Info',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'My Citizenship',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: citizenshipController,
                                cursorColor: const Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'My Income',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: incomeController,
                                //maxLines: 8,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Marital Status',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.5,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: DropdownButtonFormField<String>(
                                menuMaxHeight: 220,
                                icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                                iconSize: 18,
                                value: maritalStatus, // Assign the selected value
                                onChanged: (newValue) {
                                  maritalStatus = newValue;
                                },
                                decoration: InputDecoration(
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                ),
                                items: <String>["Never Married", "Legally Separated", "Divorced", "Widowed","Annulled"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400
                                    ),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Looking to Marry',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: DropdownButtonFormField<String>(
                              menuMaxHeight: 220,
                              icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                              iconSize: 18,
                              value: maritalTime, // Assign the selected value
                              onChanged: (newValue) {
                                maritalTime = newValue;
                              },
                              decoration: InputDecoration(
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
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              ),
                                items: <String>["As Soon As Possible", "This Year", "Next Year", "Not Sure"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                        color: Colors.black,
                                      fontWeight: FontWeight.w400
                                    ),),
                                  );
                                }).toList(),

                            ),
                          ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Willing to Relocate',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: relocateController,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'What I like to have Children?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isMaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesChildren = newValue!;
                                noChildren = false; // Set the other options to false
                                maybeChildren = false;
                              });
                            },
                            groupValue: yesChildren, // Use isMaleSelected as the group value
                          ),
                          const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isFemaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesChildren = false; // Set the other options to false
                                noChildren = newValue!;
                                maybeChildren = false;
                              });
                            },
                            groupValue: noChildren, // Use isFemaleSelected as the group value
                          ),
                          const Text(
                            'Maybe',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isNonBinarySelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesChildren = false; // Set the other options to false
                                noChildren = false;
                                maybeChildren = newValue!;
                              });
                            },
                            groupValue: maybeChildren, // Use isNonBinarySelected as the group value
                          ),
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Do I Have Children?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: childrenController,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Living Arrangements',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: DropdownButtonFormField<String>(
                              menuMaxHeight: 220,
                              icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                              iconSize: 18,
                              value: livingArrange, // Assign the selected value
                              onChanged: (newValue) {
                                livingArrange = newValue;
                              },
                              decoration: InputDecoration(
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
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              ),
                              items: <String>["Live with Family", "Separate", "Alone"].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: const TextStyle(
                                      color: Colors.black
                                  ),),
                                );
                              }).toList(),
                            ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22,),
                    ],
                  ),
                ),
              ),  // Container 2
              const SizedBox(height: 18,),
              Container(
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
                      const SizedBox(height: 10,),
                      const Center(
                        child: Text(
                          'Body Type',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'My Height',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: heightController,
                                cursorColor: const Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: const Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'My Build',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 17,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: DropdownButtonFormField<String>(
                                menuMaxHeight: 220,
                                icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                                iconSize: 18,
                                value: buildCont, // Assign the selected value
                                onChanged: (newValue) {
                                  buildCont = newValue;
                                },
                                decoration: InputDecoration(
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                ),
                                items: <String>["Normal", "Muscular", "Fat", "Slim"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400
                                    ),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Hair Color',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: hairController,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Eyes Color',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: eyesController,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Do I Smoke?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: DropdownButtonFormField<String>(
                                menuMaxHeight: 220,
                                icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                                iconSize: 18,
                                value: smokeFreq, // Assign the selected value
                                onChanged: (newValue) {
                                  smokeFreq = newValue;
                                },
                                decoration: InputDecoration(
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                ),
                                items: <String>["No", "Yes", "Special Occassion", "Sometimes"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400

                                    ),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Disabilities?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              //height: 48,
                              child: TextField(
                                controller: disabilityController,
                                maxLines: 8,
                                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22,),
                    ],
                  ),
                ),
              ),  // Container 3
              const SizedBox(height: 12,),
              Container(
                // height: 100,
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
                      const SizedBox(height: 10,),
                      const Center(
                        child: Text(
                          'Religion',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Religiousness',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: DropdownButtonFormField<String>(
                                menuMaxHeight: 220,
                                icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                                iconSize: 18,
                                value: religionController, // Assign the selected value
                                onChanged: (newValue) {
                                  religionController = newValue;
                                },
                                decoration: InputDecoration(
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                ),
                                items: <String>["Muslim", "Hindu", "Christian", "Sikh", "Jew"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400

                                    ),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'My Sect',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 33,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: DropdownButtonFormField<String>(
                                menuMaxHeight: 220,
                                icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                                iconSize: 18,
                                value: sectController, // Assign the selected value
                                onChanged: (newValue) {
                                  sectController = newValue;
                                },
                                decoration: InputDecoration(
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                ),
                                items: <String>["Only Muslim", "Wahabi", "Suni", "Shia"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400

                                    ),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Do you wear a Hijab?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isMaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesHijab = newValue!;
                                noHijab = false; // Set the other options to false
                                ocasHijab = false;
                              });
                            },
                            groupValue: yesHijab, // Use isMaleSelected as the group value
                          ),
                          const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isFemaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesHijab = false; // Set the other options to false
                                noHijab = newValue!;
                                ocasHijab = false;
                              });
                            },
                            groupValue: noHijab, // Use isFemaleSelected as the group value
                          ),
                          const Text(
                            'Occasionally',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isNonBinarySelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesHijab = false; // Set the other options to false
                                noHijab = false;
                                ocasHijab = newValue!;
                              });
                            },
                            groupValue: ocasHijab, // Use isNonBinarySelected as the group value
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Do you prefer a Beard?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isMaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesBeard = newValue!;
                                noBeard = false; // Set the other options to false
                                trendBeard = false;
                              });
                            },
                            groupValue: yesBeard, // Use isMaleSelected as the group value
                          ),
                          const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isFemaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesBeard = false; // Set the other options to false
                                noBeard = newValue!;
                                trendBeard = false;
                              });
                            },
                            groupValue: noBeard, // Use isFemaleSelected as the group value
                          ),
                          const Text(
                            'Trend',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isNonBinarySelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesBeard = false; // Set the other options to false
                                noBeard = false;
                                trendBeard = newValue!;
                              });
                            },
                            groupValue: trendBeard, // Use isNonBinarySelected as the group value
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Are you a Revert?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: revertController,
                                //maxLines: 8,
                                cursorColor: const Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Do you keep Halal',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: DropdownButtonFormField<String>(
                                menuMaxHeight: 220,
                                icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                                iconSize: 18,
                                value: halalController, // Assign the selected value
                                onChanged: (newValue) {
                                    halalController = newValue;
                                },
                                decoration: InputDecoration(
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                ),
                                items: <String>["Yes", "No", "Sometimes"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400

                                    ),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Do you perform Salah?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isMaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesSalah = newValue!;
                                noSalah = false; // Set the other options to false
                                ocasSalah = false;
                              });
                            },
                            groupValue: yesSalah, // Use isMaleSelected as the group value
                          ),
                          const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isFemaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesSalah = false; // Set the other options to false
                                noSalah = newValue!;
                                ocasSalah = false;
                              });
                            },
                            groupValue: noSalah, // Use isFemaleSelected as the group value
                          ),
                          const Text(
                            'Ocassionally',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isNonBinarySelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesSalah = false; // Set the other options to false
                                noSalah = false;
                                ocasSalah = newValue!;
                              });
                            },
                            groupValue: ocasSalah, // Use isNonBinarySelected as the group value
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Do you pay Zakat?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isMaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesZakat = newValue!;
                                noZakat = false; // Set the other options to false
                                someZakat = false;
                              });
                            },
                            groupValue: yesZakat, // Use isMaleSelected as the group value
                          ),
                          const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isFemaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesZakat = false; // Set the other options to false
                                noZakat = newValue!;
                                someZakat = false;
                              });
                            },
                            groupValue: noZakat, // Use isFemaleSelected as the group value
                          ),
                          const Text(
                            'Sometimes',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isNonBinarySelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesZakat = false; // Set the other options to false
                                noZakat = false;
                                someZakat = newValue!;
                              });
                            },
                            groupValue: someZakat, // Use isNonBinarySelected as the group value
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Do you Fast in the month of Ramadan?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isMaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesRamadan = newValue!;
                                noRamadan = false; // Set the other options to false
                                fewRamadan = false;
                              });
                            },
                            groupValue: yesRamadan, // Use isMaleSelected as the group value
                          ),
                          const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isFemaleSelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesRamadan = false; // Set the other options to false
                                noRamadan = newValue!;
                                fewRamadan = false;
                              });
                            },
                            groupValue: noRamadan, // Use isFemaleSelected as the group value
                          ),
                          const Text(
                            'A Few',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          Radio<bool>(
                            value: true, // Assign true to isNonBinarySelected
                            activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                            onChanged: (newValue) {
                              setState(() {
                                yesRamadan = false; // Set the other options to false
                                noRamadan = false;
                                fewRamadan = newValue!;
                              });
                            },
                            groupValue: fewRamadan, // Use isNonBinarySelected as the group value
                          ),
                        ],
                      ),
                      const SizedBox(height: 22,),
                    ],
                  ),
                ),
              ),  // Container 4
              const SizedBox(height: 12,),
              Container(
                //height: 100,
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
                      const SizedBox(height: 14,),
                      const Center(
                        child: Text(
                          'Type of Partner Your Looking for',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Partner Location',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: DropdownButtonFormField<String>(
                                menuMaxHeight: 220,
                                icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                                iconSize: 18,
                                value: partnerLocation, // Assign the selected value
                                onChanged: (newValue) {
                                  partnerLocation = newValue;
                                },
                                decoration: InputDecoration(
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                ),
                                items: allCountries.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400

                                    ),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Partner Religion',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: DropdownButtonFormField<String>(
                                menuMaxHeight: 220,
                                icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                                iconSize: 18,
                                value: partnerReligion, // Assign the selected value
                                onChanged: (newValue) {
                                  partnerReligion = newValue;
                                },
                                decoration: InputDecoration(
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                ),
                                items: <String>["Doesn't Matter", "Hindu", "Muslim", "Christian"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400

                                    ),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Partner Sect',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 22,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: DropdownButtonFormField<String>(
                                menuMaxHeight: 220,
                                icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                                iconSize: 18,
                                value: partnerSect, // Assign the selected value
                                onChanged: (newValue) {
                                  partnerSect = newValue;
                                },
                                decoration: InputDecoration(
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                ),
                                items: <String>["Doesn't Matter", "Only Muslim", "Shia", "Suni"].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400

                                    ),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Partner Education',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: partnerEducation,
                                cursorColor: const Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Partner Profession',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: partnerProfession,
                                //maxLines: 8,
                                cursorColor: const Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: const Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(800),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Describe Type of Partner',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              '                             ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              //height: 48,
                              child: TextField(
                                controller: partnerTypeController,
                                maxLines: 8,
                                cursorColor: const Color.fromRGBO(255, 0, 239, 1.0),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: null,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 0, 239, 1.0),
                                      width: 1.0,
                                    ),
                                  ),
                                  isDense: true,
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22,),
                    ],
                  ),
                ),
              ),  // Container 5
              const SizedBox(height: 18,),
              const Center(
                child: Text(
                  'Add More Pics',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 22,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      pickPlusImage(0);
                    },
                    child: plusImages[0] == null
                        ? Image.asset("assets/icons/plus.png", width: 76, height: 76)
                        : Image.file(
                      File(plusImages[0]!.path),
                      width: 76,
                      height: 76,
                      fit: BoxFit.contain,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pickPlusImage(1);
                    },
                    child: plusImages[1] == null
                        ? Image.asset("assets/icons/plus.png", width: 76, height: 76)
                        : Image.file(
                      File(plusImages[1]!.path),
                      width: 76,
                      height: 76,
                      fit: BoxFit.contain,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pickPlusImage(2);
                    },
                    child: plusImages[2] == null
                        ? Image.asset("assets/icons/plus.png", width: 76, height: 76)
                        : Image.file(
                      File(plusImages[2]!.path),
                      width: 76,
                      height: 76,
                      fit: BoxFit.contain,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pickPlusImage(3);
                    },
                    child: plusImages[3] == null
                        ? Image.asset("assets/icons/plus.png", width: 76, height: 76)
                        : Image.file(
                      File(plusImages[3]!.path),
                      width: 76,
                      height: 76,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22,),
              InkWell(
                  onTap: (){
                    uploadImagesToFirebase(docID);
                    informPreferences();
                  },
                  child: Image.asset("assets/images/create.png", width: 122, height: 42,)
              ),
              const SizedBox(height: 45,),
            ],
          ),
        ),
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