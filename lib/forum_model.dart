import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
const uuid=Uuid();
class Forum_model {
final FirebaseFirestore _firestore= FirebaseFirestore.instance;

Future<String>Upload({
  required String Question,
  required String image,
})

async{
final userid = FirebaseAuth.instance.currentUser!.uid;
DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(userid).get();
final username = (snap.data() as Map<String,dynamic>)['username'];
final Profile_image= (snap.data() as Map<String,dynamic>)['image_url'];
String postid= Uuid().v1();
  String res = 'some error occured';
  try{
    if(Question.isNotEmpty){
      await _firestore.collection('Forum_posts').doc(postid).set({
        'username': username,
        'Question': Question,
        'Uid': userid,
        'image_url': image,
        'Post_id': postid,
        'Date_published': DateTime.now(),
        'Profile_image': Profile_image,
        'Likes': [],

      });
      res ='success';
    }
  }
  catch(err){
res=err.toString();
  }
  return res;
}

}