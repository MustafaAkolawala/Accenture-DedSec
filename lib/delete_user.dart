import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/login_page.dart';

class Delete extends StatefulWidget{
  const Delete({super.key});

  @override
  State<StatefulWidget> createState() {
    return _deletestate();
  }

}

class _deletestate extends State<Delete>{
  void delete(){
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).delete();
    FirebaseAuth.instance.currentUser!.delete();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const login()));
    FirebaseStorage.instance.ref().child('User-images').child('${FirebaseAuth.instance.currentUser!.uid}.jpg').delete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [Text('Are you sure'),Row(children: [TextButton(onPressed: (){Navigator.pop(context);}, child:Text('NO',style:TextStyle(color: Colors.green),),),TextButton(onPressed: delete, child:Text('YES',style:TextStyle(color: Colors.red),),)])],),);
  }

}