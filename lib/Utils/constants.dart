import 'package:flutter/material.dart';

import '../child/child_sign_up_screen.dart';

Color primaryColor = Color(0xfffc3b77);

void goTo(BuildContext context, Widget nextScreen) {
  Navigator.push(
      context, MaterialPageRoute(builder: ((context) => nextScreen)));
}

Widget progressIndicator(BuildContext context) {
  return Center(
      child: CircularProgressIndicator(
    backgroundColor: primaryColor,
    strokeWidth: 7,
    color: Colors.red,
  ));
}

dialogueBox(BuildContext context, String text) {
  showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: Text(text),
          )));
}
