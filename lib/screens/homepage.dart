import 'dart:core';
import 'package:chatapp/Widgets/chatUsercard.dart';
import 'package:chatapp/api/apis.dart';
import 'package:chatapp/models/chatuser.dart';
import 'package:chatapp/screens/profilescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  // bool _debugLocked = false;

   // for storing all user
   List<ChatUSer> _list = [];

   // for storing search user
   final List<ChatUSer> _searchList=[];

   bool _issearching = false;
   @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if(_issearching){
            setState(() {
              _issearching != _issearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Icon(CupertinoIcons.home),
            title: _issearching 
            ? TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',),
                autofocus: true, // automatic curser can put the textfield
                style: TextStyle(fontSize: 16 , letterSpacing: 0.5),
          
                // when search text changes than updated search list
                onChanged: (val){
                  // search logic
                  _searchList.clear();
          
                  for (var i in _list) {
                    if(i.name.toLowerCase().contains(val.toLowerCase())||
                    i.email.toLowerCase().contains(val.toLowerCase())){
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }
                },
            ) 
            : const Text('We Chat',),
            actions: [
              IconButton(
                onPressed: (){
                setState(() {
                  _issearching != _issearching;
                });
              }, 
              icon: Icon(
                 _issearching? CupertinoIcons.add_circled_solid
                 :Icons.search,
                 ),
                 ),
              IconButton(onPressed: (){
                Navigator.push(
                  context, MaterialPageRoute(
                  builder: (_)=>profilescreen(user: APIs.me,)));
              }, icon: const Icon(Icons.more_vert)),
            ],
            ),
          
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(onPressed: ()async{
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              } ,child: Icon(Icons.add_circle_outline_rounded),),
            ),
          
        body: StreamBuilder(
          stream: APIs.getAllUsers(), // where to get the data 
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
          
              _list=
              data?.map((e) => ChatUSer.fromJson(e.data())).toList() ?? [];
          
              if(_list.isNotEmpty){
                 return ListView.builder(
            itemCount: _issearching ? _searchList.length : _list.length,
            padding: const EdgeInsets.only(top: 8),
            physics: const BouncingScrollPhysics(),// sccree
            itemBuilder:(BuildContext, index) {
              return  chatUsercard(
                user: _issearching 
                ? _searchList[index] 
                : _list[index]
                );
              // return Text('Name:${list[index]}'); // show the data in screen.
            }
            );
              }
              else{
                return   const Center(
                  child:  Text(
                  'No Connection Found!' ,
                  style: TextStyle(fontSize: 20), 
                  ),
                );
              }
                }
          }
        ),
        ),
      ),
    );
  }
}