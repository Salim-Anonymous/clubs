import 'package:clubs/screens/clubs/add_club.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/homepage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Start());
}

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CAMS',
      home: SplashPage(duration: 3, goToPage: const Home(1)),
      initialRoute: '/',
      routes: {
        '/home': (context) => const Home(0),
        '/profile': (context) => const Home(3),
        '/clubs': (context) => const Home(2),
        '/suggestions': (context) => const Home(1),
        '/news': (context) => const Home(0),
        '/clubs/add': (context) => const AddClub(),
      },
    );
  }
}



class SplashPage extends StatelessWidget {

  final int duration;
  final Widget goToPage;

  SplashPage({Key? key, required this.duration, required this.goToPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration),(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => goToPage));
    });
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset("assets/logo/logo-no-background.png"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to CAMS",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
        )
    );
  }
}


