import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/Forum_categories.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile_all extends StatefulWidget {
  const Profile_all({super.key,required this.uid});
final uid;
  @override
  State<StatefulWidget> createState() {
    return _Profileallstate();
  }

}

class _Profileallstate extends State<Profile_all> {
  _linkedin(String url) async {
    Uri url1= Uri.parse(url);


      await launchUrl(url1,mode: LaunchMode.externalApplication);


  }
  _emailto(String url) async {
    Uri url1= Uri(scheme: 'mailto',path: url);


    await launchUrl(url1);


  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async { Navigator.push(context, PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>Forum_categories(),transitionDuration: Duration.zero,reverseTransitionDuration: Duration.zero)); return true; },
        child: Scaffold(body: StreamBuilder(stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasError) {
    return const Text('Something went wrong');
    }
    if (snapshot.connectionState ==
    ConnectionState.waiting) {
    return const Center(
    child: CircularProgressIndicator(),
    );
    } else {
      Map<String, dynamic> doc =
      snapshot.data!.data() as Map<String, dynamic>;
      return Container(
        padding: EdgeInsets.fromLTRB(20, 30, 30, 30),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          CircleAvatar(radius: 100,backgroundImage: NetworkImage(doc['image_url']),),
          SizedBox(height: 30,),
          Row(children: [
            const Text('USERNAME:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5,),
            Text(doc['username'], maxLines: 1,),
          ],),

          const SizedBox(
            height: 30,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Bio:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 5,),

              Expanded(child: Text(
                doc['Bio'], maxLines: 4, overflow: TextOverflow.clip,)),

            ],),

          const SizedBox(
            height: 30,
          ),
          Row(children: [
            const Text('Email-Id:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5,),
            Text(doc['email_id'], maxLines: 1,),
          ],),

          const SizedBox(
            height: 30,
          ),
          Row(children: [
            const Text('Company:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5,),
            doc['Company'] == null ? Text('Add Company name') : Text(
              doc['Company'], maxLines: 1,),
          ],),

          const SizedBox(
            height: 30,
          ),

          Row(children: [
            const Text('Position:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5,),
            doc['Position'] == null ? Text('Add Position') : Text(
              doc['Position'], maxLines: 1,),
          ],),


          const SizedBox(
            height: 30,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('About-Company:',
                style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(width: 5,),
              doc['About_company'] == null ? Text(
                  'Add Company Information') : Expanded(child: Text(
                doc['About_company'], maxLines: 4,
                overflow: TextOverflow.ellipsis,)),
            ],),
          const SizedBox(
            height: 30,
          ),
           Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [doc['Linkdin_url']!=null?
              ElevatedButton.icon(onPressed: (){_linkedin(doc['Linkdin_url']);}, icon: Icon(Icons.link_rounded),
               label: const Text('Linkdin'),):ElevatedButton(onPressed: (){}, child: Text('none')),

              doc['email_id']!=null?
              ElevatedButton.icon(onPressed: (){_emailto(doc['email_id']);}, icon: Icon(Icons.email_outlined),
                label: const Text('Email'),):ElevatedButton(onPressed: (){}, child: Text('none')),

            ],
          )
        ],),
      );
    }
            }
        )
        )
    );
  }
}

