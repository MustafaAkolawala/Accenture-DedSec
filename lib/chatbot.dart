import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hackathon/Forum_categories.dart';
import 'package:hackathon/chatbot_function.dart';
import 'package:hackathon/forum.dart';
import 'package:hackathon/profile.dart';
import 'package:hackathon/settings.dart';

import 'home_screen.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final GlobalKey<AnimatedListState> _listkey = GlobalKey();
  List<String> _data = [];
  var string;

  String output = 'initial';
  var querycontroller = TextEditingController();

  void get() async {
    var url = 'http://e9ac-49-36-9-159.ngrok-free.app/bot';
    var data = await fetchdata(url, string);
    output = data ;
    inseritem(output);
    print(output);
    setState(() {
      querycontroller.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()
    async {
      Navigator.push(context, PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Homescreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero));
      return true;
    },
    child: Scaffold(appBar: AppBar(leading: IconButton(onPressed: (){Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Homescreen(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));}, icon: Icon(Icons.arrow_back)),title: Text('Chatbot'),),
    bottomNavigationBar: Container(
    color: Colors.black,
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
    child: GNav(
    style: GnavStyle.oldSchool,
    textSize: 10,

    onTabChange: (index){
    if(index==0){
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Homescreen(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
    }
    if(index==1){
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Forum_categories(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero));
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
    tabBorderRadius: 10,
    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
    //tabBackgroundColor: Colors.blueGrey.shade900,

    duration: Duration(milliseconds: 900),
    tabs: const [
    GButton(icon: Icons.home,text: 'Home',gap: 10,),

    GButton(icon: Icons.question_answer,text: 'Forum',gap: 10,),
    GButton(
    icon: Icons.chat_rounded,
    text: 'Chatbot',
    gap: 10,
    ),
    GButton(icon: Icons.person,text: 'Profile',gap: 10,),

    GButton(icon: Icons.settings,text: 'settings',gap: 10,),
    ],
    ),
    ),
    ),
    body: Stack(
    children: <Widget>[
    AnimatedList(key: _listkey,initialItemCount: _data.length,itemBuilder: (BuildContext context,int index,Animation<double> animation,){
    return builditem(_data[index], animation, index);
    }),
    Align(alignment: Alignment.bottomCenter,child: Padding(padding: const EdgeInsets.only(right: 20,left: 20),child: TextField(controller: querycontroller,textInputAction: TextInputAction.send,decoration: InputDecoration(icon: Icon(Icons.message),hintText: "Enter your query"),onSubmitted: (value){
    string=value;
    if(value.isNotEmpty){
    inseritem(value);
    }
    get();
    },),),
    )
    ]
    ,
    )
    ));
  }

  void inseritem(String msg) {
    _data.add(msg);
    _listkey.currentState?.insertItem(_data.length - 1);
  }
}

Widget builditem(String item, Animation<double> animation, int index) {
  bool mine = item.endsWith('<bot>');
  return SizeTransition(sizeFactor: animation,
    child: Padding(padding: EdgeInsets.only(top: 10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              alignment: mine ? Alignment.topLeft : Alignment.topRight, child: Bubble(color: mine?Colors.blue:Colors.green,
          padding: BubbleEdges.all(10),child: Text(
            item.replaceAll('<bot>', ''),
            style: TextStyle(
              color: mine?Colors.white:Colors.black,
            ),
          ),),
          ),
        ),)
  ,
  );


}
