import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz_ame/components/quiz_option.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_ame/screens/dashboard.dart';

import 'diagnosis_result.dart';

class Quiz extends StatefulWidget {
  final String id;
  const Quiz(this.id, {Key key,}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {

  User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String id;

  List<Map<String, dynamic>> questions = [];
  String currentTitle;
  String currentCorrectAnswer;
  List<dynamic> currentAnswers;
  int corrects;
  int currentQuestion;
  int selectedAnswer;
  DateTime now;

  @override
  void initState() {
    now = DateTime.now();
    corrects = 0;
    currentQuestion = 0;
    questions = null;
    selectedAnswer = null;
    user = _auth.currentUser;

    getQuestions();
    super.initState();
  }


  Future<void> getQuestions() async {
    try {
      final CollectionReference<Map<String, dynamic>> stdsSymptoms =
      FirebaseFirestore.instance.collection('STDS').doc(widget.id).collection('Symptoms');

      final CollectionReference<Map<String, dynamic>> stdsSymptomsLower =
      FirebaseFirestore.instance.collection('STDS').doc(widget.id).collection('symptoms');

      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await stdsSymptoms.get();
      final QuerySnapshot<Map<String, dynamic>> querySnapshotLower =
      await stdsSymptomsLower.get();

      final List<Map<String, dynamic>> symptoms =
      querySnapshot.docs.map((doc) => doc.data()).toList();
      final List<Map<String, dynamic>> symptomsLower =
      querySnapshotLower.docs.map((doc) => doc.data()).toList();

      final List<Map<String, dynamic>> combinedSymptoms = [...symptoms, ...symptomsLower];

      if (combinedSymptoms.isEmpty) {
        // Handle case where there are no documents
        print('No documents found');
        return;
      }

      setState(() {
        questions = combinedSymptoms;
        currentTitle = questions[0]['qn'] as String;
        currentCorrectAnswer = 'Ndio';
        currentAnswers = [currentCorrectAnswer, 'Hapana'];
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  List<Map<String, dynamic>> savedSymptoms = [];

  Future<void> saveQuizResults(corrects,  List<Map<String, dynamic>> savedSymptoms) async {
    try {
      // Get a reference to the 'results' subcollection in the 'Diagnosis' collection
      final CollectionReference<Map<String, dynamic>> diagnosisResults =
      FirebaseFirestore.instance.collection('Diagnosis').doc(user.email).collection('results');

      // Calculate the quiz score based on the symptom data
      int score = 0;
      double avg = 0;
      for (var symptom in savedSymptoms) {
          score += symptom['score'] as int;
          avg = (score/ corrects) * 100;
          String getValue =avg.toStringAsFixed(2);
          avg=double.parse(getValue);


      }

      // Add a new document with the quiz results
      await diagnosisResults.add({
        'name': user.displayName,
        'email': user.email,
        'disease': widget.id,
        'point': score,
        'score': '$score / $corrects',
        'percent': avg,
        'date': DateTime.now(),
        'savedSymptoms': savedSymptoms,
      });
    } catch (e) {
      print('Error saving quiz results: $e');
    }
  }

  void verifyAndNext(BuildContext context, String name, String email) {
    String textSelectAnswer = currentAnswers[selectedAnswer];
    if (textSelectAnswer == currentCorrectAnswer) {
      setState(() {
        final Map<String, dynamic> currentSymptom = questions[currentQuestion];
        final String symptomQn = currentSymptom['qn'] as String;
        final int symptomRating = currentSymptom['rating'] as int;
        if (textSelectAnswer == 'Ndio') {

          savedSymptoms.add({
            'qn': symptomQn,
            'rating': symptomRating,
            'response': 'Yes',
            'score': symptomRating,
          });
          corrects += symptomRating;
        }

      });
    }
    else {
      setState(() {
        final Map<String, dynamic> currentSymptom = questions[currentQuestion];
        final String symptomQn = currentSymptom['qn'] as String;
        final int symptomRating = currentSymptom['rating'] as int;
        if (textSelectAnswer == 'Hapana') {

          savedSymptoms.add({
            'qn': symptomQn,
            'rating': symptomRating,
            'response': 'No',

            'score': 0,
          });
          corrects += symptomRating;
        }

      });
    }
    if (currentQuestion + 1 == questions.length) {
      saveQuizResults(corrects,savedSymptoms);
    }
    nextQuestion(context);
  }


  void nextQuestion(BuildContext context) {
    int actualQuestion = currentQuestion;
    if (actualQuestion + 1 < questions.length) {
      Map<String, dynamic> nextQuestion = questions[actualQuestion + 1];
      List<String> answers = [  'Ndio','Hapana'
      ];
      setState(() {
        currentQuestion++;
        currentTitle = nextQuestion['qn'];
        currentCorrectAnswer = 'Ndio';
        currentAnswers = answers..shuffle();
        selectedAnswer = null;
      });
    } else {
      // Navigator.pushReplacementNamed(context, 'result', arguments: {
      //   'corrects': corrects,
      //   'start_at': now,
      //   'list_length': questions.length,
      // });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  const QuizResultsScreen(),
        ),
      );

    }
  }



  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
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
                  'Jipime App',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      color: Colors.deepPurple),
                ),
                Text('Jibu maswali haya kwa usahihi',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.deepPurple))
              ],
            ),
          ],
        ),

      ),

      body: SafeArea(
        child: (questions != null)
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  const Dashboard(),
                                ),
                              );                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.deepPurple,
                              size: 32.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Swali ${currentQuestion + 1}',
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                        Text(
                          '/${questions.length}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(25.0),
                      margin: const EdgeInsets.symmetric(vertical: 30.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        HtmlUnescape().convert(this.currentTitle),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22.0,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentAnswers.length + 1,
                        itemBuilder: (context, index) {
                          if (index == currentAnswers.length) {
                            return GestureDetector(
                              onTap: () {
                                if (selectedAnswer != null) {
                                  verifyAndNext(context,'frank','fr@sysaysa');
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 30.0,
                                ),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: (selectedAnswer == null)
                                      ? Colors.grey
                                      : Colors.deepPurple[900],
                                  borderRadius: BorderRadius.circular(180.0),
                                ),
                                child: const Text(
                                  'Endelea',
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          }
                          String answer = currentAnswers[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAnswer = index;
                              });
                            },
                            child: QuizOption(
                              index: index,
                              selectedAnswer: selectedAnswer,
                              answer: answer,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.deepPurple[900],
                  ),
                ),
              ),
      ),
    );
  }
}
