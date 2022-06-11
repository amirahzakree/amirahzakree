import 'package:flutter/material.dart';
import 'package:mytutor2/models/user.dart';
import 'package:mytutor2/views/subjectscreen.dart';
import 'package:mytutor2/views/tutorscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required User user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  static const TextStyle optionStyle = 
        TextStyle(fontSize: 23, fontWeight: FontWeight.bold);
  
  static const List<Widget> _widgetOptions = <Widget>[
    CourseScreen(),
    TutorScreen(),
    Text (
      'Subscriptions',
      style: optionStyle,
    ),
    Text (
      'Favourite',
      style: optionStyle,
    ),
    Text (
      'My Profile',
      style: optionStyle,
    )
  ];     


void onTap (int index){
  setState(() {
    currentIndex = index;
  });
}
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
        title: const Text('MYTUTOR'),
        backgroundColor: Colors.blueGrey[900],
        ),
        body: Center (
          child: _widgetOptions.elementAt(currentIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blueGrey[900],
          currentIndex: currentIndex,
          selectedItemColor: Colors.black54.withOpacity(0.7),
          unselectedItemColor: Colors.grey.withOpacity(0.9),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 15,
          unselectedFontSize: 15,
          elevation: 10,
          items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_sharp),
          label: 'Subjects',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Tutors',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.subscriptions),
          label: 'Subscribe',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Favourite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
    ],
              onTap: onTap,
    selectedLabelStyle: const TextStyle(
      overflow: TextOverflow.visible
    ),

  ),
);
  }
}