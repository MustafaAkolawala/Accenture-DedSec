import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/image_picker.dart';
import 'package:hackathon/main.dart';



class Profile extends StatefulWidget  {
  const Profile({super.key});

  @override
  State<Profile> createState() {
    return _profilestate();
  }
}

class _profilestate extends State<Profile> {

var user;
var userdata;
var d;
var username;
var email;
var company_name;
var position;
var aboutcompany;


void getdata()async{
   user= FirebaseAuth.instance.currentUser!;
   userdata=  FirebaseFirestore.instance.collection('users').doc(user.uid);
  d=userdata.get();
   username =await d.data()['username'];
   email=await d.data()['email_id'];
   company_name=await d.data(['company_name']);
   position=await d.data()['position'];
   aboutcompany=await d.data()['about_company'];
   print(email);
}




  File? _selectedimage;
  @override
  Widget build(BuildContext context) {
    getdata();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(

            children: [
              imagepicker(onpickedimage: (pickedimage) async {
                _selectedimage=pickedimage;
                final storageref=FirebaseStorage.instance.ref().child('User-images').child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
                await storageref.putFile(_selectedimage!);
                final imageurl=await storageref.getDownloadURL();
                userdata.update({
                  'image_url': imageurl
                });

              },),
              const SizedBox(
                height: 20,
              ),
              Text(username),
              const SizedBox(height: 20,),
              Text(email),
              const SizedBox(height: 20,),
              Text(company_name),
              const SizedBox(height: 20,),
              Text(position),
              const SizedBox(height: 20,),
              Text(aboutcompany),
              const SizedBox(height: 20,),
              TextButton(onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyApp()));
              }, child: const Text('Logout'))
            ],
          ),
        ),
      ),
    );
  }
}
