

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class Auth_method{
 final  FirebaseAuth _auth = FirebaseAuth.instance;
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<String>signup({
required String username,
required String emailid,
   required String password,



})
 async{
   String res = "some error occured";
   try{
     if(emailid.isNotEmpty||password.isNotEmpty||username.isNotEmpty){
       UserCredential cred = await _auth.createUserWithEmailAndPassword(email: emailid, password: password);

       await _firestore.collection('users').doc(cred.user!.uid).set({
         'username': username,
         'email_id': emailid,
         'Uid': cred.user!.uid,
         'image_url': '',
         'Company': 'Add Company name',
         'Position': 'Add position',
         'About_company': 'Add Company information',
         'Bio': 'Add Bio',

       });
       res = 'success';
     }
   }
   catch(err){
     res=err.toString();

   }
   return res;

}
}