import 'dart:async';
import 'package:chatapp/api/apis.dart';
import 'package:chatapp/screens/auth/login.dart';
import 'package:chatapp/screens/homepage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {

   void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 5),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

       if(APIs.auth.currentUser != null){
        // log('\nUser : ${Firebase.instance.currenUser}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => homepage()));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => login()));
      }
    });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Lottie.network('https://assets3.lottiefiles.com/packages/lf20_q8ND1A8ibK.json'),
          ),
        ],
        )
        ),
      );
  }
}