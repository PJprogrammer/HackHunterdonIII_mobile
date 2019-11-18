import 'package:flutter/material.dart';
import 'package:hack_hunterdon/Drawer/PointsPage.dart';
import 'package:hack_hunterdon/Drawer/SettingsPage.dart';
import 'package:hack_hunterdon/Drawer/HomePage.dart';
class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('HomePage'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          ),
          ListTile(
            title: Text('Points'),
            leading: Icon(Icons.star),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => PointsPage()));
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}