


import 'package:flutter/material.dart';

class AppBarConstant extends StatelessWidget {
  const AppBarConstant({Key key, this.title}) : super(key: key);


  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
       actions: [
          IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              onPressed: () => Navigator.of(context).pop())
        ],
    );
  }
}