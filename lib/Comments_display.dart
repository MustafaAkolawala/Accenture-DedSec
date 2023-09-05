import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'comment_card.dart';

class Comments_actual extends StatefulWidget{
  const Comments_actual({super.key,required this.postid,required this.category});
final postid;
final category;
  @override
  State<StatefulWidget> createState() {
    return _commentsdispState();
  }

}

class _commentsdispState extends State<Comments_actual>{
  @override
  Widget build(BuildContext context) {
return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('Forum_posts').doc(widget.category).collection('posts')
        .doc(widget.postid)
        .collection('Replies').orderBy('likes',descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState ==
          ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) => Comment_card(snap: snapshot.data!.docs[index].data(),postid: widget.postid,cat: widget.category,));
    });

  }
}
