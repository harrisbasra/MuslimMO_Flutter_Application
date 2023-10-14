import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test/pages/buffer_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/pages/set_prefrences.dart';

import 'package:test/pages/sign_up.dart';


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

// function to implement the google signin

// creating firebase instance
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

          print("Document ID: " + userDoc.id);

          // Check if the entered password matches the stored password
          if (password == storedPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Successful'),
                duration: Duration(seconds: 3), // Adjust the duration as needed
              ),
            );
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SetPreferences(docID: userDoc.id)));
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25,),
            const Text(
              ' Log In',
              style: TextStyle(
                color: Colors.black,
                fontSize: 39,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
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
                cursorColor: Color.fromRGBO(255, 0, 239, 1.0),

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
                obscuringCharacter: "*",
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
              // onTap: (){
              //   final String email = emailController.text;
              //   Navigator.push(context, MaterialPageRoute(builder: (context)=> BufferPage()));
              // },
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