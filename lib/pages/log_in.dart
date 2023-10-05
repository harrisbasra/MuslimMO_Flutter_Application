import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your Email or Phone Number',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(800),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1.0,
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
            TextFormField(
              obscureText: true,
              obscuringCharacter: "*",
              decoration: InputDecoration(

                hintText: 'Enter your Password',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(800),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/logMB.png',

              height: 40,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 24),
            const Text(
              'or',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/gLB.png',
              height: 30,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 15),
            Image.asset(
              'assets/images/fLB.png',
              height: 30,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 15),
            Image.asset(
              'assets/images/aLB.png',
              // width: MediaQuery.of(context).size.width * 0.5,
              // fit: BoxFit.fitWidth,
              height: 30,
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
                  text: 'Sign in',
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
    );
  }
}