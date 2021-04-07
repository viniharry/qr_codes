import 'package:flutter/material.dart';
import 'package:qr_code_app/components/drawer.dart';
import 'package:qr_code_app/components/menu_drawer_header.dart';




class MenuDrawer extends StatefulWidget {
  MenuDrawer({Key key}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.white,
                //Color(0xFFb9ecef),
                Colors.white,
              ])),
        ),
        Column(
          children: <Widget>[
         CustomDrawerHeader(),
         Divider(),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/clientes_page');
              },
              child: DrawerTile(
                iconData: Icons.star,
                title: 'Clientes',
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.popAndPushNamed(context, '/');
              },
              child: DrawerTile(
                iconData: Icons.qr_code_scanner,
                title: 'Scanear',
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
