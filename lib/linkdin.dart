import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Linkdin extends StatefulWidget {
  Linkdin({super.key});



  @override
  State<Linkdin> createState() {
    return _bottommodalstate();
  }
}

class _bottommodalstate extends State<Linkdin> {
  final _biocontroller = TextEditingController();

  void _submit(){
    if(_biocontroller.text.trim().isEmpty){
      showDialog(context: context, builder: (ctx)=> AlertDialog(title: Text('No Value entered'),content: Text('Please enter Linkdin profile link'),actions: [TextButton(onPressed: (){Navigator.pop(ctx);}, child: Text('close'))],));
      return;
    }
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'Linkdin_url': _biocontroller.text});
    Navigator.pop(context);
  }

  @override
  void dispose(){
    _biocontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 50),
      child: Column(
        children: [
          TextField(
            controller: _biocontroller,

            decoration: const InputDecoration(hintText: 'Linkdin Url'),
          ),
          const SizedBox(
            height: 20,
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel',style: TextStyle(color: Colors.red),)),
              ElevatedButton(onPressed: _submit, child: const Text('Update',style: TextStyle(color: Colors.green),))
            ],
          )
        ],
      ),
    );
  }
}
