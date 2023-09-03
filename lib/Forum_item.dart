import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon/Forum_actual.dart';
import 'package:hackathon/Forum_categories.dart';
import 'package:hackathon/post_method.dart';
import 'package:intl/intl.dart';

class Forumitem extends StatefulWidget {
  Forumitem({super.key, required this.snap,required this.category});

  final snap;
  final category;

  @override
  State<Forumitem> createState() => _ForumitemState();
}

class _ForumitemState extends State<Forumitem> {
  FirebaseAuth _auth=  FirebaseAuth.instance;
  late List Likes;
  
  
  
  

  Future <void> likepost(String postid,String uid, List likes)async {
    try{
      if(likes.contains(uid)){
        await FirebaseFirestore.instance.collection('Forum_posts').doc(widget.category).collection('posts').doc(postid).update({

          'Likes':FieldValue.arrayRemove([uid]),
        });

      }
      else{
        await FirebaseFirestore.instance.collection('Forum_posts').doc(widget.category).collection('posts').doc(postid).update({
          'Likes':FieldValue.arrayUnion([uid]),
        });
      }
    }
    catch(e){
      print(e.toString());

    }

  }

@override
  void initState() {
   Likes = widget.snap['Likes'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Forum_categories(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero)); return true; },
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => Forum_actual(
                      question: widget.snap['Question'],
                      profile_img: widget.snap['Profile_image'],
                      image: widget.snap['image_url'],
                      pid: widget.snap['Post_id'],
                      date: DateFormat.yMMMd().format(
                        widget.snap['Date_published'].toDate(),

                      ),
                  cat: widget.category,)));
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(widget.snap['Question']),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shrinkWrap: true,
                                    children: ['Delete']
                                        .map(
                                          (e) => InkWell(
                                            onTap: () async {
                                              await post_method()
                                                  .delete(widget.snap['Post_id'],widget.category);
                                              Navigator.of(context).pop();


                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ));
                      },
                      icon: Icon(Icons.more_vert)),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(widget.snap['username'])],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    TextButton.icon(
                        icon: Likes.contains([_auth.currentUser!.uid])?
                             Icon(Icons.thumb_up_alt):
                             Icon(Icons.thumb_up_alt_outlined),
                        onPressed: () {

                          likepost(widget.snap['Post_id'], _auth.currentUser!.uid, widget.snap['Likes']);
                        },
                        label: Text('${widget.snap['Likes'].length} Likes')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
