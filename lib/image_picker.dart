import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/pick_image.dart';
import 'package:image_picker/image_picker.dart';


class imagepicker extends StatefulWidget {
  const imagepicker({super.key,required this.onpickedimage});
final void Function(File pickedimage) onpickedimage;
  @override
  State<imagepicker> createState() {
    return _imagepickerstate();
  }
}
String Url='';
void getimage()async {
  DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

     Url = await (snap.data() as Map<String,dynamic>)['image_url'];
    print(Url);


  if(Url==null){
    return;
  }




}
class _imagepickerstate extends State<imagepicker> {



  File? _pickedimagefile;
  void _pickimage()async{
    final image = await  Pickimage(ImageSource.gallery);
    setState(()  {
      _pickedimagefile=  image;
    });
    widget.onpickedimage(_pickedimagefile!);

  }
  @override
  void setState(VoidCallback fn) {
    getimage();
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        Url!=null?
          CircleAvatar(radius: 100,backgroundImage: NetworkImage(Url),)
        :
         CircleAvatar(radius: 100,backgroundColor: Colors.blueGrey,foregroundImage:_pickedimagefile!=null?FileImage(_pickedimagefile!):null,),
        TextButton.icon(
            onPressed: _pickimage,
            icon: const Icon(Icons.image),
            label: const Text('Add Image'))
      ],
    );
  }
}
