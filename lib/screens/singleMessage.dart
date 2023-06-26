//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
//
// import '../res/custom_colors.dart';
// // import 'package:weed/res/custom_colors.dart';
// /*
//         * in this screen we implement the message text field
// */
//
//
// class SingleMessage extends StatelessWidget{
// final String message;
// final String date;
// final bool isMe;
//
// /*
//         * ASSIGN VARIABLE INTO CLASS CONSTRUCTOR
//
//          */
// SingleMessage({
//  this.message, this.isMe,this.date
//
// });
//   //declare the _message variable
//
//   @override
//   Widget build(BuildContext context){
//     return
//       Container(
//         padding: EdgeInsets.only(
//             top: 4,
//             bottom: 4,
//             left: isMe ? 0 : 24,
//             right: isMe ? 24 : 0),
//         alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           margin: isMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
//           padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
//           decoration: BoxDecoration(
//             borderRadius: isMe ? BorderRadius.only(
//                 topLeft: Radius.circular(23),
//                 topRight: Radius.circular(23),
//                 bottomLeft: Radius.circular(23)
//             )
//                 :
//             BorderRadius.only(
//                 topLeft: Radius.circular(23),
//                 topRight: Radius.circular(23),
//                 bottomRight: Radius.circular(23)
//             ),
//             color: isMe ? CustomColors.firebaseNavy : Colors.black87,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(message, textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: Colors.white)),
//
//               SizedBox(height: 5.0),
//               Text(date.toLowerCase(), textAlign: TextAlign.right, style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: CustomColors.firebaseOrange, letterSpacing: -0.2)),
//
//             ],
//           ),
//         ),
//       );
//
//
//   }
// }