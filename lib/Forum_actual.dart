

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hackathon/Comments_display.dart';
import 'package:hackathon/Forum_categories.dart';
import 'package:hackathon/comment_card.dart';
import 'package:hackathon/comments.dart';
import 'package:hackathon/profile.dart';
import 'package:hackathon/settings.dart';

import 'all_profile.dart';
import 'chatbot.dart';
import 'home_screen.dart';

class Forum_actual extends StatelessWidget {
  const Forum_actual(
      {super.key,
      required this.question,
      required this.profile_img,
      required this.image,
      required this.pid,
      required this.date,
      required this.cat,
      required this.uid});

  final question;
  final profile_img;
  final image;
  final pid;
  final date;
  final cat;
  final uid;

  @override
  Widget build(BuildContext context) {
    void _addoverlay() {
      showModalBottomSheet(

          context: context,
          builder: (ctx) => Comments_actual(postid: pid, category: cat));
    }
    final post = pid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) => Comments(
                          pid: post,
                      category: cat,
                        ));
              },
              icon: Icon(Icons.comment_outlined))
        ],
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
        onWillPop: () async { Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Forum_categories(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero)); return true; },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Profile_all(uid: uid),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));},
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(profile_img),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(question),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Image.network(image),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Forum_posts').doc(cat).collection('posts')
                  .doc(pid)
                  .collection('Replies').orderBy('likes',descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => Comment_card(snap: snapshot.data!.docs[index].data(),postid: pid,cat: cat,));
              })
              //ElevatedButton(onPressed: _addoverlay, child: Icon(Icons.chat_rounded))
              




            ],
          ),
        ),
      ),
    );
  }
}
