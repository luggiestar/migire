import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/constants.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

String messageText;

class ChatScreen extends StatefulWidget {
  /*
        * we started with the declaration of required data for both, sender and receiver

         */
  final String senderId;
  final String receiverId;
  final String receiverName;

  /*
        * create the class constructor so that it will be easy to retrieve data

         */
  ChatScreen({
    this.senderId,
    this.receiverId,
    this.receiverName,
  });
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatMsgTextController = TextEditingController();
  User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepPurple),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size(25, 10),
          child: Container(),
        ),
        backgroundColor: Colors.white10,
        title: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 Text(
                  widget.receiverName,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      color: Colors.deepPurple),
                ),
                Text(widget.receiverId,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.deepPurple))
              ],
            ),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            child: Icon(Icons.more_vert),
          )
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ChatStream(
            senderId: widget.senderId,
            receiverId: widget.receiverId,
            senderName: widget.receiverName,
            // senderImage: receiver['image']
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                      child: TextField(
                        onChanged: (value) {
                          messageText = value;
                        },
                        controller: chatMsgTextController,
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                    shape: CircleBorder(),
                    color: Colors.deepPurple[900],
                    onPressed: () {
                      chatMsgTextController.clear();
                      // step 2 save the sender  message to firebase store, we created a new collection "message" which hold the user id and the chats docs which hold the chats
                      firestore
                          .collection('users')
                          .doc(widget.senderId)
                          .collection('messages')
                          .doc(widget.receiverId)
                          .collection('chats')
                          .add({
                        'sender': widget.senderId,
                        'receiver': widget.receiverId,
                        'text': messageText,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      }).then((value) {
                        firestore
                            .collection('users')
                            .doc(widget.senderId)
                            .collection('messages')
                            .doc(widget.receiverId)
                            .set({
                          "last_msg": messageText,
                          "is_receiver": false
                        });
                      });
                      // step 2 save the receiver  message to firebase store, we created a new collection "message" which hold the user id and the chats docs which hold the chats
                      firestore
                          .collection('users')
                          .doc(widget.receiverId)
                          .collection('messages')
                          .doc(widget.senderId)
                          .collection('chats')
                          .add({
                        'sender': widget.senderId,
                        'receiver': widget.receiverId,
                        'text': messageText,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      }).then((value) {
                        // save the last message so that it will be easy to fetch data
                        firestore
                            .collection('users')
                            .doc(widget.receiverId)
                            .collection('messages')
                            .doc(widget.senderId)
                            .set(
                                {"last_msg": messageText, "is_receiver": true});
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(


                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                    // Text(
                    //   'Send',
                    //   style: kSendButtonTextStyle,
                    // ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }
}
class ChatStream extends StatefulWidget {
  /*
        * we started with the declaration of required data for both, sender and receiver

         */
  final String senderId;
  final String receiverId;
  final String senderName;

  /*
        * create the class constructor so that it will be easy to retrieve data

         */
  ChatStream({
    this.senderId,
    this.receiverId,
    this.senderName,
  });
  @override
  _ChatStreamState createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore
          .collection('users')
          .doc(user.email)
          .collection('messages')
          .doc(widget.receiverId)
          .collection('chats')
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data.docs.reversed;
          Map<String, List<MessageBubble>> messageGroups = {};
          for (var message in messages) {
            final msgText = message.data()['text'];
            final msgSender = message.data()['sender'];
            final time = message.data()['timestamp'];
            final currentUser = user.email;

            DateTime dateTime = Timestamp.fromMillisecondsSinceEpoch(time).toDate();
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

            // Create a new message group for this date if it doesn't exist
            if (!messageGroups.containsKey(formattedDate)) {
              messageGroups[formattedDate] = [];
            }

            final msgBubble = MessageBubble(
              msgText: msgText,
              msgSender: msgSender,
              time: DateFormat('HH:mm:ss').format(dateTime),
              user: currentUser == msgSender,
            );

            messageGroups[formattedDate].add(msgBubble);
          }

          List<Widget> messageWidgets = [];
          messageGroups.keys.toList().reversed.forEach((date) {
            // Add the date header before the messages for this date
            messageWidgets.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back_ios, size: 12),
                  const SizedBox(width: 5),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ));

            // Add the messages for this date
            messageWidgets.addAll(messageGroups[date].reversed);
          });

          return Expanded(
            child: ListView(
              reverse: false,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets,
            ),
          );
        }

        else {
          return const Center(
            child:
            CircularProgressIndicator(backgroundColor: Colors.deepPurple),
          );
        }
      },
    );
  }
}

// class ChatStream extends StatefulWidget {
//   /*
//         * we started with the declaration of required data for both, sender and receiver
//
//          */
//   final String senderId;
//   final String receiverId;
//   final String senderName;
//
//   /*
//         * create the class constructor so that it will be easy to retrieve data
//
//          */
//   ChatStream({
//     this.senderId,
//     this.receiverId,
//     this.senderName,
//   });
//   @override
//   _ChatStreamState createState() => _ChatStreamState();
// }

// class _ChatStreamState extends State<ChatStream> {
//   User user;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   @override
//   void initState() {
//     super.initState();
//     user = _auth.currentUser;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: firestore
//           .collection('users')
//           .doc(user.email)
//           .collection('messages')
//           .doc(widget.receiverId)
//           .collection('chats')
//           .orderBy('timestamp')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final messages = snapshot.data.docs.reversed;
//           List<MessageBubble> messageWidgets = [];
//           for (var message in messages) {
//             final msgText = message.data()['text'];
//             final msgSender = message.data()['sender'];
//             final time = message.data()['timestamp'];
//             // final msgSenderEmail = message.data['senderemail'];
//             final currentUser = user.email;
//
//             DateTime dateTime = Timestamp.fromMillisecondsSinceEpoch(time).toDate();
//             // String formattedDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
//             String formattedDateTime = DateFormat('dd-MM HH:mm:ss').format(dateTime);
//
//             // print('MSG'+msgSender + '  CURR'+currentUser);
//             final msgBubble = MessageBubble(
//                 msgText: msgText,
//                 msgSender: msgSender,
//                 time: formattedDateTime,
//                 user: currentUser == msgSender);
//             messageWidgets.add(msgBubble);
//           }
//           return Expanded(
//             child: ListView(
//               reverse: true,
//               padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//               children: messageWidgets,
//             ),
//           );
//         } else {
//           return const Center(
//             child:
//                 CircularProgressIndicator(backgroundColor: Colors.deepPurple),
//           );
//         }
//       },
//     );
//   }
// }

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final String time;
  final bool user;
  MessageBubble({this.msgText, this.msgSender, this.user, this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              user ? 'mimi': '',
              style:  TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.deepPurple[900]),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: user ? Radius.circular(50) : Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: user ? Radius.circular(0) : Radius.circular(50),
            ),
            color: user ? Colors.deepPurple : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.white : Colors.blue,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              time,
              style:  TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.deepPurple[900]),
            ),
          ),
        ],
      ),
    );
  }
}


