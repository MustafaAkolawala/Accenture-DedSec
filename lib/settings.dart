import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hackathon/Forum_categories.dart';
import 'package:hackathon/bottommodal.dart';
import 'package:hackathon/change_pass.dart';
import 'package:hackathon/delete_user.dart';
import 'package:hackathon/linkdin.dart';
import 'package:hackathon/profile.dart';
import 'package:hackathon/update_bio.dart';
import 'package:hackathon/update_username.dart';

import 'chatbot.dart';
import 'forum.dart';
import 'home_screen.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() {
    return _settingstate();
  }
}

class _settingstate extends State<Setting> {
  void _addoverlay() {
    showModalBottomSheet(

        context: context,
        builder: (ctx) => Bottommodal());
  }
  void _addoverlay1() {
    showModalBottomSheet(

        context: context,
        builder: (ctx) => Updateuser());
  }
  void _addoverlay2() {
    showModalBottomSheet(

        context: context,
        builder: (ctx) => Changepass());
  }
  void _addoverlay3() {
    showModalBottomSheet(


        context: context,
        builder: (ctx) => Delete());
  }
  void _addoverlay4() {
    showModalBottomSheet(


        context: context,
        builder: (ctx) => Updatebio());
  }
  void _addoverlay5() {
    showModalBottomSheet(


        context: context,
        builder: (ctx) => Linkdin());
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Homescreen(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero)); return true; },
      child: Scaffold(appBar: AppBar(title: Text('Settings'),),
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
                  text: 'Settings',
                  gap: 10,
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: _addoverlay1, child: const Text('Change Username')),
              TextButton(
                  onPressed: _addoverlay, child: const Text('Update personal details')),
              TextButton(onPressed: _addoverlay4, child: const Text('Update BIO')),
              TextButton(onPressed: _addoverlay5, child: const Text('Add Linkdin Profile')),
              //TextButton(onPressed: _addoverlay2, child: const Text('Change Password')),
              TextButton(onPressed: _addoverlay3, child: const Text('Delete Account')),

            ],
          ),
        ),
      ),
    );
  }
}
