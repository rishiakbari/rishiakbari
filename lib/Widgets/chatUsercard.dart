import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/chatuser.dart';
import 'package:chatapp/screens/chatscreen.dart';
import 'package:flutter/material.dart';

class chatUsercard extends StatefulWidget {
  final ChatUSer user;
  const chatUsercard({super.key, required this.user});

  @override
  State<chatUsercard> createState() => _chatUsercardState();
}

class _chatUsercardState extends State<chatUsercard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric( vertical: 5),
      color: Colors.white,
      // elevation: 0.5,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => chatScreen(user: widget.user,)));
      },
      child: ListTile(
        // leading: const CircleAvatar(child: Icon(Icons.person),),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: CachedNetworkImage(
            width: 45,
            height:45,
          imageUrl: widget.user.image,
          // placeholder: (context, url) => CircularProgressIndicator(), 
          errorWidget: (context, url, error) => const CircleAvatar(child: Icon(Icons.person),),
             ),
        ),
        title: Text(
          widget.user.name, 
          style: const TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
        subtitle: Text(
          widget.user.about, 
          maxLines: 1,
          style: const TextStyle(color:Colors.black),),
        trailing: const Text(
          '12:00 PM',
          style: TextStyle(color: Colors.black),),
      ) ,
      ),
    );
  }
}