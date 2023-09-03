import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Createcat extends StatefulWidget {
  const Createcat({super.key});

  @override
  State<Createcat> createState() {
    return _createcatstate();
  }
}

class _createcatstate extends State<Createcat> {
  var controller = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  void _submit(){
    if(controller.text.trim().isEmpty){
      showDialog(context: context, builder: (ctx)=> AlertDialog(title: Text('No Value entered'),content: Text('Please enter BIO'),actions: [TextButton(onPressed: (){Navigator.pop(ctx);}, child: Text('close'))],));
      return;
    }
    FirebaseFirestore.instance.collection('Forum_posts').doc(controller.text.trim()).set({'Category_name': controller.text,
    'Uid': uid });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Category Name'),
          ),
          const SizedBox(
            height: 20,
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel',style: TextStyle(color: Colors.red),)),
              ElevatedButton(onPressed: _submit, child: const Text('Create',style: TextStyle(color: Colors.green),))
            ],
          )
        ],
      ),
    );
  }
}
