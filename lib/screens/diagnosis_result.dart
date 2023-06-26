import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'diagnosis_result_details.dart';

class QuizResultsScreen extends StatefulWidget {
  const QuizResultsScreen({Key key}) : super(key: key);



  @override
  _QuizResultsScreenState createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
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
      appBar:
      AppBar(
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size(25, 10),
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
                  'Jipime App',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      color: Colors.deepPurple),
                ),
                Text('Majibu ya Uchunguzi',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.deepPurple))
              ],
            ),
          ],
        ),

      ),
      body:
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
                    Icons.report_gmailerrorred,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "Majibu Yangu",
                  style: TextStyle(
                    color: Colors.deepPurple[900],
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: const Text(
                  "Kumbuka, Majibu haya si sahihi yasipothibitishwa na Vipimo vya Maabara",
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Diagnosis')
                  .doc(user.email)
                  .collection('results')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final results = snapshot.data.docs;
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final data = results[index].data();
                    final List<dynamic> savedSymptoms = data['savedSymptoms'];
                    final symptomsList =
                    List<Map<String, dynamic>>.from(savedSymptoms);
                    // convert the date time from the firestore
                    Timestamp timestamp = data['date'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                    return Card(
                      borderOnForeground: true,
                      child: ListTile(
                        title: Text(data['disease'],
                          style: TextStyle(
                            color: Colors.deepPurple[900],
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text('Tarehe: $formattedDateTime'),
                        trailing: Column(
                          children: [
                            Text('${data['percent']}%',
                              style: TextStyle(
                                color: Colors.deepPurple[900],
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),),
                            const Icon(
                              Icons.remove_red_eye,
                              size: 30,
                              color: Colors.deepPurple,
                            ),

                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizResultDetails(
                                symptoms: symptomsList,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      )
    );
  }
}

