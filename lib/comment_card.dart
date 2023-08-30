import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comment_card extends StatefulWidget {
  const Comment_card({super.key,required this.snap,required this.postid});
final snap;
final postid;
  @override
  State<StatefulWidget> createState() {
    return _commentcardstate();
  }
}

class _commentcardstate extends State<Comment_card> {
  FirebaseAuth _auth=  FirebaseAuth.instance;
  late List Likes;
  late bool isliked;

  Future <void> likepost(String commentid,String uid, List likes)async {
    try{
      if(likes.contains(uid)){
        await FirebaseFirestore.instance.collection('Forum_posts').doc(widget.postid).collection('Replies').doc(commentid).update({

          'likes':FieldValue.arrayRemove([uid]),

        });
        setState(() {
          isliked=false;
        });


      }
      else{
        await FirebaseFirestore.instance.collection('Forum_posts').doc(widget.postid).collection('Replies').doc(commentid).update({
          'likes':FieldValue.arrayUnion([uid]),
        });
        setState(() {
          isliked=true;
        });

      }
    }
    catch(e){
      print(e.toString());

    }

  }
  void initState() {
    Likes = widget.snap['likes'];
    isliked=false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    widget.snap['profile_pic']),radius: 18,
              ),
              SizedBox(width: 20,),
               Text(widget.snap['username']),




            ],
          ),
          Row(children: [SizedBox(width: 330,child:Text(widget.snap['text'])),IconButton(onPressed: (){likepost(widget.snap['commentid'], _auth.currentUser!.uid, widget.snap['likes']);}, icon: isliked
              ? Icon(Icons.thumb_up_alt)
              : Icon(Icons.thumb_up_alt_outlined),),],),
          Row(mainAxisAlignment:MainAxisAlignment.end,children: [Text(DateFormat.yMMMd().format(widget.snap['datepublished'].toDate()),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)],)

        ],
      ),
    );
  }
}
