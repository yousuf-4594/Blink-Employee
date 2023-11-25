import 'package:flutter/material.dart';

import '../graphs/revenueLineChart.dart';

class revenueScreen extends StatefulWidget {
  @override
  _ScreenBState createState() => _ScreenBState();
}

class _ScreenBState extends State<revenueScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Revenue',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: TabBar(
              indicatorColor: Colors.orangeAccent,
              tabs: [
                Tab(text: '7 Days'),
                Tab(text: '30 Days'),
                Tab(text: 'All Time'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Content for 7 Days
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Container(
                  // Replace this with your graph widget
                  width: 800,
                  padding: EdgeInsets.only(left: 50),
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.bottomCenter,
                  child: RevenueLineChart(),
                ),
              ),

              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Container(
                  // Replace this with your graph widget
                  width: 800,
                  padding: EdgeInsets.only(left: 50),
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.bottomCenter,
                  child: RevenueLineChart(),
                ),
              ),

              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Container(
                  // Replace this with your graph widget
                  width: 800,
                  padding: EdgeInsets.only(left: 50),
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.bottomCenter,
                  child: RevenueLineChart(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
