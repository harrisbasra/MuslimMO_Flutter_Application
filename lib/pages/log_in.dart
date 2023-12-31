import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:test/pages/buffer_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/pages/set_prefrences.dart';

import 'package:test/pages/sign_up.dart';
import 'package:test/pages/splash_screen.dart';

import 'main_land.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    bool pass = false;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    String FBEmail;

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
        String? em;
        if (user?.email != null) {
          em = user?.email;
          String checkEmail = em.toString();

          // Query Firestore to check if the email exists in any document
          QuerySnapshot querySnapshot = await firestore
              .collection('users') // Replace with your Firestore collection name
              .where('email', isEqualTo: checkEmail)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            // Email exists in Firestore, you can print the document IDs
            for (QueryDocumentSnapshot doc in querySnapshot.docs) {
              writeFile(checkEmail, "log.in");
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainLand(docID: doc.id, filters: "",)));
            }
          } else {
            // Email doesn't exist in Firestore, show a snackbar to sign up
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Signup first.'),
              ),
            );
          }
        }
      }
    }

    Future<UserCredential> signInWithFacebook() async {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email']
      );

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

      final ud = await FacebookAuth.instance.getUserData();

      FBEmail = ud['email'];

      QuerySnapshot querySnapshot = await firestore
          .collection('users') // Replace with your Firestore collection name
          .where('email', isEqualTo: FBEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Email exists in Firestore, you can print the document IDs
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          writeFile(FBEmail, "log.in");
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainLand(docID: doc.id, filters: "",)));
        }
      } else {
        // Email doesn't exist in Firestore, show a snackbar to sign up
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup first.'),
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp(email: FBEmail)));
      }

      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    }


    Future<void> loginWithEmailAndPassword(String email, String password) async {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        // Check if the email exists in Firestore
        final QuerySnapshot snapshot = await firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Email exists in Firestore
          final DocumentSnapshot userDoc = snapshot.docs[0];
          final String storedPassword = userDoc['password'];

//          print("Document ID: " + userDoc.id);

          // Check if the entered password matches the stored password
          if (password == storedPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Successful'),
                duration: Duration(seconds: 3), // Adjust the duration as needed
              ),
            );
            writeFile(email, "log.in");
            Navigator.push(context, MaterialPageRoute(builder: (context)=> MainLand(docID: userDoc.id, filters: "",)));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wrong Password'),
                duration: Duration(seconds: 3), // Adjust the duration as needed
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User doesn\'t exist'),
              duration: Duration(seconds: 3), // Adjust the duration as needed
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connect to Internet'),
            duration: Duration(seconds: 3), // Adjust the duration as needed
          ),
        );
      }
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white,),
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
            )
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 25,),
              const Text(
                'Log In',
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
                  'Email',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ),
              const SizedBox(height: 14,),
              Container(
                height: 48,
                child: TextFormField(
                  cursorColor: const Color.fromRGBO(255, 0, 239, 1.0),

                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your Email or Phone Number',
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
                    'Password',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  )
              ),
              const SizedBox(height: 14,),
              Container(
                height: 48,
                child: TextFormField(
                  cursorColor: Color.fromRGBO(255, 0, 239, 1.0),
                  //obscureText: !pass,
                  obscureText: true,
                  obscuringCharacter: "●",
                  controller: passwordController,
                  decoration: InputDecoration(
                    // suffixIcon: InkWell(
                    //     onTap: (){
                    //       setState(() {
                    //         pass=!pass;
                    //       });
                    //     },
                    //     child: pass==true? Icon(Icons.visibility, color: Colors.grey.shade400,):Icon(Icons.visibility_off, color: Colors.grey.shade400,),),
                    hintText: 'Enter your Password',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400
                    ),
                    hintTextDirection: TextDirection.ltr,
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(800),
                      borderSide: const BorderSide(
                        color: Colors.black,
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
              const SizedBox(height: 24),
              InkWell(
                onTap: (){
                  final String email = emailController.text;
                  final String password = passwordController.text;
                  loginWithEmailAndPassword(email, password);
                },
                child: Image.asset(
                  'assets/images/logMB.png',

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
                  'assets/images/gLB.png',
                  height: 30,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: (){
                  signInWithFacebook();
                  // final String email = emailController.text;
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> BufferPage()));
                },
                child: Image.asset(
                  'assets/images/fLB.png',
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
                  'assets/images/aLB.png',
                  // width: MediaQuery.of(context).size.width * 0.5,
                  // fit: BoxFit.fitWidth,
                  height: 30,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUp(email: "",)));
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFF337C),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            )
          ),

          height: 50,
          child: const Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Don’t have an Account? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}