import 'package:flutter/material.dart';

Future<void> showAppDialog(
    {required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
    required String defaultActionText,
    final VoidCallback? onButtonPressed}) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(
        icon,
        size: 75.0,
      ),
      title: Text(title),
      content: SizedBox(
        height: 300.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            content,
            style: const TextStyle(fontSize: 14.0),
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: () => onButtonPressed!(),
          child: SizedBox(
            width: 75.0,
            height: 30.0,
            child: Center(
              child: Text(
                defaultActionText,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
