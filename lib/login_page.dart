import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackathon/auth_method.dart';
import 'package:hackathon/forgot_pass.dart';
import 'package:hackathon/home_screen.dart';

final _auth = FirebaseAuth.instance;
bool _isloading = false;

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _loginstate();
  }
}

class _loginstate extends State<login> {
  final uername = TextEditingController();
  final pass=TextEditingController();
  final em= TextEditingController();
  final cp= TextEditingController();
  var _islogin = true;
  var _enteredemail = '';
  var _enteredpassword = '';
  var _enteredusername = '';
  var _confirmpass = '';

  final _formkey = GlobalKey<FormState>();

  void _submit() async {
    setState(() {
      _isloading=true;
    });
    final _isvalid = _formkey.currentState!.validate();
    if (!_isvalid) {
      setState(() {
        _isloading=false;
      });
      return;
    }
    _formkey.currentState!.save();
    try {
      if (_islogin) {
        final usercredetials = await _auth.signInWithEmailAndPassword(
            email: _enteredemail, password: _enteredpassword);
        if (usercredetials.user!.emailVerified == false) {
          setState(() {
            _isloading=false;
          });
          usercredetials.user!.sendEmailVerification();
          usercredetials.user!.reload();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Check your Email for verification')));
          em.clear();
          pass.clear();
        } else {
          setState(() {
            _isloading=false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Homescreen()));
        }
      } else {
        String res = await Auth_method().signup(
            username: _enteredusername,
            emailid: _enteredemail,
            password: _enteredpassword);
        setState(() {
          _islogin=false;
        });
        if(FirebaseAuth.instance.currentUser!.emailVerified==false){
          FirebaseAuth.instance.currentUser!.sendEmailVerification();
          FirebaseAuth.instance.currentUser!.reload();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Check your Email for verification')));
          uername.clear();
          em.clear();
          pass.clear();
          cp.clear();
          Navigator.push(context , MaterialPageRoute(builder: (context)=>login()));


        }
        if(res=='success'){
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User created successfully'),duration: Duration(milliseconds: 8),));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Homescreen()));
          setState(() {
            _islogin=false;
          });
        }

        else{
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong!! Try again'),duration: Duration(milliseconds: 8),));
        }
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ));
      }
    }
  }

  /*Future<UserCredential> googlesignin() async {
    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gauth = await guser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gauth.accessToken,
      idToken: gauth.idToken,
    );
    final auth = await FirebaseAuth.instance.signInWithCredential(credential);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.user!.uid)
        .set({
      'username': guser.displayName,
      'email_id': guser.email,
      'image_url': guser.photoUrl,
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Homescreen()));
    return auth;
  }*/

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
                          if (!_islogin)
                            TextFormField(
                              controller: uername,
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter an username';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredusername = value!;
                              },
                            ),
                          TextFormField(
                            controller: em,
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid Email Address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredemail = value!;
                            },
                          ),
                          TextFormField(
                            controller: pass,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 8) {
                                return 'Password must be atleast 8 characters long';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredpassword = value!;
                            },
                          ),
                          if (!_islogin)
                            TextFormField(
                              controller: cp,
                              decoration: const InputDecoration(
                                  labelText: 'Confirm Password'),
                              obscureText: true,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != _enteredpassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Plaease enter correct password')));
                                }
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => const Forgot_pass()));},
                                  child: Text('Forgot Password?'))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          /*const Text('Or continue using'),
                          ElevatedButton.icon(
                            icon: SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.asset(
                                    'assets/images/google_logo.png')),
                            onPressed: googlesignin,
                            label: Text('google'),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),*/
                          ElevatedButton(
                              onPressed: _submit,
                              child: _isloading?const Center(child: CircularProgressIndicator(color: Colors.purpleAccent,),):Text(_islogin ? 'Sign In' : 'Sign Up')),
                          const SizedBox(
                            height: 50,
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _islogin = !_islogin;
                                  em.clear();
                                  uername.clear();
                                  pass.clear();
                                  cp.clear();
                                });
                              },
                              child: Text(_islogin
                                  ? 'New user sign up'
                                  : 'Already have an account Login')),
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
