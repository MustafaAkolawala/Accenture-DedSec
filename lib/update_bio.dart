import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Updatebio extends StatefulWidget {
  Updatebio({super.key});



  @override
  State<Updatebio> createState() {
    return _bottommodalstate();
  }
}

class _bottommodalstate extends State<Updatebio> {
  final _biocontroller = TextEditingController();

  void _submit(){
    if(_biocontroller.text.trim().isEmpty){
      showDialog(context: context, builder: (ctx)=> AlertDialog(title: Text('No Value entered'),content: Text('Please enter BIO'),actions: [TextButton(onPressed: (){Navigator.pop(ctx);}, child: Text('close'))],));
      return;
    }
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'Bio': _biocontroller.text});
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
            maxLength: 200,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'BIO'),
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
