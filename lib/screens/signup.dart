import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_ame/widgets/custombutton.dart';
import 'package:quiz_ame/widgets/customtextinput.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'dashboard.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  AnimationController mainController;
  Animation mainAnimation;
  @override
  void initState() {
    super.initState();
    mainController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    mainAnimation =
        ColorTween(begin: Colors.deepPurple[900], end: Colors.grey[100])
            .animate(mainController);
    mainController.forward();
    mainController.addListener(() {
      setState(() {});
    });
  }

  final _auth = FirebaseAuth.instance;
  String email;
  // String username;
  String password;
  String name;
  bool signingup = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: signingup,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            // margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'heroicon',
                    child: Icon(
                      Icons.biotech_rounded,
                      size: mainController.value * 100,
                      color: Colors.deepPurple[900],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Hero(
                    tag: 'HeroTitle',
                    child: Text(
                      'Jipime App',
                      style: TextStyle(
                          color: Colors.deepPurple[900],
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  TyperAnimatedTextKit(
                    isRepeatingAnimation: true,
                    speed:Duration(milliseconds: 180),
                    text:["Jua hali ya Afya yako kiurahisi".toUpperCase()],
                    textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.deepPurple),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.deepPurple[900],size: 40,),
                        SizedBox(width: 8.0),
                         const Flexible(
                           child: Text(
                            'Ili kulinda Usiri wa mteja, Tafadhari epuka kutumia email na majina  Halisi.Waweza buni email na jina Lolote',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Poppins',
                              color: Colors.deepPurple,
                            ),
                        ),
                         ),
                      ],
                    ),
                  ),

                  CustomTextInput(
                    hintText: 'Jina la Utumizi',
                    leading: Icons.text_format,
                    obscure: false,
                    userTyped: (value) {
                      name = value;
                    },
                  ),
                  SizedBox(
                    height: 0,
                  ),

                  CustomTextInput(
                    hintText: 'Ingiza Email',
                    leading: Icons.mail,
                    keyboard: TextInputType.emailAddress,
                    obscure: false,
                    userTyped: (value) {
                      email = value;
                    },
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  CustomTextInput(
                    hintText: 'NenoSiri',
                    leading: Icons.lock,
                    keyboard: TextInputType.visiblePassword,
                    obscure: true,
                    userTyped: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Hero(
                    tag: 'signupbutton',
                    child:
                    CustomButton(
                      onpress: () async {
                        if (name != null && password != null && email != null) {
                          setState(() {
                            signingup = true;
                          });
                          try {
                            final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: email, password: password);
                            if (newUser != null) {
                              User user = newUser.user;
                              await user.updateDisplayName(name);
                              // Add user to the 'users' collection in Firestore
                              await FirebaseFirestore.instance.collection('users').doc(email).set({
                                'desc': '',
                                'email': email,
                                'is_staff': false,
                                'name': name,
                              });

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Dashboard(),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() {
                              signingup = false;
                            });
                            EdgeAlert.show(context,
                                title: 'Usajili Haujafanikiwa',
                                description: 'Jaribu tena',
                                gravity: EdgeAlert.BOTTOM,
                                icon: Icons.error,
                                backgroundColor: Colors.deepPurple[900]);
                          }
                        } else {
                          EdgeAlert.show(context,
                              // title: 'Signup Failed',
                              title: 'Usajili Haujafanikiwa',
                              description: 'Jaza Taarifa zote.',
                              gravity: EdgeAlert.BOTTOM,
                              icon: Icons.error,
                              backgroundColor: Colors.deepPurple[900]);
                        }
                      },
                      // text: 'sign up',
                      text: 'Jisajili',
                      accentColor: Colors.white,
                      mainColor: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Nina Akaunti Tayari',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.deepPurple),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Column(
                            children: [
                              Text('Zingatia Haya Pindi utumiapo Aplikesheni Hii', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
                            ],
                          ),
                          content:
                          Container(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Card(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('1 . Utafiti wa Uchunguzi', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF100E34))),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Tunasaidia kuelewa jinsi tunaweza kufikia watu wengi Zaidi ambao wanaweza kufaidika na pima tunayoa unyanyapaaji na kufanya kila mtu ajue afya ake ki urahisi'),
                                              const SizedBox(height: 10),
                                              Text('Tunasaidia kuondoa woga na kuchekwa na jamii. Mfumo uu unaweza kutumiwa mda wowote na mtumiaji na kumfikia popote'),
                                              const SizedBox(height: 4),
                                              Container(
                                                height: 2,
                                                color: Color(0xFF811B83),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('2 . Kumbuka', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF100E34))),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Chukua dakika chache kukamilisha tathmini zako za kuchunguza.'),
                                              const SizedBox(height: 10),
                                              Text('Kumbuka uu sio utambuzi sahihi wa ugonjwa ulio pima kwaiyo tunakushauri kuwasiliana na daktari kwa ajili ya uchunguzi Zaidi'),
                                              const SizedBox(height: 10),
                                              Text('Mfumo huu unahusika na dalili za magonjwa ya zinaa tunakushauri usome dalili kwa usahihi kabla ya kujibu swali na kupata majibu'),
                                              const SizedBox(height: 4),
                                              Container(
                                                height: 2,
                                                color: Color(0xFF811B83),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('3 . Linda Faragha Yako', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF100E34))),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Mfumo huu unahusisha madaktari wa kuaminika na waliothibitishwa\nTafadhali Linda faragha yako na pasipo na ulazima usitoe taarifa zinazokuhusu'),
                                              const SizedBox(height: 4),
                                              Container(
                                                height: 2,
                                                color: Color(0xFF811B83),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),



                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text('ok',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 14,
                                ),),
                            ),

                          ],
                        ),
                      );



                    },
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label:  Text('Zingatia Haya'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF100E34)
                    ),
                  ),
                  Hero(
                      tag: 'footer',
                      child: Text(
                        'Migire ICT-M 3 @2023',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
