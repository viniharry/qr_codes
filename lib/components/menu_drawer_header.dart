import 'package:flutter/material.dart';
import 'package:qr_code_app/constants/colors.dart';
import 'package:qr_code_app/constants/size_config.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 24, 16, 8),
      height: displayHeight(context) * 0.25,
      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
           Container(
             width: displayWidth(context),
             child: Image.asset('assets/Logo.png')),
         
        ],
      ),
    );
  }
}
