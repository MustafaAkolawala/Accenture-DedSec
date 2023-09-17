import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/search_forum.dart';

class Search extends StatefulWidget {
  const Search({super.key,required this.cat});
final cat;
  @override
  State<StatefulWidget> createState() {
    return _searchstate();
  }
}

class _searchstate extends State<Search> {
  final TextEditingController searchcontroller = TextEditingController();
  bool isshowposts= false;

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: TextFormField(
          controller: searchcontroller,
          decoration: InputDecoration(labelText: 'Search Questions'),
          onFieldSubmitted: (String _){
            setState(() {
              isshowposts=true;
            });
          },
        ),
      ),
      body: isshowposts?StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Forum_posts').doc(widget.cat).collection('posts').where('Question',isGreaterThanOrEqualTo: searchcontroller.text).snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(itemCount: (snapshot.data!as dynamic).docs.length,itemBuilder: (context,index)=>Search_forum(snap: (snapshot.data!as dynamic).docs[index].data(), category: widget.cat));
        },
      ):Center(child: Text('Search kar laude pehle'),),
    );
  }
}
