import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/Forum_actual.dart';
import 'package:hackathon/post_method.dart';
import 'package:intl/intl.dart';

class Forumitem extends StatelessWidget {
  Forumitem({super.key, required this.snap});

  final snap;

  bool isliked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => Forum_actual(
                    question: snap['Question'],
                    profile_img: snap['Profile_image'],
                    image: snap['image_url'],
                    pid: snap['Post_id'],
                    date: DateFormat.yMMMd().format(
                      snap['Date_published'].toDate(),
                    ))));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(snap['Question']),
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
                                                .delete(snap['Post_id']);
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
                children: [Text(snap['username'])],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                      icon: isliked
                          ? Icon(Icons.thumb_up_alt)
                          : Icon(Icons.thumb_up_alt_outlined),
                      onPressed: () {},
                      label: Text('${snap['Likes'].length} Likes')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
