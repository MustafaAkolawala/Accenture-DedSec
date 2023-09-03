import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hackathon/cat_card.dart';

import 'package:hackathon/create_cat.dart';
import 'package:hackathon/profile.dart';
import 'package:hackathon/settings.dart';

import 'chatbot.dart';
import 'home_screen.dart';

class Forum_categories extends StatefulWidget{
  const Forum_categories({super.key,});

  @override
  State<StatefulWidget> createState() {
    return _forumctaegoriesstate();
  }

}

class _forumctaegoriesstate extends State<Forum_categories>{

  void overlay(){
    showModalBottomSheet(context: context, builder:(ctx)=> Createcat());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Forum'),flexibleSpace: Text('search bar'),actions: [IconButton(onPressed: overlay, icon: Icon(Icons.add))],),
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
              if (index == 2) {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Chatbot(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
              }
              if (index == 3) {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Profile(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
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
      body: WillPopScope(
        onWillPop: () async { Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Homescreen(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero)); return true; },
        child: StreamBuilder(
        stream:
        FirebaseFirestore.instance.collection('Forum_posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Cat_card(
                snap:snapshot.data!.docs[index].data(),
              ));
        },
    ),
      ),
    );
  }

}