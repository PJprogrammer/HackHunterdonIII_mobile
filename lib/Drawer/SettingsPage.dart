import 'package:flutter/material.dart';
import 'package:hack_hunterdon/Drawer/drawer.dart';
import 'package:card_settings/card_settings.dart';
import 'package:hack_hunterdon/Drawer/HomePage.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = "Paul John";



  @override
  void initState() {
    if(MyHomePageState.apiCallTimer != null) {
      MyHomePageState.apiCallTimer.cancel();
    }
  }

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
        drawer: SideDrawer(),
        appBar: new AppBar(
          title: new Text("Title"),
        ),
        body: Form(
          key: _formKey,
          child: CardSettings(
            children: <Widget>[
              CardSettingsHeader(label: 'Bio'),
              CardSettingsText(
                label: 'Name',
                initialValue: name,
                onSaved: (value) => name = value,
              ),
              CardSettingsNumberPicker(
                  label: 'Age',
                  initialValue: 18,
                  min: 1,
                  max: 100
              ),
              CardSettingsListPicker(
                label: 'Gender',
                initialValue: 'Male',
                options: ['Male','Female'],
              ),
              CardSettingsHeader(
                label: 'Emergency Contact Info',
              ),
              CardSettingsInstructions(
                text: '*Contact Info 1',
              ),
              CardSettingsText(
                label: 'Relationship',
                initialValue: 'Mother',
              ),
              CardSettingsPhone(
                label: 'Phone',
                initialValue: 9083914700,
              ),
              CardSettingsEmail(
                label: 'Email',
                initialValue: 'pauljprogrammer@gmail.com',
              ),
              CardSettingsInstructions(
                text: '*Contact Info 2',
              ),
              CardSettingsText(
                label: 'Relationship',
                initialValue: 'Father',
              ),
              CardSettingsPhone(
                label: 'Phone',
                initialValue: 9085316124,
              ),
              CardSettingsEmail(
                label: 'Email',
                initialValue: 'pauljohn@bernardsboe.com',
              ),
              CardSettingsHeader(
                label: 'Actions',
              ),
              CardSettingsButton(
                label: 'Save',
                onPressed: () {},
              ),
              CardSettingsButton(
                label: 'Reset',
                onPressed: () {},
              )

            ],
          ),
        )
    );
  }
}