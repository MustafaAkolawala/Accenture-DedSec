import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/Comment_upload.dart';

class Comments extends StatefulWidget {
  const Comments({super.key, required this.pid});

  final pid;

  @override
  State<StatefulWidget> createState() {
    final id = pid;
    return _Commentsstate(postid: id);
  }
}

class _Commentsstate extends State<Comments> {
  _Commentsstate({required this.postid});

  final postid;

  String username = '';
  String profile_image = '';
  String uid = '';

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
            SizedBox(
              width: 260,
              child: TextField(
                controller: comcontroller,
                decoration: InputDecoration(hintText: 'Reply as ${username}'),
              ),
            ),
            InkWell(
              onTap: () {
                Comment_upload().postcomment(
                    postid: postid,
                    text: comcontroller.text,
                    uid: uid,
                    profilepic: profile_image,
                    username: username);
                setState(() {
                  comcontroller.clear();
                  Navigator.of(context).pop();
                });
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 8, 2, 8),
                  child: Text('Post'),
                ),
              ),
            )
          ],
        )
      ],
    ));
  }
}
