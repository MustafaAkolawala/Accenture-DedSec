import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/category_card.dart';

class Forum_categories extends StatefulWidget{
  const Forum_categories({super.key});

  @override
  State<StatefulWidget> createState() {
    return _forumctaegoriesstate();
  }

}

class _forumctaegoriesstate extends State<Forum_categories>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Forum'),actions: [IconButton(onPressed: (){}, icon: Icon(Icons.add))],),body: cat_card() ,);
  }

}