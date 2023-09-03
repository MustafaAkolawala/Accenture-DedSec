import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/forum_model.dart';
import 'package:hackathon/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Forum_upload extends StatefulWidget {
  const Forum_upload({super.key,required this.category});
final category;
  @override
  State<StatefulWidget> createState() {
    return _forum_uploadstate();
  }
}



  class _forum_uploadstate extends State<Forum_upload>{
    final qcontroller = TextEditingController();
  bool _isloadin=false;
    Uint8List? _file;
  _selectimage(BuildContext context)async{

  return showDialog(context: context, builder: (context){
    return SimpleDialog(
      title: const Text('Select image'),
      children: [SimpleDialogOption(
        padding: const EdgeInsets.all(20),
        child: const Text('Take a photo'),
        onPressed: ()async{
          Navigator.of(context).pop();
          Uint8List file = await Pickimage(ImageSource.camera);
          setState(() {
            _file=file;
          });

        },
      ),
        SimpleDialogOption(
          padding: const EdgeInsets.all(20),
          child: const Text('Choose form gallery'),
          onPressed: ()async{
            Navigator.of(context).pop();
            Uint8List file = await Pickimage(ImageSource.gallery);
            setState(() {
              _file=file;
            });

          },
        ),
        TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text('Cancel')),
      ],
    );
  });
}

void upload()async{
    setState(() {
      _isloadin=true;
    });
    String id= Uuid().v1();
    String iurl='';
final storageref=FirebaseStorage.instance.ref().child('posts').child(FirebaseAuth.instance.currentUser!.uid).child(id);
TaskSnapshot snap = await storageref.putData(_file!);

  iurl= await snap.ref.getDownloadURL();



String res = await Forum_model().Upload(Question: qcontroller.text,image: iurl,cat: widget.category);
if(res=='sucess'){
  setState(() {
    _isloadin=false;
  });
  showSnackbar('Uploaded!', context);
  Navigator.of(context).pop();
}
else{
  setState(() {
    _isloadin=false;
  });
  showSnackbar(res, context);
  Navigator.of(context).pop();
}

  }

  @override
  void dispose(){
    super.dispose();
    qcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(appBar:AppBar(title: Text('Upload Questions'),),body:Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        _isloadin?const LinearProgressIndicator():Container(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
          child: TextField(
            controller: qcontroller,
            maxLength: 100,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Question',

            ),

          ),
        ),
        SizedBox(height: 20,),
        Text('Add image if you want to'),
        SizedBox(height: 10,),
        _file!=null?
        Expanded(flex:1,child: Container(height:400,width:400,decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(_file!),fit: BoxFit.fill)),)):
        OutlinedButton(onPressed:()=> _selectimage(context), child: Image.network("https://t4.ftcdn.net/jpg/04/81/13/43/360_F_481134373_0W4kg2yKeBRHNEklk4F9UXtGHdub3tYk.jpg"),style: OutlinedButton.styleFrom(fixedSize: Size.square(400),shape:RoundedRectangleBorder(),)),
        SizedBox(height: 20,),
        ElevatedButton(onPressed: upload, child: Text('Post')),


      ],
    ) ,);
  }
}
