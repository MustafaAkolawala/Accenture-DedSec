import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Like extends StatefulWidget{
  Like({super.key,required this.iliked,required this.sn});
bool iliked;
final sn;
  @override
  State<StatefulWidget> createState() {
   return _likestate(isliked: iliked,sna: sn);
  }

}

class _likestate extends State<Like>{
  _likestate({
    required this.isliked,
    required this.sna
  });
  bool isliked;
  final sna;

  @override
  Widget build(BuildContext context) {

    return TextButton.icon(
        icon: isliked?Icon(Icons.thumb_up_alt):Icon(Icons.thumb_up_alt_outlined),
        onPressed: () {
setState(() {
  isliked=!isliked;
});
        },
        label: Text('${sna} Likes'));
  }

}