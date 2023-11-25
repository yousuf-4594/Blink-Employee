import 'package:flutter/material.dart';

import '../graphs/orderPlacedLineChart.dart';
import '../graphs/revenueLineChart.dart';

class OrderAnalytics extends StatefulWidget {
  @override
  _ScreenBState createState() => _ScreenBState();
}

class _ScreenBState extends State<OrderAnalytics> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey.shade900,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Order Analytics',
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
                  child: LineChartSample1(),
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
                  child: LineChartSample1(),
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
                  child: LineChartSample1(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
