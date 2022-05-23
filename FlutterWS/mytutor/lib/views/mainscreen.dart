import 'package:flutter/material.dart';
import '../models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user,}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MyTutor'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.user.name.toString()), 
                accountEmail: Text (widget.user.email.toString()),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profilepic.jpeg")
                ),
                ),
             _createDrawerItem(
              icon: Icons.person,
              text: 'Profile',
              onTap: () {},
            ),
             _createDrawerItem(
              icon: Icons.abc,
              text: 'Subject',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.people_alt,
              text: 'Teacher',
              onTap: () {},
            ),
             _createDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {},
            ),
            ]
            ),
        ),
        body: const Center(
          child: Text('Welcome to MyTutor'),
        ),
      );
  }
   // ignore: unused_element
   Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}