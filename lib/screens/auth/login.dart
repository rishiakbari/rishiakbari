import 'dart:developer';
import 'dart:io';
import 'package:chatapp/api/apis.dart';
import 'package:chatapp/helper/dailogs.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  bool _isAnimate=false;

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(milliseconds: 500),(){
      setState(() {
        _isAnimate=true;
      });
    }
    );
  }

  _handleGoogleClick(){
    Dialogs.showProgressBar(context); // for showing progress bar
     signInWithGoogle().then((user) async {
      // for hinding progressbar
      Navigator.pop(context);
      if(user != null){
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if(( await APIs.userExists())){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homepage()));
        }
        else{
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homepage()));
          });
        }
      }
      
     });
  }
  Future<UserCredential?> signInWithGoogle() async {
    // ? all return value can be show
  // Trigger the authentication flow
 try{

   await InternetAddress.lookup('google.com'); //when internet was not available than that function through the error and it will given the answer and its a user are otherwise can online OR not.
   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await APIs.auth.signInWithCredential(credential);
}
catch(e){
log('\n_signInWithGoogle : $e'); // error will be printed.
Dialogs.showSnackbar(BuildContext, 'Something Went Wrong. Please Check The Internet! ');
return null;

}
 }
  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: Icon(CupertinoIcons.home),
        title: const Text('Welcome to We Chat',),
        ),
        body: Stack(
          children: [
          AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * 9,
            width: mq.width * .5,
            duration: Duration(milliseconds: 1),
            child: Image.asset('images/icone.png'),
            ),

            Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            
            // height: mq.height * 07,
            child: ElevatedButton.icon(
             onPressed: () {
              _handleGoogleClick();
             },
             icon: Image.asset('images/google.png',
             height: 25,width: 25,
             ),
             label: Text('Signin with Google'),
             style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
             ) ,
             
            )
        ],),
    );
  }
}