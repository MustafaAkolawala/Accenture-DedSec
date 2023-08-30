import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hackathon/Forum_item.dart';
import 'package:hackathon/forum_upload_layout.dart';
import 'package:hackathon/profile.dart';
import 'package:hackathon/settings.dart';

import 'chatbot.dart';
import 'home_screen.dart';

class Forum extends StatefulWidget {
  const Forum({super.key});

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  void setuppushnotifications()async{
    final fcm= FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('forum');
    final token = await fcm.getToken();
    print(token);
  }
  @override
  void initState() {

    super.initState();
    setuppushnotifications();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Forum'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Forum_upload()));
                },
                icon: const Icon(Icons.add))
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              onTabChange: (index) {
                if (index == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Homescreen()));
                }
                if (index == 1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Chatbot()));
                }
                if (index == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                }
                if (index == 3) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Setting()));
                }
              },
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBorderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              tabBackgroundColor: Colors.blueGrey.shade900,
              duration: Duration(milliseconds: 900),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
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
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('Forum_posts').orderBy('Likes',descending: true).snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Forumitem(
                  snap:snapshot.data!.docs[index].data(),
                ));
          },
        ));
  }
}
