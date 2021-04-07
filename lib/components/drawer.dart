import 'package:flutter/material.dart';

import '../constants/colors.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({this.iconData, this.title, this.page});

  final IconData iconData;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Icon(
          iconData,
          size: 32,
          color:  primaryColor,
        ),
      ),
      Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color:  primaryColor,
        ),
      )
    ],
        ),
      );
  }
}
