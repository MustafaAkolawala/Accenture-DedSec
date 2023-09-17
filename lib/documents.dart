import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon/documents_card.dart';

class Document extends StatefulWidget{
  const Document({super.key,required this.type});
final type;
  @override
  State<StatefulWidget> createState() {
    return _documentstate();
  }
  
}
class _documentstate extends State<Document>{
  @override
  Widget build(BuildContext context) {
   return StreamBuilder(stream: FirebaseFirestore.instance.collection(widget.type).snapshots(), builder: (context,snapshot){ if (snapshot.connectionState ==
       ConnectionState.waiting) {
     return Center(child: CircularProgressIndicator());
   }
   return ListView.builder(itemCount: (snapshot.data! as dynamic).docs.length,itemBuilder: (context,index)=>Doc_card(snap: (snapshot.data! as dynamic).docs[index].data()) );
   });
  }
}
