import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:chatapp/models/chatuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs{
  // For Authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // For Accessing cloud firestore databse
  static FirebaseFirestore Firestore = FirebaseFirestore.instance;

  // For Accessing  Firebase Storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information
  static late ChatUSer me;

  // to return current user
  static  User get user => auth.currentUser!;

  // for checking if user exists or not?

  static Future<bool> userExists() async {
    return (await Firestore
    .collection('User')
    .doc(user.uid) 
    .get())
    .exists;
  }

  // for getting current user info
  static Future<void> getSelfInfo() async{
    await Firestore.collection('User').doc(user.uid).get().then((User) async{

      if(User.exists){
        me=ChatUSer.fromJson(User.data()!);
        // log('My Data : ${User.data()}');  // 
      }else{
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // For create a new user

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUSer =  ChatUSer(
    id: user.uid,
    name: user.displayName.toString(),
    email : user.email.toString(),
    about : "hey, i am using chat Application!",
    image : user.photoURL.toString(),
    createdAt : time,
    isOnline : false,
    lastActive : time,
    pushToken : '',
    ); 

    return (await Firestore
    .collection('User')
    .doc(user.uid) 
    .set(chatUSer.toJson()));
  }

  // for getting all user from firbase database

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return Firestore.collection('User')
    .where('id', isNotEqualTo: user.uid)
    .snapshots();
  }

  // for updating user info
  static Future updateUserInfo() async {
    await Firestore.collection('User').doc(user.uid).update({
      'name' : me.name,
      'about' : me.about,
    });
  }

  static Future<void> updateProfilePicture(File file) async {

    // getting imahe file extension
    final ext = file.path.split('.').last; // arter dot(.) can give return the value
    log('Extension $ext');

    // stroage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    // uploading image 
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('data transfer : ${p0.bytesTransferred / 1000 } kb');
    });

    // updating image in firestore database 
    me.image = await ref.getDownloadURL();
    await Firestore.collection('User').doc(user.uid).update({
      'image' : me.image,
      
    });
  }

  } 