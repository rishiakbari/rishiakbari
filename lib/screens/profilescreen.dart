import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/api/apis.dart';
import 'package:chatapp/helper/dailogs.dart';
import 'package:chatapp/models/chatuser.dart';
import 'package:chatapp/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';


class profilescreen extends StatefulWidget {
  final ChatUSer user;
  const profilescreen({super.key, required this.user});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  final _formkey = GlobalKey<FormState>();
  // bool _debugLocked = false;
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // whatever you want to click the screen than keyboard should be hide 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('Profile Screen',),),
          
      body: Form(
        key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SingleChildScrollView(  // means no wrap the screen and properly show the screen 
                  child: Column(
                    children: [
                       Stack(
                         children: [
            
                          _image != null ?  
            
                          // local image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              File(_image!),
                              width: 170,
                              height: 170,
                              fit: BoxFit.cover,
                               ),
                          ):
                           ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              width: 170,
                              height: 170,
                              fit: BoxFit.fill,
                            imageUrl: widget.user.image,
                            // placeholder: (context, url) => CircularProgressIndicator(), 
                            errorWidget: (context, url, error) => const CircleAvatar(child: Icon(Icons.person),),
                               ),
                      ),
                    
                    // Edite the photo
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                        onPressed: () {
                          _showBottomSheet();
                        },
                        shape: const CircleBorder(),
                        color: Colors.white,
                        child: const Icon(Icons.edit, color: Colors.blue,),
                        ),
                      )
                         ],
                       ),
                      
                      SizedBox(height: 10,),
                    
                      Text(widget.user.email, style: TextStyle(fontSize: 20),),
                      
                       SizedBox(height: 20,),
                    
                       Padding(
                         padding: const EdgeInsets.all(15),
                         child: TextFormField(
                          initialValue: widget.user.name,
                          onSaved: (val) => APIs.me.name = val ?? '',
                          validator: (val) => val!=null && val.isNotEmpty 
                          ? null 
                          : 'Required Field',
                          decoration: InputDecoration(
                            label: const Text('Name'),
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            hintText: 'Ex. Rishi Akbari',
                          ),
                         ),
                       ),
                    
                       Padding(
                         padding: const EdgeInsets.all(15),
                         child: TextFormField(
                          initialValue: widget.user.about,
                          onSaved: (val) => APIs.me.about = val ?? '',
                          validator: (val) => val!=null && val.isNotEmpty 
                          ? null 
                          : 'Required Field',
                          decoration: InputDecoration(
                            label: const Text('About'),
                            prefixIcon: const Icon(Icons.info_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            hintText: 'hello, Everyone !',
                          ),
                         ),
                       ),
                    
                       SizedBox(height: 20,),
                    
                    
                       ElevatedButton.icon(
                        onPressed: (){
                          if(_formkey.currentState!.validate()){
                            _formkey.currentState?.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackbar(context, 'Profile Updated Successfully!');
                            });
                          }
                        }, 
                        icon: Icon(Icons.edit), 
                        label: Text('Update'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          
        ),

            // Logout button
            floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
    
              // LOG OUT PROCESSES
              onPressed: ()async{
                // showing progressbar
                Dialogs.showProgressBar(context);
                // signout from app
                 await APIs.auth.signOut().then((value)  async {
                  await GoogleSignIn().signOut().then((value) {

                    // for hiding progress dailog
                    Navigator.pop(context);
    
                    // for moving to home screen
                    Navigator.pop(context);
    
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> login()));
                  });
                 });
              
            } ,
             icon:const Icon(Icons.logout, color: Colors.white,), 
             elevation: 5,
             label: Text(
              'Log Out',
             style: TextStyle(color: Colors.white),
             ),
             ),
          ),
      )
      );
    
  }
  void _showBottomSheet(){
    showModalBottomSheet(context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
        ),
    ),
     builder: (_) {
      return ListView(
        shrinkWrap: true,  // Only show the according to content.
        padding: EdgeInsets.only(top:50 , bottom: 50 ),
        children: [
           const Text(
              "Pick Profile Picture",
              textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

            SizedBox(height: 2),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

              // pick from gallary
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                  fixedSize: Size(100,150)
                ),
                onPressed:()  async {
                  final ImagePicker picker = ImagePicker();
                  // Pick an image.
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if(image != null){
                    log('Image Path : ${image.path} -- MimeType: ${image.mimeType}');
                    setState(() {
                      _image = image.path;
                    });

                    APIs.updateProfilePicture(File(_image!)); // !-> img is not null
                        // for hinding botton sheet
                        Navigator.pop(context);
                  }
                }, 
              child: Image.asset('images/addimage.png')
              ),

              // pick from camera
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                  fixedSize: Size(100,150)
                ),
                onPressed:() async {
                  final ImagePicker picker = ImagePicker();
                  // Pick an image.
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if(image != null){
                    log('Image Path : ${image.path}');
                    setState(() {
                      _image = image.path;
                    });

                     APIs.updateProfilePicture(File(_image!)); // !-> img is not null
                        // for hinding botton sheet
                        Navigator.pop(context);
                  }
                }, 
              child: Image.asset('images/camera.png')
              ),
            ],
            ),
          
        ],
      );
    });
  }
}