import 'package:flutter/material.dart';
import 'package:mytutor2/models/user.dart';
import 'package:mytutor2/views/mainscreen.dart';
import 'package:mytutor2/views/tutorscreen.dart';

class MenuScreen extends StatefulWidget {
  final User user;
  const MenuScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final List _options;
  int currentIndex = 0;

  static const TextStyle optionStyle = 
        TextStyle(fontSize: 23, fontWeight: FontWeight.bold);
  
  //static final List<Widget> _widgetOptions = <Widget>[
    @override
      void initState() {
      super.initState();
      _options = [
    MainScreen(user: widget.user),
    const TutorScreen(),
    const Text (
      'Subscriptions',
      style: optionStyle,
    ),
    const Text (
      'Favourite',
      style: optionStyle,
    ),
    const Text (
      'My Profile',
      style: optionStyle,
    )
      ];
  //];     
    }

void onTap (int index){
  setState(() {
    currentIndex = index;
  });
}
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Center (
          child: _options.elementAt(currentIndex),
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