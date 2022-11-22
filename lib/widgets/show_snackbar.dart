import 'package:flutter/material.dart';

void showSnackbar(
  BuildContext context,
  String? message,
  Color? messageColor,
  IconData? icon,
  Color? iconColor,
) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            message!,
            style: TextStyle(
              color: messageColor!,
            ),
          ),
        ],
      ),
    ));
}
