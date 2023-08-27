import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comment_card extends StatefulWidget {
  const Comment_card({super.key,required this.snap});
final snap;
  @override
  State<StatefulWidget> createState() {
    return _commentcardstate();
  }
}

class _commentcardstate extends State<Comment_card> {

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
          Row(children: [SizedBox(width: 330,child:Text(widget.snap['text'])),IconButton(onPressed: (){}, icon: Icon(Icons.thumb_up_alt_outlined)),],),
          Row(mainAxisAlignment:MainAxisAlignment.end,children: [Text(DateFormat.yMMMd().format(widget.snap['datepublished'].toDate()),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)],)

        ],
      ),
    );
  }
}
