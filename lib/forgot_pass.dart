import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/login_page.dart';

class Forgot_pass extends StatefulWidget {
  const Forgot_pass({super.key});

  @override
  State<StatefulWidget> createState() {
    return _forgotstate();
  }

}

class _forgotstate extends State<Forgot_pass> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(controller: email,
          decoration: InputDecoration(labelText: 'Enter Email-ID'),),
      ),
      ElevatedButton(onPressed: () {
        FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Check your Email to reset password'),
        ));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const login()));
      }, child: Text('Send Reset Email'))
    ],),),);
  }

}