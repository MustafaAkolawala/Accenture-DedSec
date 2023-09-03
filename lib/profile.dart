import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackathon/Forum_categories.dart';
import 'package:hackathon/home_screen.dart';
import 'package:hackathon/image_picker.dart';
import 'package:hackathon/login_page.dart';
import 'package:hackathon/main.dart';
import 'package:hackathon/settings.dart';

import 'chatbot.dart';
import 'forum.dart';

var user = FirebaseAuth.instance.currentUser!;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() {
    return _profilestate();
  }
}

class _profilestate extends State<Profile> {
  void signout() async {
     await GoogleSignIn().signOut();
     //await GoogleSignIn().disconnect();
     await FirebaseAuth.instance.signOut();

     await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
         builder: (c) => const login()),(route)=>false);
  }

  Uint8List? _selectedimage;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Homescreen(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero)); return true; },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              style: GnavStyle.oldSchool,
              textSize: 10,
              onTabChange: (index) {
                if (index == 0) {
                  Navigator.push(
                      context,
                      PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Homescreen(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
                }
                if (index == 1) {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Forum_categories(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
                }
                if (index == 2) {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Chatbot(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
                }
                if (index == 4) {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Setting(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
                }
              },
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBorderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              //tabBackgroundColor: Colors.blueGrey.shade900,
              duration: Duration(milliseconds: 900),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  gap: 10,
                ),
                GButton(
                  icon: Icons.question_answer,
                  text: 'Forum',
                  gap: 10,
                ),
                GButton(
                  icon: Icons.chat_rounded,
                  text: 'Chatbot',
                  gap: 10,
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                  gap: 10,
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'settings',
                  gap: 10,
                ),
              ],
            ),
          ),
        ),
        body:
            Container(

              padding: EdgeInsets.fromLTRB(20, 30, 30, 30),
              child: Column(


                children: [
                  imagepicker(
                    onpickedimage: (pickedimage) async {
                      _selectedimage = pickedimage;
                      final storageref = FirebaseStorage.instance
                          .ref()
                          .child('User-images')
                          .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
                      TaskSnapshot snap = await storageref.putData(_selectedimage!);
                      String imageurl = await snap.ref.getDownloadURL();

                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({'image_url': imageurl});
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                 SingleChildScrollView(
                           child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                Map<String, dynamic> doc =
                                    snapshot.data!.data() as Map<String, dynamic>;
                                return Column(
                                  children: [Row(children: [const Text('USERNAME:',style: TextStyle(fontWeight: FontWeight.bold)),SizedBox(width: 5,),Text(doc['username'],maxLines: 1,),],),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(crossAxisAlignment: CrossAxisAlignment.start,children: [const Text('Bio:',style: TextStyle(fontWeight: FontWeight.bold)),SizedBox(width: 5,),
                                      
                                        Expanded(child: Text(doc['Bio'],maxLines: 4,overflow: TextOverflow.clip,)),
                                      
                                    ],),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(children: [const Text('Email-Id:',style: TextStyle(fontWeight: FontWeight.bold)),SizedBox(width: 5,),Text(doc['email_id'],maxLines: 1,),],),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(children: [const Text('Company:',style: TextStyle(fontWeight: FontWeight.bold)),SizedBox(width: 5,),doc['Company']==null?Text('Add Company name'):Text(doc['Company'],maxLines: 1,),],),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                        Row(children: [const Text('Position:',style: TextStyle(fontWeight: FontWeight.bold)),SizedBox(width: 5,),doc['Position']==null?Text('Add Position'):Text(doc['Position'],maxLines: 1,),],),



                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(crossAxisAlignment: CrossAxisAlignment.start,children: [const Text('About-Company:',style: TextStyle(fontWeight: FontWeight.bold),),SizedBox(width: 5,),doc['About_company']==null?Text('Add Company Information'):Expanded(child: Text(doc['About_company'],maxLines: 4,overflow: TextOverflow.ellipsis,)),],),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                );
                              }
                            },
                        ),
                         ),



                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          signout();
                         // Navigator.of(context).pop();
                        },
                        child: const Text('Logout')),
                  )
                ],
              ),
            ),
          

      ),
    );
  }
}
