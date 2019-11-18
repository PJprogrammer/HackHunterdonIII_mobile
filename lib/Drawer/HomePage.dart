import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:hack_hunterdon/Drawer/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:audioplayers/audio_cache.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.user}) : super(key: key);
  GoogleSignInAccount user;

  @override
  MyHomePageState createState() => MyHomePageState(user);
}

class MyHomePageState extends State<MyHomePage> {
  static const stream = const EventChannel('com.example.safehalo/stream');
  StreamSubscription _mlModelSubscription;
  double _score = 0;
  String _coordinate = "";
  Completer<GoogleMapController> _controller;
  static Timer apiCallTimer;

  var childButtons;
  //static bool isAlarmActivated = false;

  Set<Marker> _markers;
  int count = 0;
  LocationData _currentLocation;
  GoogleSignInAccount _account;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static AudioCache player = new AudioCache();
  static const alarmAudioPath = "redalert.mp3";

  MyHomePageState(GoogleSignInAccount account) {
    if (account == null) {
      print("USER ACCOUNT null!!!");
    } else {
      _account = account;
      print(account);
      //Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Color color = Color.fromRGBO(255, 127, 0, 0);
  @override
  void initState() {
    super.initState();
    count = 0;
    _getPhoneLocation();
    if (_mlModelSubscription == null) {
      _mlModelSubscription =
          stream.receiveBroadcastStream().listen(_updateScore);
    }

    apiCallTimer = new Timer.periodic(Duration(seconds: 5), _updateMap);

    _markers = new Set();
    _controller = Completer();

    //Alert User to threat
    setUpFabMenu();
    //
  }

  @override
  void dispose() {
    super.dispose();
    if (_mlModelSubscription != null) {
      _mlModelSubscription.cancel();
      _mlModelSubscription = null;
    }
    apiCallTimer.cancel();
  }

  void setUpFabMenu() {
    childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Email",
        currentButton: FloatingActionButton(
          heroTag: "Email",
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Icon(Icons.email),
          onPressed: () => sendEmail(),
        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
          heroTag: "SMS",
          backgroundColor: Colors.greenAccent,
          mini: true,
          child: Icon(Icons.textsms),
          onPressed: () => launch('sms:+1 908 210 2465?body=hello'),
        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
          heroTag: "Phone",
          backgroundColor: Colors.blueAccent,
          mini: true,
          child: Icon(Icons.phone),
          onPressed: () => launch("tel://19082102465"),
        )));
  }

  void sendEmail() async {
    String toMailId = "paulsarah2002@gmail.com";
    String subject = "Important: Gunshot Detected Nearby";
    String body = "We have been alerted to gunshots in your surrounding area";
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _updateScore(score) {
    debugPrint("Score: $score");
    _getPhoneLocation();
    _postLocation(score);
    setState(() {
      _score = score;
      _coordinate = _currentLocation.latitude.toString() +
          ", " +
          _currentLocation.longitude.toString();
      color = Color.fromRGBO(255, 127, 0, 1);
    });
    new Timer(Duration(seconds: 5), () {
      setState(() {
        color = Color.fromRGBO(255, 127, 0, 0);
        _score = 0.0;
      });
    });
  }

  void _updateMap(Timer t) async {
    try {
      Response response = await Dio()
          .get("https://Async.pauljprogrammer.repl.co/getLocations");
      List list = json.decode(response.data) as List;
      print("OK Out" + count.toString() + "Hello" + list.length.toString());
      if (list.length != count) {
        player.play(alarmAudioPath);
        count = list.length;
        print("OK In");
        this.setState(() {
          for (var i = 0; i < list.length; i++) {
            _markers.add(Marker(
              markerId: MarkerId(i.toString()),
              icon: BitmapDescriptor.fromAsset("assets/10orange.png"),
              position:
              LatLng(list[i]['lat'] as double, list[i]['lng'] as double),
            ));

            print(_markers);
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _postLocation(score) async {
    try {
      Response response = await Dio().post(
          "https://Async.pauljprogrammer.repl.co/addLocation",
          data: {
            "lat": _currentLocation.latitude,
            "lng": _currentLocation.longitude
          });
    } catch (e) {
      print(e);
    }
  }

  void _getPhoneLocation() async {
    Location location = new Location();
    _currentLocation = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("HomePage"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.email),
            onPressed: () {
              if (_account != null) {
                final snackBar = SnackBar(
                  content: Text('Logged in as: ' + _account.displayName),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    label: "signout",
                    onPressed: () {},
                  ),
                );

                _scaffoldKey.currentState.showSnackBar(snackBar);
              } else {
                final snackBar = SnackBar(
                  content: Text('Logged in as: Guest'),
                  duration: Duration(seconds: 3),
                );

                _scaffoldKey.currentState.showSnackBar(snackBar);
              }
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 500.0,
            width: double.maxFinite,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                print("hello created maps");
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(40.5201221, -74.849523), zoom: 17.5),
              markers: _markers,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            color: color,
            child: ListTile(
              title: Text('$_score'),
              subtitle: Text(_coordinate),
              onTap: () {},
            ),
          )
        ],
      ),
      drawer: SideDrawer(),
      floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Colors.redAccent,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: childButtons),
    );
  }
}
