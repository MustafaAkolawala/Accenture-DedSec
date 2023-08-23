import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
final _auth= FirebaseAuth.instance;

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _loginstate();
  }
}

class _loginstate extends State<login> {
  var _islogin=true;
  var _enteredemail='';
  var _enteredpassword='';
  var _enteredusername='';
  var _confirmpass='';
  final _formkey= GlobalKey<FormState>();
  void _submit() async{
    final _isvalid=_formkey.currentState!.validate();
    if(!_isvalid){
      return;
    }
    _formkey.currentState!.save();
    try{
      if(_islogin){
        final usercredetials=await _auth.signInWithEmailAndPassword(email: _enteredemail, password: _enteredpassword);
      }
      else {
        final usercredentials = await _auth.createUserWithEmailAndPassword(
            email: _enteredemail, password: _enteredpassword);

      }
    }


      on FirebaseAuthException catch(error){
if(error.code=='email-already-in-use'){
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message?? 'Authentication failed'),));
}
      }
await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
  'username': _enteredusername,
  'email_id' : _enteredemail,
  'image_url' : 'to be done',
  'company_name': 'to be done',
  'position':'to be done',
  'About_company' : 'to be done'
});

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(!_islogin)
                            TextFormField(decoration: const InputDecoration(labelText: 'Username'),autocorrect: false,textCapitalization: TextCapitalization.none,validator: (value){if(value==null||value.isEmpty){return 'Enter an username';}return null;},onSaved: (value){_enteredusername=value!;},),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value){
                              if(value==null||value.isEmpty||!value.contains('@')){
                                return 'Please enter a valid Email Address';
                              }
                              return null;
                            },
                            onSaved: (value){
                              _enteredemail=value!;
                            },
                          ),
                          TextFormField(
                            decoration:
                            const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value){
                              if(value==null||value.isEmpty||value.trim().length<8){
                                return 'Password must be atleast 8 characters long';
                              }
                              return null;
                            },
                            onSaved: (value){
                              _enteredpassword=value!;
                            },
                          ),
                          if(!_islogin)
                            TextFormField(decoration: const InputDecoration(labelText: 'Confirm Password'),obscureText:true,autocorrect: false,textCapitalization: TextCapitalization.none,validator: (value){if(value==null||value.isEmpty){return 'Please confirm your password';}return null;},onSaved: (value){if(value!=_enteredpassword){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plaease enter correct password')));}},),
                          const SizedBox(height: 20,),
                          ElevatedButton(onPressed: _submit, child:  Text( _islogin?'Sign In':'Sign Up')),
                          const SizedBox(height: 8,),
                          const Text('or'),
                          Text(_islogin?'Login using':'signup using'),
                          OutlinedButton(onPressed: (){}, child: SizedBox(width:50,height:50,child:Image.asset('assets/images/google_logo.png'),)),
                          const SizedBox(height: 50,),
                          TextButton(onPressed: (){setState(() {
                            _islogin=!_islogin;
                          });}, child:  Text(_islogin?'New user sign up':'Already have an account Login')),

                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
