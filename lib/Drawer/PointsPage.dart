import 'package:flutter/material.dart';
import 'package:hack_hunterdon/Drawer/drawer.dart';
import 'package:hack_hunterdon/Drawer/HomePage.dart';
import 'package:app_usage/app_usage.dart';

class PointsPage extends StatefulWidget {
  @override
  _PointsPageState createState() => new _PointsPageState();
}

class _PointsPageState extends State<PointsPage>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  int _usageTime;

  @override
  initState() {
    super.initState();
    getUsageStats();
    if (MyHomePageState.apiCallTimer != null) {
      MyHomePageState.apiCallTimer.cancel();
    }

    print("hello2");


  }

  void getUsageStats() async {
    try {
      AppUsage appUsage = new AppUsage();
      DateTime endDate = new DateTime.now();
      DateTime startDate = new DateTime(endDate.year,endDate.month,endDate.day,endDate.hour,endDate.minute,);
      Map<String, double> usage = await appUsage.fetchUsage(startDate, endDate);
      print(startDate);
      print(usage["com.coderboy19.hack_hunterdon"]/60);
      print(endDate);


      setState(() {
        _usageTime = ((usage["com.coderboy19.hack_hunterdon"]/60).ceil());

      });
      animationController =
          AnimationController(duration: Duration(seconds: 3), vsync: this);
      animation = IntTween(begin: 0, end: _usageTime).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeOut));
      animationController.forward();

    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Points"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                  child: Image.asset('assets/stars.png'),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(right: 15.0, top: 45.0),
                      child: AnimatedBuilder(
                          animation: animationController,
                          builder: (BuildContext context, Widget child) {
                            return Text(
                              animation.value.toString(),
                              style: TextStyle(
                                  fontSize: 75,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            );
                          })))
            ],
          ),
          SizedBox(
            height: 200,
            child: Text(_usageTime.toString() + " minute(s)", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black
            )),
          )
        ],
      ),
      drawer: SideDrawer(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
