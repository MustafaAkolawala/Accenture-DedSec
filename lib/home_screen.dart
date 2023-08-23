import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/profile.dart';

class Homescreen extends StatefulWidget{
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() {
    return _homescreenstate();
  }
}
class _homescreenstate extends State<Homescreen>{




  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(title: const Text('Home'),actions: [IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Profile()));}, icon: const Icon(Icons.person))],),
    body: Center(child: Text('succesfully Logged in'),),);
  }

}