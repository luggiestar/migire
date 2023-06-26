import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_ame/screens/searchScreen.dart';

import 'chatterScreen.dart';


class PrivateChat extends StatefulWidget {
  const PrivateChat ({Key key}) : super(key: key);


  @override
  _PrivateChatState createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  bool isSearching = false;
  String userdata ="";


  TextEditingController searchUsernameEditingController =
  TextEditingController();
  User getUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  void initState() {
    getUser = _auth.currentUser;

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

      /*
      * Creating the app bar with a
      * lending icon (top-left conner)
      * app title (centered)
      * action button (top-right conner)
       */

      body:
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(getUser.email).collection('messages').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){

            if(snapshot.data.docs.length <1){
              return const Center(
                child: Text(
                    "Wasiliana na Daktari sasa"
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,

                itemBuilder: (context, index){
                  var receiverId = snapshot.data.docs[index].id;
                  var lastMsg = snapshot.data.docs[index]['last_msg'];
                  var id = snapshot.data.docs[index]['is_receiver'];
                  return
                    FutureBuilder(
                        future: FirebaseFirestore.instance.collection('users').doc(receiverId).get(),
                        builder: (context,AsyncSnapshot  asyncSnapshot){
                          if(asyncSnapshot.hasData){
                            var receiver =asyncSnapshot.data;
                            return       Container(
                              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                              child:
                              Card(
                                child: ListTile(
                                  leading:
                                  CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.deepPurple,
                                    child: Text(receiver['name'].substring(0, 2).trim(),
                                        textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                  ),
                                  title: Text(receiver['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text("$lastMsg", style: TextStyle(fontSize: 13.0),overflow: TextOverflow.ellipsis,),
                                  trailing: id?Icon(FontAwesomeIcons.envelope,color: Colors.red,):Icon(Icons.done,color: Colors.grey,) ,
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(
                                      senderId: getUser.email,
                                      receiverId: receiver['email'],
                                      receiverName: receiver['name'],
                                      // senderImage: receiver['image']
                                    )
                                    ));
                                  },
                                ),
                              ),

                            );
                          }
                          return LinearProgressIndicator();

                        }
                    );
                });

          }
          return const Center(
            child: CircularProgressIndicator(),
          );


        },
        /*
        * this container will contain the text messaging area where sender can send a message to receiver
        * to improve code readability we created the widget in widget folder that will contain the functionality

         */


      ),
      /*
        * the floating button below is used to search friend
        * once you hit the button it will navigate to the search page so that user can type
        * for username and initiate the chat

         */

      floatingActionButton:

      FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
        },

      ),


    );
  }
}

