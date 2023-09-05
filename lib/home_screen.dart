import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hackathon/Forum_categories.dart';
import 'package:hackathon/chatbot.dart';
import 'package:hackathon/forum.dart';
import 'package:hackathon/profile.dart';
import 'package:hackathon/settings.dart';
import 'package:flutter/services.dart';

class Homescreen extends StatefulWidget{
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() {
    return _homescreenstate();
  }
}
class _homescreenstate extends State<Homescreen>{

/*int _selectedindex=0;
void _navigate(int index){
setState(() {
  _selectedindex=index;
});

}
static final List<Widget> _navscreens = <Widget>[

Forum(),
  Chatbot(),
  Profile(),
  Settings()

];*/


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Exit'),
              content: const Text('Are you sure you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('Yes', style: TextStyle(color: Colors.red),),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(appBar:AppBar(title: const Text('Home'),/*actions: [IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Profile()));

        }, icon: const Icon(Icons.person))],*/),
      bottomNavigationBar:  Container(

        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
          child: GNav(
            style: GnavStyle.oldSchool,
            textSize: 10,

            onTabChange: (index){
              if(index==1){
                Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Forum_categories(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
              }
              if(index==2){
                Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Chatbot(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
              }
              if(index==3){
                Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Profile(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
              }
              if(index==4){
                Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Setting(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
              }

            },
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBorderRadius: 20,
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            //tabBackgroundColor: Colors.blueGrey.shade900,

            duration: Duration(milliseconds: 900),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
                gap: 10,
              ),
              GButton(icon: Icons.question_answer,text: 'Forum',gap: 10,),
              GButton(icon: Icons.chat_rounded,text: 'Chatbot',gap: 10,),
              GButton(icon: Icons.person,text: 'Profile',gap: 10,),
              GButton(icon: Icons.settings,text: 'settings',gap: 10,),
            ],
          ),
        ),
      ),
      body: Center(child: Text('succesfully Logged in'),),),
    );
  }

}