import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/pdf_view.dart';

import 'forum.dart';

class Doc_card extends StatefulWidget {
  const Doc_card({super.key, required this.snap});

  final snap;

  @override
  State<StatefulWidget> createState() {
    return _catcardstate();
  }
}

class _catcardstate extends State<Doc_card> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PDF(pdf_url: widget.snap['pdf_url']),

          ));


      },
      child: Card(
        child: Center(
          heightFactor: 3,
          child: Text(widget.snap['name']),
        ),
      ),
    );
  }
}
