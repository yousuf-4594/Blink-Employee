import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/classes/PopularFood.dart';
import 'package:food_delivery_restraunt/mysql.dart';
import 'package:food_delivery_restraunt/screens/orderPlaceScreen.dart';
import 'package:food_delivery_restraunt/screens/revenueScreen.dart';
import 'package:food_delivery_restraunt/services/analytics.dart';
import 'package:food_delivery_restraunt/classes/UiColor.dart';
import 'package:flutter/services.dart';
import '../classes/globals.dart';
import '../classes/restaurant.dart';
import '../graphs/barGraphDoubleLines.dart';
import '../graphs/piChart.dart';

class AnalyticsScreen extends StatefulWidget {
  static const String id = 'analytics_screen';
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int ordersPlaced = 0;
  int impressions = 0;
  int revenue = 0;
  double ratingCount = 0;

  void getAnalytics() async {
    int orders =
        await Analytics.getOrdersPlaced(Global.restaurant.restaurantID);
    int views = await Analytics.getImpressions(Global.restaurant.restaurantID);
    int? amount = await Analytics.getRevenue(Global.restaurant.restaurantID);
    double reviews =
        await Analytics.getReviewCount(Global.restaurant.restaurantID);

    setState(() {
      ordersPlaced = orders;
      impressions = views;
      revenue = amount!;
      ratingCount = reviews;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getAnalytics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ui.val(0),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: ui.val(0),
              statusBarColor: Colors.black,
            ),
            automaticallyImplyLeading: false,
            title: Text(
              Global.restaurant.name,
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'Britanic',
              ),
            ),
            backgroundColor: Colors.black,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  print("Change vendor name right now");
                },
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0),
              ),
            ),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ImpressionRow(impressions: impressions),
              TimeSlotSalesRow(
                restaurantID: Global.restaurant.restaurantID,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OrdersPlacedRow(ordersPlaced: ordersPlaced),
                  ReviewsRow(ratingCount: ratingCount.toInt()),
                ],
              ),
              RevenueRow(revenue: revenue),
              Row(
                children: [
                  PopularRow(
                    restaurantID: Global.restaurant.restaurantID,
                  ),
                  // piChartRow(
                  //   restaurantID: Global.restaurant.restaurantID,
                  // ),
                ],
              ),
              SizedBox(height: 80),
            ],
          ),
        )));
  }
}

class piChartRow extends StatelessWidget {
  final String restaurantID;
  piChartRow({super.key, required this.restaurantID});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        height: 300,
        decoration: BoxDecoration(
          color: ui.val(1),
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
                Text(
                  'sales by categories %',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: PieChartSample(
                      restaurantID: restaurantID,
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

class PopularRow extends StatefulWidget {
  final String restaurantID;
  const PopularRow({super.key, required this.restaurantID});

  @override
  State<PopularRow> createState() => _PopularRowState();
}

class _PopularRowState extends State<PopularRow> {
  List<Container> foods = [];

  void getPopularFood() async {
    List<PopularFood> temp = [];
    List<Container> containers = [
      Container(
        margin: EdgeInsets.only(left: 10, bottom: 20, top: 10),
        child: Text('Popular',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      )
    ];
    var db = Mysql();
    temp = await db.getPopularFood(widget.restaurantID);
    for (int i = 0; i < temp.length; i++) {
      containers.add(Container(
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
                  '${temp[i].productName}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
    }
    setState(() {
      foods = containers;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPopularFood();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(left: 5, top: 10, right: 5),
        decoration: BoxDecoration(
          color: ui.val(1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            print('widget a pressed');
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(2),
            child: Column(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: foods),
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
        color: ui.val(1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          print('widget a pressed');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => (revenueScreen())),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
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
                      fontSize: 18,
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
  final int ratingCount;
  const ReviewsRow({super.key, required this.ratingCount});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        height: 100,
        decoration: BoxDecoration(
          color: ui.val(1),
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
                    padding: EdgeInsets.all(14.0),
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      left: 8, right: 8, top: 1, bottom: 1),
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
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.arrow_upward_rounded,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.moving,
                              size: 35,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '4.9',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 80,
                                    ),
                                  ),
                                  Text(
                                    'Average\nRating',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Column(
                                children: [
                                  for (int i = 5; i > 0; i--)
                                    Row(
                                      children: [
                                        Text(
                                          (i).toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Icon(Icons.star_rate_rounded,
                                            size: 17, color: Colors.white54),
                                        SizedBox(width: 5),
                                        Container(
                                          height: 4,
                                          width: 135,
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: LinearProgressIndicator(
                                            backgroundColor: Colors.grey,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.orangeAccent),
                                            value: 0.8,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '(534)',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            )
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
                      child: Text(
                        '$ratingCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
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
          color: ui.val(1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            print('widget a pressed');

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => (OrderAnalytics())),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.only(top: 4, bottom: 4, left: 15, right: 15),
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
                        fontSize: 18,
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
  final String restaurantID;
  const TimeSlotSalesRow({super.key, required this.restaurantID});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
      height: 300,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ui.val(1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          print('widget a pressed');
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          child: BarChartSample2(
            restaurantID: restaurantID,
          ),
        ),
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
        color: ui.val(1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 6, bottom: 6, left: 15, right: 15),
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
                    fontSize: 16,
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
