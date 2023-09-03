import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'forum.dart';

class Cat_card extends StatefulWidget {
  const Cat_card({super.key, required this.snap});

  final snap;

  @override
  State<StatefulWidget> createState() {
    return _catcardstate();
  }
}

class _catcardstate extends State<Cat_card> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => Forum(cat: widget.snap['Category_name'],

                  )));},
      child: Card(
        child: Center(
          heightFactor: 3,
          child: Text(widget.snap['Category_name']),
        ),
      ),
    );
  }
}
