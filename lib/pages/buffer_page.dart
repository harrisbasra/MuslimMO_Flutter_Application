import 'package:flutter/material.dart';
import 'package:test/pages/sign_up.dart';

class BufferPage extends StatelessWidget {
  const BufferPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
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
              'Social Login',
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
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your Social Email',
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
            InkWell(
              onTap: (){
                final String email = emailController.text;
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp(email: email)));
              },
              child: Image.asset(
                'assets/images/logMB.png',

                height: 40,
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: (){
          //Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUp(email: "",)));
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
        ),
      ),
    );
  }
}