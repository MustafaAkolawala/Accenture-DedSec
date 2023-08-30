

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/comment_card.dart';
import 'package:hackathon/comments.dart';

class Forum_actual extends StatelessWidget {
  const Forum_actual(
      {super.key,
      required this.question,
      required this.profile_img,
      required this.image,
      required this.pid,
      required this.date});

  final question;
  final profile_img;
  final image;
  final pid;
  final date;

  @override
  Widget build(BuildContext context) {
    final post = pid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) => Comments(
                          pid: post,
                        ));
              },
              icon: Icon(Icons.comment_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(profile_img),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(question),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Image.network(image),
            SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Forum_posts')
                          .doc(post)
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
                            itemBuilder: (context, index) => Comment_card(snap: snapshot.data!.docs[index].data(),postid: pid,));
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
