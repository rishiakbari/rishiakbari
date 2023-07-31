import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Widgets/messagecard.dart';
import 'package:chatapp/api/apis.dart';
import 'package:chatapp/models/chatuser.dart';
import 'package:chatapp/models/message.dart';
import 'package:flutter/material.dart';

class chatScreen extends StatefulWidget {


  final ChatUSer user;

  const chatScreen({super.key, required this.user});

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {

  List<Message> _list = []; // for storing all msg

  final _textController = TextEditingController(); // for handaling message text changes

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Color(0xff4a1724),
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),

        backgroundColor: const Color(0xffac3863),

        body: Column(
          children: [

             Expanded(
               child: StreamBuilder(
                       stream: APIs.getAllMessages(widget.user), // where to get the msg
                       builder: (context,snapshot){
                       
                       
                switch(snapshot.connectionState){
                // if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                return const Center(child: CircularProgressIndicator(),);
                       
                // if some or all data is loaded than show it
                       
                case ConnectionState.active:
                case ConnectionState.done:
                       
                       
                         // if(snapshot.hasData){
                final data=snapshot.data?.docs;
                // log('Data : ${jsonEncode(data![0].data())}');

                // whaterver will come to data and that data can do itreate to map function which has took among the data and it can create a list and that do a work.    
                _list= 
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

              // _list.clear();  // means Msg can not repeat them.
              // _list.add(Message(
              //   toId: 'xyz', 
              //   read: '', 
              //   msq: 'Hii', 
              //   type: Type.text, 
              //   fromId: APIs.user.uid, 
              //   sent: '12:00 AM'
              //   ),);
              // _list.add(Message(
              //   toId: APIs.user.uid, 
              //   read: '', msq: 'Hello', 
              //   type: Type.text, 
              //   fromId: 'xyz', 
              //   sent: '12:00 AM'
              //   ),);
                       
                if(_list.isNotEmpty){
                   return ListView.builder(
                         itemCount: _list.length,
                         padding: const EdgeInsets.only(top: 8),
                         physics: const BouncingScrollPhysics(),// sccree
                         itemBuilder:(BuildContext, index) {
                return MessageCard(message: _list[index]); // show the data in screen.
                         
                });
                }
                else{
                  return   const Center(
                    child:  Text(
                    'Say Hii! 👋' ,
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500), 
                    ),
                  );
                }
                  }
                       }
                     ),
             ),
            _chatInput(),
          ],
        ),
      ),
    );
  }


  Widget _appBar(){

    return InkWell(
      onTap: () {},
      child: Row(
        children: [
    
          // back button 
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: const Icon( Icons.arrow_back,color: Colors.white,)),
    
            // user profile picture
            ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CachedNetworkImage(
              width: 45,
              height:45,
            imageUrl: widget.user.image,
            errorWidget: (context, url, error) => const CircleAvatar(child: Icon(Icons.person),),
               ),
          ),
    
          // for adding some space
          const SizedBox(width: 10,),
    
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name, 
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, 
                  fontWeight: FontWeight.bold
                  ),
                ),
    
                const SizedBox(height: 0.5,),
    
               const Text(
                'Last seen is not available', 
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }


  // bottom chat input field
  Widget _chatInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10,horizontal: 10 ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
            
                  // emoji icon
                  IconButton(
                      onPressed: (){}, 
                      icon: const Icon( Icons.emoji_emotions,color: Colors.blue,size: 25,)),
            
                        Expanded(
                        child: TextField(
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: 'Type Something...',
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,                  
                          ),
                        )
                        ),
            
                      // pick image form gallary
                      IconButton(
                      onPressed: (){}, 
                      icon: const Icon( Icons.image,color: Colors.blue,size: 26,)),
            
                      // take image from 
                      IconButton(
                      onPressed: (){}, 
                      icon: const Icon( Icons.camera_alt,color: Colors.blue,size: 26,)),

                      SizedBox(width: 3,)
                ],
              ),
            ),
          ),
    
          // Send button
          MaterialButton(
            onPressed: (){
              if(_textController.text.isNotEmpty){
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text='';
              }
            },
            minWidth: 0, // button can attached the screen
            padding: EdgeInsets.only(top: 10,bottom: 10,right: 5,left: 10),
            shape: CircleBorder(),
            color: Colors.green,
            child: Icon(Icons.send , color: Colors.white, size: 28,),
            ),
        ],
      ),
    );
  }
  
}