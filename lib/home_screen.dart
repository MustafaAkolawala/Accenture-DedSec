import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hackathon/Forum_categories.dart';
import 'package:hackathon/chatbot.dart';
import 'package:hackathon/forum.dart';
import 'package:hackathon/profile.dart';
import 'package:hackathon/settings.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';



class Homescreen extends StatefulWidget{
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() {
    return _homescreenstate();
  }
}
class _homescreenstate extends State<Homescreen>{
  fetchdata(String url, File value) async {
    final request = http.MultipartRequest("POST",Uri.parse(url));
  final headers = {"Content_Type": "multipart/form-data"};
  request.files.add(
    http.MultipartFile('file',value.readAsBytes().asStream() , value.lengthSync(),filename: value.path.split('/').last)
      );
  request.headers.addAll(headers);
  final response = await request.send();
  http.Response res = await http.Response.fromStream(response);
  final response1 = jsonDecode(res.body);
  final message = response1['message'];
  print(message);

  }

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
  String? _imageData;

  Future<void> _pickFileAndUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

    if (result != null) {
      var request = http.MultipartRequest('POST', Uri.parse('http://9cc2-49-36-9-159.ngrok-free.app/forecast-plot'));
      request.files.add(await http.MultipartFile.fromPath('file', result.files.single.path!));
      var response = await request.send();
      var responseData = await response.stream.toBytes();

      setState(() {
        _imageData = base64Encode(responseData);
      });
    } else {
      // User canceled the picker
    }
  }

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
       body: Center(
    child: _imageData != null
    ? Column(
      children: [
        Image.memory(base64Decode(_imageData!)),
        Text('This is the forcasted data'),
        Text('Disclaimer: the prediction is not to be considered as 100% accurate')
      ],
    )
        : Text('No plot available.'),
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: _pickFileAndUpload,
    tooltip: 'Pick and Upload',
    child: Icon(Icons.upload_file),
    ),
       //Center(child: Column(
      //   children: [
      //     Text('succesfully Logged in'),
          /*ElevatedButton(onPressed: ()async{
            final path= await FlutterDocumentPicker.openDocument();
            File file= File(path!);
            String url= 'http://7dca-49-36-9-159.ngrok-free.app/upload';
            fetchdata(url, file);
          }, child: Text('upload pdf')),*/
      //   ],
      // ),),),
    ));
  }

}