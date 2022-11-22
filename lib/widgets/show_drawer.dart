import 'package:flutter/material.dart';
import 'package:flutter_simple_cms/screens/create_post_screen.dart';
import 'package:flutter_simple_cms/screens/home_screen.dart';

Widget showDrawer(BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
    color: Colors.white,
    width: MediaQuery.of(context).size.width / 1.5,
    height: MediaQuery.of(context).size.height,
    child: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            drawerItemNavigate(context, Icons.create, "Create Post", () {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const CreatePost()));
            }),
            drawerItemNavigate(context, Icons.view_list, "Home", () {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            }),
          ],
        ),
      ),
    ),
  );
}

Widget drawerItemNavigate(BuildContext context, IconData icon, String label,
    VoidCallback? onButtonPressed) {
  return ElevatedButton(
    onPressed: onButtonPressed,
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Icon(icon),
        ),
        Expanded(
          flex: 3,
          child: Text(label,
              style: const TextStyle(
                fontSize: 16.0,
              )),
        ),
      ],
    ),
  );
}
