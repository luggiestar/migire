
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:quiz_ame/screens/quiz.dart';





class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {




  Stream<QuerySnapshot> getSTDS() {
    return FirebaseFirestore.instance.collection('STDS').snapshots();
  }


  @override
  void initState() {
    super.initState();

    getSTDS();
  }


  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              borderOnForeground: true,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple[900],
                  child: const Icon(
                    Icons.info_outline_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "Zingatia",
                  style: TextStyle(
                    color: Colors.deepPurple[900],
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: const Text(
                  "Majibu ya Uchunguzi yanaweza yasiwe sahihi\nUnashauriwa kuwasiliana na wataalamu ndani ya Mfumo huu baada ya Uchunguzi",
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getSTDS(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: snapshot.data.docs.map((document) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: ()=>             {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  Quiz(document.id),
                          ),
                        )
                        }
                        ,
                        child: Card(
                          borderOnForeground: true,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple[900],
                              child:
                              const Icon(
                                Icons.biotech_rounded,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(document.id,style:
                            TextStyle(
                                color: Colors.deepPurple[900],
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w700),),
                            subtitle: Text(document['desc']),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      );



  }

}

