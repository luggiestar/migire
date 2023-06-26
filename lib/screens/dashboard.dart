import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_ame/screens/history.dart';
import 'MessagePage.dart';
import 'homepage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  int index = 0;
  bool isWhichScreen = false;
  User currentUser = FirebaseAuth.instance.currentUser;

  final screens = [
    const HomePage(),
    const DiagnosisHistory(),
    PrivateChat(),
  ];


  @override
  void initState() {
    super.initState();
    index = 0;
    isWhichScreen = false;
    user = _auth.currentUser;

  }


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
              children: <Widget>[
                const Text(
                  'Jipime App',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      color: Colors.deepPurple),
                ),
                Text('Karibu, ${user.displayName}',
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.deepPurple))
              ],
            ),
          ],
        ),

      ),
      drawer:
      Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple[900],
              ),
              accountName: Text(user.displayName),
              accountEmail: Text(user.email),
              currentAccountPicture: CircleAvatar(
                child: const Icon(Icons.person_pin, size: 74, color: Colors.white70,),
                backgroundColor: Colors.deepPurple[900],
              ),
              onDetailsPressed: () {},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Ondoka"),
              subtitle: Text("Ondoka kwenye Aplikesheni"),
              onTap: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body:screens[index],



      bottomNavigationBar: _buildBottomTab(),

    );
  }
  _buildBottomTab() {
    return NavigationBarTheme(
        data:  const NavigationBarThemeData(
            backgroundColor: Colors.white10,
            indicatorColor: Colors.deepPurple,
            height: 60
        ),
        child:NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index){
            setState(() {
              this.index = index;
            });
          },
          destinations:   [
            NavigationDestination(
                icon: Icon(FontAwesomeIcons.homeUser,size: 18,color: Colors.deepPurple[900],),
                label: 'Nyumbani',
            ),
            NavigationDestination(
                icon: Icon(FontAwesomeIcons.recycle,size: 18,color: Colors.deepPurple[900],),
                label: 'Chunguzi'
            ),
            NavigationDestination(
                icon: Icon(FontAwesomeIcons.comments,size: 18,color:  Colors.deepPurple[900],),
                label: 'Ushauri'
            ),

            // NavigationDestination(
            //     icon: Icon(FontAwesomeIcons.circleQuestion,size: 18,color: CustomColors.firebaseAmber,),
            //     label: TranslationService.of(context).translate('Q&A')
            // ),
          ],
        )
    );

  }
}

