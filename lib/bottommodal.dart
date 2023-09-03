import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bottommodal extends StatefulWidget {
  Bottommodal({super.key});



  @override
  State<Bottommodal> createState() {
    return _bottommodalstate();
  }
}

class _bottommodalstate extends State<Bottommodal> {
  final _compcontroller = TextEditingController();
  final _poscontroller = TextEditingController();
  final _aboutcontroller= TextEditingController();
  final _biocontroller=TextEditingController();
void _submit(){
if(_compcontroller.text.trim().isEmpty&&_poscontroller.text.trim().isEmpty&&_aboutcontroller.text.trim().isEmpty){
showDialog(context: context, builder: (ctx)=> AlertDialog(title: Text('No Value entered'),content: Text('Please enter some data'),actions: [TextButton(onPressed: (){Navigator.pop(ctx);}, child: Text('close'))],));
return;
}
if(_compcontroller.text.trim().isEmpty && _poscontroller.text.trim().isEmpty){
  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'About_company': _aboutcontroller.text});
  Navigator.pop(context);
}
if(_aboutcontroller.text.trim().isEmpty && _poscontroller.text.trim().isEmpty){
  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'Company': _compcontroller.text});

}
if(_compcontroller.text.trim().isEmpty && _aboutcontroller.text.trim().isEmpty){
  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'Position': _poscontroller.text});

}

if( _poscontroller.text.trim().isEmpty) {
  FirebaseFirestore.instance.collection('users').doc(
      FirebaseAuth.instance.currentUser!.uid).update(
      {'Company': _compcontroller.text,'About_company':_aboutcontroller});
}
if( _aboutcontroller.text.trim().isEmpty) {
  FirebaseFirestore.instance.collection('users').doc(
      FirebaseAuth.instance.currentUser!.uid).update(
      {'Company': _compcontroller.text,'Position':_poscontroller});
}
if( _compcontroller.text.trim().isEmpty) {
  FirebaseFirestore.instance.collection('users').doc(
      FirebaseAuth.instance.currentUser!.uid).update(
      {'Position': _poscontroller.text,'About_company':_aboutcontroller});
}
else{FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'Company': _compcontroller.text,'Position':_poscontroller.text,'About_company': _aboutcontroller.text});
}
Navigator.pop(context);
}

@override
  void dispose(){
_compcontroller.dispose();
_poscontroller.dispose();
_aboutcontroller.dispose();
super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _compcontroller,
            maxLength: 50,
            decoration: const InputDecoration(hintText: 'Company name'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _poscontroller,
            maxLength: 20,
            decoration: const InputDecoration(hintText: 'Position'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _aboutcontroller,
            maxLength: 200,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'About Company'),
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
                  child: const Text('Cancel',style: TextStyle(color: Colors.red)),),
              ElevatedButton(onPressed: _submit, child: const Text('Update',style: TextStyle(color: Colors.green)))
            ],
          )
        ],
      ),
    );
  }
}
