import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Changepass extends StatefulWidget {
  Changepass({super.key});



  @override
  State<Changepass> createState() {
    return _bottommodalstate();
  }
}

class _bottommodalstate extends State<Changepass> {
  final _compcontroller = TextEditingController();
  final _passcontroller = TextEditingController();

  void _validate()async{
final emailid= FirebaseAuth.instance.currentUser!.email.toString();
final password = _compcontroller.text.trim();
AuthCredential authCredential =  EmailAuthProvider.credential(email: emailid, password: password);
final bool =FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(authCredential);
if(bool != null){
  final newpassword = _passcontroller.text.trim();
  FirebaseAuth.instance.currentUser!.updatePassword(newpassword);
}
else{
  ScaffoldMessenger.of(context).clearSnackBars();
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter Correct password')));
}
Navigator.pop(context);


  }

  @override
  void dispose(){
    _compcontroller.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            autocorrect: false,
            controller: _compcontroller,
            maxLength: 20,
            decoration: const InputDecoration(hintText: 'Enter Current password'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: _passcontroller,
            maxLength: 20,
            decoration: const InputDecoration(hintText: 'Enter new password'),
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(onPressed: _validate, child: const Text('Update'))
            ],
          )
        ],
      ),
    );
  }
}
