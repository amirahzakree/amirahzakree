import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SlumShop'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text("Amirah Zakre"), 
                accountEmail: Text ("amirahzakree@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profile.jpg")
                ),
                ),
             _createDrawerItem(
              icon: Icons.abc,
              text: 'Products',
              onTap: () {},
            ),
             _createDrawerItem(
              icon: Icons.shopping_bag,
              text: 'Products',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.shopping_cart,
              text: 'Cart',
              onTap: () {},
            ),
            ]
            ),
        ),
        body: const Center(
          child: Text('Welcome to SlumShop'),
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