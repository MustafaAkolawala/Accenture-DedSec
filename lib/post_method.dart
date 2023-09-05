



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class post_method{
  final   _auth = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> delete(String postid,String cat)async{
    String res = '';
    DocumentSnapshot snap =
    await _firestore.collection('Forum_posts').doc(cat).collection('posts').doc(postid).get();
    final uid = (snap.data() as Map<String,dynamic>)['Uid'];

try{
  if(_auth==uid ){
    await _firestore.collection('Forum_posts').doc(cat).collection('posts').doc(postid).delete();
    res='success';
  }
  else{
res = 'failure';
  }
}catch(err){
  print(err.toString());
}

  }
}