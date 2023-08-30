import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cat_card extends StatefulWidget{
  const cat_card({super.key});

  @override
  State<StatefulWidget> createState() {
  return _catcardstate();
  }

}

class _catcardstate extends State<cat_card>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){},child: Card(child: Center(child: Text('Category'),),),);
  }

}