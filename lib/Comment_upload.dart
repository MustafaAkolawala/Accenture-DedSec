import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Comment_upload{
  final  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> postcomment({
  required String postid,
    required String text,
    required String uid,
    required String profilepic,
    required String username

})async {
try{
  if(text.isNotEmpty){
    String commentid= Uuid().v1();
    _firestore.collection('Forum_posts').doc(postid).collection('Replies').doc(commentid).set({
      'profile_pic': profilepic,
      'username': username,
      'uid': uid,
      'text': text,
      'commentid': commentid,
      'datepublished': DateTime.now()
    });

  }
  else{
    print('Text is empty');
  }
}
catch(e){
  print(e.toString());
}
}
}