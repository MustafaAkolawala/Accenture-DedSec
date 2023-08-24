import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Updateuser extends StatefulWidget {
  Updateuser({super.key});



  @override
  State<Updateuser> createState() {
    return _bottommodalstate();
  }
}

class _bottommodalstate extends State<Updateuser> {
  final _compcontroller = TextEditingController();

  void _submit(){
    if(_compcontroller.text.trim().isEmpty){
      showDialog(context: context, builder: (ctx)=> AlertDialog(title: Text('No Value entered'),content: Text('Please enter a username'),actions: [TextButton(onPressed: (){Navigator.pop(ctx);}, child: Text('close'))],));
      return;
    }
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'username': _compcontroller.text});
    Navigator.pop(context);
  }

  @override
  void dispose(){
    _compcontroller.dispose();
        super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _compcontroller,
            maxLength: 20,
            decoration: const InputDecoration(hintText: 'Company name'),
          ),
          const SizedBox(
            height: 20,
          ),

          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(onPressed: _submit, child: const Text('Update'))
            ],
          )
        ],
      ),
    );
  }
}