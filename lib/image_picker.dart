import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
final storageref=FirebaseStorage.instance.ref().child('User-images').child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
final imageurl= storageref.getDownloadURL().toString();

class imagepicker extends StatefulWidget {
  const imagepicker({super.key,required this.onpickedimage});
final void Function(File pickedimage) onpickedimage;
  @override
  State<imagepicker> createState() {
    return _imagepickerstate();
  }
}

class _imagepickerstate extends State<imagepicker> {

  
  File? _pickedimagefile;
  void _pickimage()async{
    final pickediamge = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 400,maxHeight: 450);
    if(pickediamge==null){
      return;
    }
    setState(() {
      _pickedimagefile= File(pickediamge.path);
    });
    widget.onpickedimage(_pickedimagefile!);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        imageurl!=null?
          CircleAvatar(radius: 100,backgroundColor: Colors.blueGrey,foregroundImage: NetworkImage(imageurl),)
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
