import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Forumitem extends StatelessWidget {
  const Forumitem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          children: [
            Text('Question'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text('author')],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                    icon: Icon(Icons.thumb_up_alt_outlined),
                    onPressed: () {},
                    label: Text('Likes')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
