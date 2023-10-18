import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test/pages/set_prefrences.dart';
import 'package:test/pages/sign_in.dart';

class SignUp extends StatefulWidget {
  final String email; // Add an email parameter to the constructo\r

  const SignUp({Key? key, required this.email}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState(email: email);
}

class _SignUpState extends State<SignUp> {


  final emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,4})$',
  );


  Country selectedCountry = Country(
      phoneCode: "92",
      countryCode: "KO",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Select your Country",
      example: "Pakistan",
      displayName: "Pakistan",
      displayNameNoCountryCode: "PAK",
      e164Key: "");

  bool isDropdownVisible = true;
  String selectedcountry = "Pakistan";


  final String email; // Add a field to store the email

  _SignUpState({required this.email});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController phoneControllerA = TextEditingController();
  final TextEditingController phoneControllerB = TextEditingController();

  // Dropdown selected values
  //late String selectedCountry= 'Pakistan';
  String selectedDate = '1';
  String selectedMonth = 'April';
  String selectedReason = 'I am registering to find myself a partner';
  String selectedHear = 'Friends';

  // Checkbox and radio button values
  bool isChecked = true; // Checkbox value
  bool isMaleSelected = true; // Male radio button value
  bool isFemaleSelected = false; // Female radio button value
  bool isNonBinarySelected = false; // Non-Binary radio button value
  bool isGenderSelected = true;



  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    fullNameController.dispose();
    emailController.dispose();
    confirmEmailController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  void saveUserDataToFirestore() async {
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        confirmEmailController.text.isEmpty ||
        passController.text.isEmpty ||
        phoneControllerB.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fill All Text Fields First'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Check if terms and conditions are checked
    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agree to Terms & Conditions'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Check if emails match
    if (passController.text != confirmEmailController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!emailRegex.hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email format'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Check if the email already exists in Firestore
    final query = await _firestore
        .collection('users')
        .where('email', isEqualTo: emailController.text)
        .get();

    if (query.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email already exists'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Create a Firestore document with user data
    final userDocument = {
      'username': fullNameController.text,
      'email': emailController.text,
      'password': passController.text,
      'gender': isMaleSelected
          ? 'Male'
          : isFemaleSelected
          ? 'Female'
          : 'Non-Binary',
      'phone_number': '+${phoneControllerA.text}${phoneControllerB.text}',
      'country': selectedCountry.name,
      'birth_date': '${selectedDate}/${selectedMonth}/${yearController.text}',
      'reason_for_registering': selectedReason,
      'heard_about_us': selectedHear,
      'profession' : "Not Set",
      'imageUrls' : ['https://firebasestorage.googleapis.com/v0/b/muslimmatt-270d5.appspot.com/o/profile_images%2Fimage_2023-10-19_000724079.png?alt=media&token=0111fcb2-b173-4a64-9ef6-70dee846d447&_gl=1*1tk9lym*_ga*MTc0MTQzMTkwLjE2OTI4MjAwNTA.*_ga_CW55HF8NVT*MTY5NzY1NjAzMC4zMy4xLjE2OTc2NTYwNzAuMjAuMC4w']
    };

    // Save the document to Firestore
    try {
      final DocumentReference docRef = await _firestore.collection('users').add(userDocument);
      Navigator.push(context, MaterialPageRoute(builder: (context) => SetPreferences(docID: docRef.id.toString())));
      // Document successfully saved, you can show a success message or navigate to another screen.
    } catch (e) {
      // Handle any errors that occur during the saving process.
      print('Error saving user data: $e');
      // You can display an error message here.
    }
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
                ' Sign Up',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 39,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  height: 0,
                ),
              ),
              const SizedBox(height: 35),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Username',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 14,),
              SizedBox(
                height: 48,
                child: Center(
                  child: TextFormField(

                    cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                    keyboardType: TextInputType.emailAddress,
                    controller: fullNameController, // Assign the controller
                    decoration: InputDecoration(
                      hintText: 'Enter your Full Name',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400
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
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 14,),
              Container(
                height: 48,
                child: TextFormField(
                  cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController, // Assign the controller
                  decoration: InputDecoration(
                    hintText: 'Enter your Email',
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
              const SizedBox(height: 20,),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 14,),
              SizedBox(
                height: 48,
                child: TextFormField(
                  obscureText: true,
                  cursorColor: Color.fromRGBO(255, 0, 239, 1.0),

                  obscuringCharacter: "●",

                  controller: passController, // Assign the controller
                  decoration: InputDecoration(
                    hintText: 'Password',
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
              const SizedBox(height: 20),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Confirm your Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 14,),
              SizedBox(
                height: 48,
                child: TextFormField(
                  cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                  obscureText: true,
                  obscuringCharacter: "●",
                  controller: confirmEmailController, // Assign the controller
                  decoration: InputDecoration(
                    hintText: 'Retype your Password',
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
              const SizedBox(height: 20,),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Gender',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 14,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Male',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
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
                      fontSize: 18,
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
                      fontSize: 18,
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
              const SizedBox(height: 20,),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 14,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      menuMaxHeight: 220,
                      value: null,
                      icon:             Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCountryCode = newValue!;
                        });
                      },
                      items: countryCodes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.grey.shade400, size: 30,),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(255, 0, 239, 1.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width:10),
                  Expanded(
                    flex: 6,
                    child: TextFormField(
                      cursorColor: Color.fromRGBO(255, 0, 239, 1.0),

                      controller: phoneControllerB,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(255, 0, 239, 1.0)), // Pink underline
                        ),
                        prefixStyle: TextStyle(color: Colors.black),
                        hintText: '',

                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Where do you live?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 14,),
              Visibility(
                visible: false,
                child: InkWell(
                  onTap: (){
                    setState(() {
                      isDropdownVisible = false; // Hide the dropdown after selection
                    });
                  },
                  child: DropdownButtonFormField<String>(
                    menuMaxHeight: 220,
                    icon: Image.asset("assets/icons/img.png", width: 20, height: 20),
                    iconSize: 18,
                    value: null, // Assign the selected value
                    onChanged: (newValue) {
                      setState(() {
                        selectedcountry = newValue!;
                        isDropdownVisible = false; // Hide the dropdown after selection
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Select your country',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(255, 0, 239, 1.0),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(255, 0, 239, 1.0),
                          width: 1.0,
                        ),
                      ),
                    ),
                    items: null,
                  ),
                ),
              ),

              // Container that appears when the dropdown is hidden
              Visibility(
                visible: true,
                child: Container(
                  width: 120,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(800),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: (){
                        showCountryPicker(
                            context: context,
                            countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 450
                            ),
                            onSelect: (value){
                              setState(() {
                                selectedCountry=value;
                              });
                            });
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${selectedCountry.flagEmoji} ${selectedCountry.name}",
                              style: selectedCountry.name == "Select your Country"
                                  ? TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400, // Change color to grey
                                fontWeight: FontWeight.w600,
                              )
                                  : const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            )

                          ),
                          const Expanded(child: SizedBox(width: 10)),
                          Image.asset("assets/icons/img.png", width: 20, height: 20),
                          SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Your Birth Date',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 14,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child:  DropdownButtonFormField<String>(
                      iconSize: 18,
                      icon: const Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black),
                      value: null,
                      menuMaxHeight: 220,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDate = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(255, 0, 239, 1.0),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(255, 0, 239, 1.0),
                            width: 1.0,
                          ),
                        ),
                        hintText: 'Day',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400
                        ),
                        fillColor: Colors.white,
                        filled: true,

                      ),
                      items: <String>['1', '2', '3', '4', '5', '6','7','8','9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23','24','25','26','27','28','29','30','31'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(
                              color: Colors.black
                          ),),
                        );
                      }).toList(),

                    ),
                  ),
                  const SizedBox(width:10),
                  Expanded(
                    flex: 2,
                    child:  DropdownButtonFormField<String>(
                      icon: const Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black),

                      iconSize: 18,
                      menuMaxHeight: 220,
                      value: null,
                      onChanged: (newValue) {
                        setState(() {
                          selectedMonth = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(255, 0, 239, 1.0),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(255, 0, 239, 1.0),
                            width: 1.0,
                          ),
                        ),
                        hintText: 'Month',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      items: <String>['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'].map((String value) {
                  return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(
                      color: Colors.black
                  ),),
                  );
                  }).toList(),

              ),
                  ),
                  const SizedBox(width:10),
                  Expanded(
                    flex: 1,
                    child:  TextFormField(
                      cursorColor:  const Color.fromRGBO(255, 0, 239, 1.0),

                      keyboardType: TextInputType.number,
                      controller: yearController, // Assign the controller
                      decoration: InputDecoration(
                        hintText: 'Year',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(255, 0, 239, 1.0),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(255, 0, 239, 1.0),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Reason for Registering',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 14,),
              DropdownButtonFormField<String>(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset("assets/icons/img.png", width: 20, height: 20,),
                ),
                iconSize: 18,

                value: null,
                onChanged: (newValue) {
                  setState(() {
                    selectedReason = newValue!;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Select your reason',
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
                items: <String>[
                  'I am registering to find myself a partner',
                  'I am registering to find my friend a partner',
                  'I am registering to find my son a partner',
                  'I am registering to find my daughter a partner',
                  'I am registering to find my brother a partner'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black
                    ),),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Where did you hear about us?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 14,),
              DropdownButtonFormField<String>(

                icon: Image.asset("assets/icons/img.png", width: 20, height: 20,),
                iconSize: 18,

                value: null,
                onChanged: (newValue) {
                  setState(() {
                    selectedHear = newValue!;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Select your reason',

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
                items: <String>[
                  'Friends',
                  'App Store',
                  'Advertisement',
                  'Family',
                  'Other'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 14,color: Colors.black),),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Text(
                    '*Required Fields',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  const Expanded(child: SizedBox(width: 10,),),
                  const Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Checkbox(
                    value: isChecked, // Use the variable to set the checkbox value
                    activeColor: const Color.fromRGBO(255, 0, 239, 1.0),
                    onChanged: (newValue) {
                      setState(() {
                        isChecked = newValue!;
                      });
                    },

                    focusColor: const Color.fromRGBO(255, 0, 239, 1.0),
                    hoverColor: Color.fromRGBO(255, 0, 239, 1.0),
                    checkColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Read Terms and Conditions',
                    style: TextStyle(
                      color: Color(0xFF229CEF),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 25,)
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  saveUserDataToFirestore(); // Call the method to save data to Firestore
                },
                child: Image.asset(
                  'assets/images/logoB2e.png',
                  height: 40,
                  fit: BoxFit.fitHeight,
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'or',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: (){
                  signup(context);
                },
                child: Image.asset(
                  'assets/icons/img_1.png',
                  height: 30,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                // onTap: (){
                //   final String email = emailController.text;
                //   Navigator.push(context, MaterialPageRoute(builder: (context)=> BufferPage()));
                // },
                child: Image.asset(
                  'assets/icons/img_2.png',
                  height: 30,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                // onTap: (){
                //   final String email = emailController.text;
                //   Navigator.push(context, MaterialPageRoute(builder: (context)=> BufferPage()));
                // },
                child: Image.asset(
                  'assets/icons/img_3.png',
                  height: 30,
                  fit: BoxFit.fitHeight,
                ),
              ),
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

  @override
  void initState() {
    emailController.text = email;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;
      String? em ;
      if(user?.email!=null){
        em = user?.email;
      }

      if (result != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUp(email: em.toString())));
      } // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }


  List<String> allCountries = [
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

  String selectedCountryCode = "+1";

  List<String> countryCodes = [
    "+1", "+7", "+20", "+27", "+30", "+31", "+32", "+33", "+34", "+36",
    "+39", "+40", "+41", "+43", "+44", "+45", "+46", "+47", "+48", "+49",
    "+51", "+52", "+53", "+54", "+55", "+56", "+57", "+58", "+60", "+61",
    "+62", "+63", "+64", "+65", "+66", "+81", "+82", "+84", "+86", "+90",
    "+91", "+92", "+93", "+94", "+95", "+98", "+211", "+212", "+213", "+216",
    "+218", "+220", "+221", "+222", "+223", "+224", "+225", "+226", "+227",
    "+228", "+229", "+230", "+231", "+232", "+233", "+234", "+235", "+236",
    "+237", "+238", "+239", "+240", "+241", "+242", "+243", "+244", "+245",
    "+246", "+247", "+248", "+249", "+250", "+251", "+252", "+253", "+254",
    "+255", "+256", "+257", "+258", "+260", "+261", "+262", "+263", "+264",
    "+265", "+266", "+267", "+268", "+269", "+290", "+291", "+297", "+298",
    "+299", "+350", "+351", "+352", "+353", "+354", "+355", "+356", "+357",
    "+358", "+359", "+370", "+371", "+372", "+373", "+374", "+375", "+376",
    "+377", "+378", "+379", "+380", "+381", "+382", "+383", "+385", "+386",
    "+387", "+389", "+420", "+421", "+423", "+500", "+501", "+502", "+503",
    "+504", "+505", "+506", "+507", "+508", "+509", "+590", "+591", "+592",
    "+593", "+594", "+595", "+596", "+597", "+598", "+599", "+670", "+672",
    "+673", "+674", "+675", "+676", "+677", "+678", "+679", "+680", "+681",
    "+682", "+683", "+685", "+686", "+687", "+688", "+689", "+690", "+691",
    "+692", "+850", "+852", "+853", "+855", "+856", "+870", "+880", "+886",
    "+960", "+961", "+962", "+963", "+964", "+965", "+966", "+967", "+968",
    "+970", "+971", "+972", "+973", "+974", "+975", "+976", "+977", "+992",
    "+993", "+994", "+995", "+996", "+998", "+1242", "+1246", "+1264", "+1268",
    "+1340", "+1345", "+1441", "+1473", "+1649", "+1664", "+1670", "+1758", "+1767",
    "+1784", "+1787", "+1809", "+1868", "+1869", "+1876",
  ];
}
