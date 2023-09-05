import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:hackathon/Comment_upload.dart';

class Comments extends StatefulWidget {
  const Comments({super.key, required this.pid, required this.category});

  final pid;
  final category;

  @override
  State<StatefulWidget> createState() {
    final id = pid;
    return _Commentsstate(postid: id);
  }
}

class _Commentsstate extends State<Comments> {
  _Commentsstate({required this.postid});

  List<Map<String,dynamic>> data =[
    {
      'display' : 'surya gandu',
      'image': 'https://visualstudio.microsoft.com/wp-content/uploads/2023/07/C-2.webp'
    },
    {
      'display' : 'shadaab dumbass',
      'image': 'https://visualstudio.microsoft.com/wp-content/uploads/2023/07/javascript.webp'
    }
  ];

  final postid;

  String username = '';
  String profile_image = '';
  String uid = '';

  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();

  void getdata() async {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'];
      profile_image = (snap.data() as Map<String, dynamic>)['image_url'];
      uid = userid;
    });
  }

  final comcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    comcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getdata();
    return Scaffold(
        body: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CircleAvatar(
                foregroundImage: NetworkImage(profile_image),
              ),
            ),
           /* StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot ){
               /* List<Map<String, dynamic>>? documentData = [snapshot.data] ;
                print(documentData);*/
    return
SizedBox(width: 320,
  child:   ListView.builder(shrinkWrap: true,itemBuilder: (context,index)=> FlutterMentions(key: key, decoration: InputDecoration(hintText: 'Reply as $username'),mentions: [

    Mention(

        trigger: "@",

        data: [snapshot.data!.docs[index].data()],

        style: TextStyle(color: Colors.blue))

  ])),
);




    }),*/


           Expanded(
             child: Portal(
               child: FlutterMentions(key: key, decoration: InputDecoration(hintText: 'Reply as $username'),mentions: [

               Mention(

               trigger: "@",

               data: data,

               style: TextStyle(color: Colors.blue),
               suggestionBuilder: (data){
                 return Container(color: Colors.blue,child: Row(children: [CircleAvatar(backgroundImage: NetworkImage(data['image']),),SizedBox(width: 10,),Text(data['display'])],),);
               }),


               ]),
             ),
           ),
           ]
        ),


           /* SizedBox(
              width: 320,
              child: TextField(
                controller: comcontroller,
                decoration: InputDecoration(hintText: 'Reply as ${username}'),
              ),
            ),
          ],
        ),*/
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            Comment_upload().postcomment(
                postid: postid,
                text: comcontroller.text,
                uid: uid,
                profilepic: profile_image,
                username: username,
                category: widget.category);
            setState(() {
              comcontroller.clear();
              Navigator.of(context).pop();
            });
          },
          child: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(25, 8, 2, 8),
              child: Text(
                'Post',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
