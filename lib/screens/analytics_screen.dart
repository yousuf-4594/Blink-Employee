import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  static const String id = 'analytics_screen';
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
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
                color: Colors.black26,
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
                          '12000',
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
                    color: Colors.white,
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
              decoration: BoxDecoration(
                color: Colors.black26,
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
                        'Sales by timeslots',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Chart widget',
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
                      color: Colors.black26,
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
                                '126',
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
                              color: Colors.white,
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
                      color: Colors.black26,
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
                              color: Colors.white,
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
                color: Colors.black26,
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
                          '12,000rs',
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
                        color: Colors.white,
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black26,
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
                          margin:
                              EdgeInsets.only(left: 10, bottom: 20, top: 10),
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
                                    Icon(Icons.ac_unit_rounded,
                                        color: Colors.white, size: 20),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'food item $i',
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
                      color: Colors.black26,
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
    ));
  }
}
