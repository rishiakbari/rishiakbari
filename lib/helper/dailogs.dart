// import 'dart:js';
import 'package:flutter/material.dart';

class Dialogs{

  static void showSnackbar(BuildContext , String msg){
    ScaffoldMessenger.of(BuildContext).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.blue.withOpacity(.8),
      behavior: SnackBarBehavior.floating,
      ));
  }

  static void showProgressBar(Context){
    showDialog(
      context: Context, builder: (_)=> Center(child: CircularProgressIndicator()));
  }
}