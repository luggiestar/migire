import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:quiz_ame/screens/signup.dart';
import 'package:quiz_ame/widgets/custombutton.dart';
import 'package:quiz_ame/widgets/customtextinput.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
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
  String email;
  String password;
  bool loggingin = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loggingin,
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        body:
        SingleChildScrollView(
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
                      style:
                      TextStyle(
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),

                  CustomTextInput(
                    hintText: 'Email',
                    leading: Icons.mail,
                    obscure: false,
                    keyboard: TextInputType.emailAddress,
                    userTyped: (val) {
                      email = val;
                    },
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  CustomTextInput(
                    hintText: 'NenoSiri',
                    leading: Icons.lock,
                    obscure: true,
                    userTyped: (val) {
                      password = val;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Hero(
                    tag: 'loginbutton',
                    child:
                    CustomButton(
                      text: 'Ingia',
                      accentColor: Colors.white,
                      mainColor: Colors.deepPurple,
                      onpress: () async {
                        if (password != null && email != null) {
                          setState(() {
                            loggingin = true;
                          });
                          try {
                            final loggedUser =
                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);
                            if (loggedUser != null) {
                              setState(() {
                                loggingin = false;
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
                                loggingin = false;
                              });

                            EdgeAlert.show(context,
                                title: 'Imeshindikana',
                                description: 'Tafadhali Jaribu tena',
                                gravity: EdgeAlert.BOTTOM,
                                icon: Icons.error,
                                backgroundColor: Colors.deepPurple[900]);
                          }
                        } else {
                          EdgeAlert.show(context,
                              title: 'Imeshindikana',
                              description:
                                  'Tafadhali Jaza Taarifa zote.',
                              gravity: EdgeAlert.BOTTOM,
                              icon: Icons.error,
                              backgroundColor: Colors.deepPurple[900]);
                        }
                        // Navigator.pushReplacementNamed(context, '/chat');
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  const SignUpPage(),
                          ),
                        );

                      },

                      child: const Text(
                        'au Jisajili',
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

                  const Hero(
                    tag: 'footer',
                    child: Text(
                      'Migire ICTM 3 @2023',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
