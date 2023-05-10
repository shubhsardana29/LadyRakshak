import 'package:flutter/material.dart';
import 'package:lady_rakshak/Utils/quotes.dart';

class CustomAppbar extends StatelessWidget {
  // const CustomAppbar({Key? key}) : super(key: key);

  Function? onTap;
  int? quoteIndex;
  CustomAppbar({this.onTap, this.quoteIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap!();
      },
      child: Container(
        child: Text(
          sweetSayings[quoteIndex!],
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
