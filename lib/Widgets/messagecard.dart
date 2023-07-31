import 'package:chatapp/api/apis.dart';
import 'package:chatapp/models/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId 
    ? _greenMessage() 
    : _blueMessage();
  }

  // sender or another user message 
  Widget _blueMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        // wrap the msg
        Flexible( 
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
            decoration: const BoxDecoration(
              color:  Color(0xff2e2f2f),
              borderRadius:   BorderRadius.all(Radius.circular(20)),
              ),
            child: Text(
              widget.message.msq,
              style: const TextStyle(
                fontSize: 15 , color: Colors.white,
                ),
              ),
          ),
        ),

        //to show the time
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            widget.message.sent,
            style: const TextStyle(fontSize: 13,color: Colors.white),
          ),
        )
      ],
    );
  } 

  // our or user message 
  Widget _greenMessage(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //to show the time
        Row(
          children: [

             // for adding some space 
             SizedBox(width: 10,),

            // doule tick blue icon for msg read
            Icon(Icons.done_all_rounded , color: Colors.white, size: 20,),

            // for adding some space 
             SizedBox(width: 1,),

            Text(
              '${widget.message.read}12:00 AM',
              style: const TextStyle(fontSize: 13,color: Colors.white),
            ),
          ],
        ),

          // wrap the msg
         Flexible( 
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
            decoration:const BoxDecoration(
              color:  Color(0xff8e3db3),
               borderRadius:   BorderRadius.all(Radius.circular(20)),
              // borderRadius: const BorderRadius.only(
              //   topLeft: Radius.circular(30),
              //   topRight: Radius.circular(30),
              //   bottomLeft: Radius.circular(30)
              // ),
              ),
            child: Text(
              widget.message.msq,
              style: const TextStyle(
                fontSize: 15 , color: Colors.white,
                ),
              ),
          ),
        ),

      ],
    );
  }
}