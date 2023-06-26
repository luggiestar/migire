import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '';

import 'chatterScreen.dart';

class SearchScreen extends StatefulWidget {
  //  //accept the data

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  User getUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSigningOut = false;
  bool is_found = false;
  TextEditingController searchController = TextEditingController();

  List<Map> searchResult = [];
  bool isLoading = false;

  //create search functional method
  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .where("is_staff", isEqualTo: true)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No user found")));

        setState(() {
          is_found = false;

          isLoading = false;
        });
        return;
      }
      value.docs.forEach((user) {
        print('User id is ${user.id != getUser.email} ');
        if (user.id != getUser.email) {
          searchResult.add(user.data());
        }
        setState(() {
          is_found = true;

          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    onSearch();
    getUser = _auth.currentUser;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*
      * Creating the app bar with a
      * lending icon (top-left conner)
      * app title (centered)
      * action button (top-right conner)
       */
        appBar:
        AppBar(
          iconTheme: IconThemeData(color: Colors.deepPurple),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size(25, 10),
            child:
            Container(

            ),
          ),
          backgroundColor: Colors.white10,

          title: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    'Watoa Huduma',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        color: Colors.deepPurple),
                  ),
                  Text('Chagua Mtoa Huduma',
                      style: TextStyle(
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
        // centerTitle: true,
        // backgroundColor: CustomColors.firebaseNavy,
        body: Center(
            child: Column(
          children: [
            if (searchResult.isNotEmpty)
              Expanded(
                  child: ListView.builder(
                itemCount: searchResult.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: ()
                    async {
                      setState(() {
                        searchController.text = "";
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  senderId: getUser.email,
                                  receiverId: searchResult[index]['email'],
                                  receiverName: searchResult[index]['name'])));
                    },
                    child:
                    Card(
                        child: ListTile(
                      leading: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                            searchResult[index]['name'].substring(0, 2).trim(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                      ),
                      title: Text(
                        searchResult[index]['name'].toString(),
                        style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      subtitle: Text(
                        searchResult[index]['email'].toString(),
                        style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.normal,
                            fontSize: 10),
                      ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min, // Align the content to the start of the row
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Add your onPressed logic here
                                  },
                                  icon: const Icon(FontAwesomeIcons.streetView),
                                  color: Colors.deepPurple,
                                ),

                                Flexible(
                                  child: Text(
                                    searchResult[index]['location'].toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Handles long location names
                                  ),
                                ),
                              ],
                            ),

                    )),
                  );
                },
              ))
            else if (isLoading == true)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        )));
  }
}
