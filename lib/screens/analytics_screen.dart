import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/services/analytics.dart';

import 'package:fl_chart/fl_chart.dart';

import '../classes/restaurant.dart';
import '../graphs/barGraphDoubleLines.dart';

class AnalyticsScreen extends StatefulWidget {
  static const String id = 'analytics_screen';
  Restaurant restaurant;
  AnalyticsScreen({super.key, required this.restaurant});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

// A good fl_chart graph library explanation
// https://www.youtube.com/watch?v=MFvq0MdeKcI

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int ordersPlaced = 0;
  int impressions = 0;
  int revenue = 0;

  void getAnalytics(int restaurantID) async {
    int orders = await Analytics.getOrdersPlaced(restaurantID);
    int views = await Analytics.getImpressions(restaurantID);
    int amount = await Analytics.getRevenue(restaurantID);

    setState(() {
      ordersPlaced = orders;
      impressions = views;
      revenue = amount;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAnalytics(widget.restaurant.restaurantID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Dhaba',
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'Britanic',
              ),
            ),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0),
              ),
            ),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  print('widget a pressed');
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            'Impressions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              '$impressions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.remove_red_eye,
                        size: 40,
                        color: Colors.white38,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  print('widget a pressed');
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: BarChartSample2(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        print('widget a pressed');
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 15),
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textDirection: TextDirection.rtl,
                              children: [
                                Text(
                                  'Orders placed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    '$ordersPlaced',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 45,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.playlist_add_check_sharp,
                                  size: 40,
                                  color: Colors.white38,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        print('widget a pressed');
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 15),
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textDirection: TextDirection.rtl,
                              children: [
                                Text(
                                  'Reviews',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    '5.6k',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 45,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.star_outline_rounded,
                                  size: 40,
                                  color: Colors.white38,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  print('widget a pressed');
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            'Revenue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Rs $revenue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.auto_graph,
                            size: 40,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 5, top: 10, right: 5),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          print('widget a pressed');
                        },
                        child: Column(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, bottom: 20, top: 10),
                              child: Text('Popular',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            for (int i = 0; i < 3; i++)
                              Container(
                                height: 140 / 3,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 1,
                                      decoration:
                                          BoxDecoration(color: Colors.white30),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.ac_unit_rounded,
                                          color: Colors.white38,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'food $i',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        print('widget a pressed');
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 15),
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textDirection: TextDirection.rtl,
                              children: [
                                Text(
                                  'sales by categories %',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'pi chart',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 45,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )));
  }
}
