import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/services/analytics.dart';

import 'package:fl_chart/fl_chart.dart';

import '../classes/restaurant.dart';
import '../graphs/barGraphDoubleLines.dart';
import '../graphs/piChart.dart';

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
            title: const Text(
              'Dhaba',
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'Britanic',
              ),
            ),
            backgroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
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
              ImpressionRow(impressions: impressions),
              const TimeSlotSalesRow(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OrdersPlacedRow(ordersPlaced: ordersPlaced),
                  ReviewsRow(),
                ],
              ),
              RevenueRow(revenue: revenue),
              const Row(
                children: [
                  PopularRow(),
                  piChartRow(),
                ],
              ),
              SizedBox(height: 80),
            ],
          ),
        )));
  }
}

class piChartRow extends StatelessWidget {
  const piChartRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            print('widget a pressed');
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'sales by categories %',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: PieChartSample(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PopularRow extends StatelessWidget {
  const PopularRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(left: 5, top: 10, right: 5),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            print('widget a pressed');
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(3),
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, bottom: 20, top: 10),
                  child: Text('Popular',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                for (int i = 0; i < 3; i++)
                  Container(
                    height: 245 / 3,
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          decoration: BoxDecoration(color: Colors.white30),
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
    );
  }
}

class RevenueRow extends StatelessWidget {
  const RevenueRow({
    super.key,
    required this.revenue,
  });

  final int revenue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          print('widget a pressed');
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                textDirection: TextDirection.rtl,
                children: [
                  const Text(
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Expanded(
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
    );
  }
}

class ReviewsRow extends StatelessWidget {
  const ReviewsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            print('widget a pressed');

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.grey.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 1, bottom: 1),
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '21%',
                                    style: TextStyle(color: Colors.pink),
                                  ),
                                  SizedBox(width: 3),
                                  Icon(
                                    Icons.arrow_upward_rounded,
                                    size: 20,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
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
                      child: const Text(
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
                const Expanded(
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
    );
  }
}

class OrdersPlacedRow extends StatelessWidget {
  const OrdersPlacedRow({
    super.key,
    required this.ordersPlaced,
  });

  final int ordersPlaced;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            print('widget a pressed');
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textDirection: TextDirection.rtl,
                  children: [
                    const Text(
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(
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
    );
  }
}

class TimeSlotSalesRow extends StatelessWidget {
  const TimeSlotSalesRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
      height: 300,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        child: BarChartSample2(),
      ),
    );
  }
}

class ImpressionRow extends StatelessWidget {
  const ImpressionRow({
    super.key,
    required this.impressions,
  });

  final int impressions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              textDirection: TextDirection.rtl,
              children: [
                const Text(
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
    );
  }
}
