import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_ame/components/custom_button.dart';


class QuizResultDetails extends StatelessWidget {
  final List<Map<String, dynamic>> symptoms;

  QuizResultDetails({ this.symptoms});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Ripoti ya Vipimo',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      color: Colors.deepPurple),
                ),

              ],
            ),
          ],
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: symptoms.length,
          itemBuilder: (context, index) {
            final symptom = symptoms[index];
            return Card(
              borderOnForeground: true,
              child: ListTile(
                title: Text(symptom['qn'] ?? ''),
                subtitle: Text('Point:${symptom['score']}'
                  ,style: TextStyle(
                    color: Colors.deepPurple[900],
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:  [
                    Text(' Jibu'),
                    Text( symptom['response']
                      ,style: TextStyle(
                      color: Colors.deepPurple[900],
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    ),


                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


