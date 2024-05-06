

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hackathon/Forum_categories.dart';
import 'package:hackathon/chatbot_function.dart';
import 'package:hackathon/documents.dart';
import 'package:hackathon/forum.dart';
import 'package:hackathon/pdf_view.dart';
import 'package:hackathon/profile.dart';
import 'package:hackathon/settings.dart';

import 'home_screen.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

String? tag;
String? type;

class _ChatbotState extends State<Chatbot> {
  final GlobalKey<AnimatedListState> _listkey = GlobalKey();
  List<String> _data = [];
  var string;
  List<String> _tag = [];

  String output = 'initial';
  var querycontroller = TextEditingController();

  void get() async {
    var url = 'http://c010-49-36-9-159.ngrok-free.app/bot';
    var data = await fetchdata(url, string);
    output = data['response'];
    _tag.add(data['tag']);
    print(_tag);
    inseritem(output);
    print(output);
    setState(() {
      querycontroller.clear();
    });
    if (_tag.contains('documents_individual_business') ||
        _tag.contains('documents_proprietorship_firm') ||
        _tag.contains('documents_partnership_firm') ||
        _tag.contains('documents_llp') ||
        _tag.contains('documents_joint_stock_company')) {
      type = 'documents';
      _tag.clear();
    }

    if (_tag.contains('government_schemes_joint_stock_company') ||
        _tag.contains('government_schemes_llp') ||
        _tag.contains('government_schemes_partnership_firm') ||
        _tag.contains('government_schemes_proprietorship_firm') ||
        _tag.contains('government_schemes_individual_business')) {
      type = 'gov_schemes';
      _tag.clear();
    }

    if (_tag.contains('tax_incentives_individual_business') ||
        _tag.contains('tax_incentives_proprietorship_firm') ||
        _tag.contains('tax_incentives_partnership_firm') ||
        _tag.contains('tax_incentives_llp') ||
        _tag.contains('tax_incentives_joint_stock_company')) {
      type = 'tax_incentives';
      _tag.clear();
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      Homescreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero));
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                Homescreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero));
                  },
                  icon: Icon(Icons.arrow_back)),
              title: Text('Chatbot'),
            ),
            bottomNavigationBar: Container(
              color: Colors.black,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: GNav(
                  style: GnavStyle.oldSchool,
                  textSize: 10,

                  onTabChange: (index) {
                    if (index == 0) {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  Homescreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero));
                    }
                    if (index == 1) {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  Forum_categories(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero));
                    }
                    if (index == 3) {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  Profile(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero));
                    }
                    if (index == 4) {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  Setting(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero));
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
            body: Stack(
              children: <Widget>[
                AnimatedList(
                    key: _listkey,
                    initialItemCount: _data.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                      Animation<double> animation,
                    ) {
                      return builditem(_data[index], animation, index,context);
                    }),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: TextField(
                      controller: querycontroller,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                          icon: Icon(Icons.message),
                          hintText: "Enter your query"),
                      onSubmitted: (value) {
                        string = value;
                        if (value.isNotEmpty) {
                          inseritem(value);
                        }
                        get();
                      },
                    ),
                  ),
                )
              ],
            )));
  }

  void inseritem(String msg) {
    _data.add(msg);
    _listkey.currentState?.insertItem(_data.length - 1);
  }

}

Widget builditem(String item, Animation<double> animation, int index,BuildContext context) {
  bool mine = item.endsWith('<bot>');
  return SizeTransition(
    sizeFactor: animation,
    child: Padding(
      padding: EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          alignment: mine ? Alignment.topLeft : Alignment.topRight,
          child: Bubble(
            color: mine ? Colors.blue : Colors.green,
            padding: BubbleEdges.all(10),
            child: Column(
              children: [
                Text(
                  item.replaceAll('<bot>', ''),
                  style: TextStyle(
                    color: mine ? Colors.white : Colors.black,
                  ),
                ),
                if (mine && type != null && item == "For an Individual Business (Sole Proprietorship), you may need the following documents:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Here's a list of documents you may need for your Individual Business:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "There are various government schemes and programs that can benefit Individual Businesses (Sole Proprietorships). Some of these include:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Government schemes can provide valuable support to Individual Businesses. Here are a few examples:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Here are some tax incentives that may apply to your Individual Business (Sole Proprietorship):<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "For a Proprietorship Firm, you may need the following documents:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Here's a list of documents you may need for your Proprietorship Firm:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "There are various government schemes and programs that can benefit Proprietorship Firms. Some of these include:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Government schemes can provide valuable support to Proprietorship Firms. Here are a few examples:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Tax incentives for Proprietorship Firms can vary depending on your location and specific circumstances. Some common tax incentives for family-owned businesses include:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Here are some tax incentives that may apply to your Proprietorship Firm:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "For a Partnership Firm, you may need the following documents:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Here's a list of documents you may need for your Partnership Firm:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "There are various government schemes and programs that can benefit Partnership Firms. Some of these include:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Government schemes can provide valuable support to Partnership Firms. Here are a few examples:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Tax incentives for Partnership Firms can vary depending on your location and specific circumstances. Some common tax incentives for partnership businesses include:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Here are some tax incentives that may apply to your Partnership Firm:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "For a Limited Liability Partnership (LLP), you may need the following documents:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Here's a list of documents you may need for your LLP:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "There are various government schemes and programs that can benefit Limited Liability Partnerships (LLPs). Some of these include:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "Government schemes can provide valuable support to LLPs. Here are a few examples:<bot>" ||
                    mine &&
                        type != null &&
                        item ==
                            "For a Joint Stock Company, you may need the following documents:<bot>"||
                    mine &&
                        type != null &&
                        item ==
                            "Here's a list of documents you may need for your Joint Stock Company:<bot>"||
                    mine &&
                        type != null &&
                        item ==
                            "There are various government schemes and programs that can benefit Joint Stock Companies. Some of these include:<bot>"||
                    mine &&
                        type != null &&
                        item ==
                            "Government schemes can provide valuable support to Joint Stock Companies. Here are a few examples:<bot>")

                     ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Document(type: type)));

                        },
                        child: Text('open')),


              ],
            ),
          ),
        ),
      ),
    ),
  );
}
