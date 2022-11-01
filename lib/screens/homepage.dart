//create a home page

// Path: lib/homepage.dart

import 'package:clubs/screens/clubs/index.dart';
import 'package:clubs/screens/newsfeed/index.dart';
import 'package:clubs/screens/profile/index.dart';
import 'package:clubs/screens/suggestions/index.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final int index;
  const Home(this.index, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState(index);
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const NewsFeed(),
    const Recommendation(),
    const Clubs(),
    const Profile()
  ];
  _HomeState(this._selectedIndex);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child:
        Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _widgetOptions,
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 5,
            backgroundColor: Colors.white,
            iconSize: 30,
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedIconTheme: const IconThemeData(color: Colors.pinkAccent, size: 33,shadows: [BoxShadow(color: Colors.redAccent, blurRadius: 2)]),
            enableFeedback: true,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper_rounded),
                label: 'News',
                tooltip: 'News',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'suggestions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'School',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (e)=> setState(() {
              _selectedIndex = e;
            }),
          ),
        ),
    );
  }
}