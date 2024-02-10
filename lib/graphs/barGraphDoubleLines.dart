import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/mysql.dart';
import 'package:mysql_client/mysql_client.dart';

class BarChartSample2 extends StatefulWidget {
  final String restaurantID;
  BarChartSample2({super.key, required this.restaurantID});
  final Color leftBarColor = Colors.orange;
  final Color avgColor = Colors.greenAccent;

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 8;
  late List<BarChartGroupData> rawBarGroups = [];
  late List<BarChartGroupData> showingBarGroups = [];

  int touchedGroupIndex = -1;

  // final barGroup1 = makeGroupData(x: 0, y1: 0); // 8-9
  // final barGroup2 = makeGroupData(x: 0, y1: 0); // 9-10
  // final barGroup3 = makeGroupData(x: 0, y1: 0); // 10-11
  // final barGroup4 = makeGroupData(x: 0, y1: 0); // 11-12
  // final barGroup5 = makeGroupData(x: 0, y1: 0); // 12-1
  // final barGroup6 = makeGroupData(x: 0, y1: 0); // 1-2
  // final barGroup7 = makeGroupData(x: 0, y1: 0); // 2-3
  // final barGroup8 = makeGroupData(x: 0, y1: 0); // 3-4

  late List<BarChartGroupData> items = [];

  @override
  void initState() {
    super.initState();
    getSalesByTimeSlot();
  }

  String selectedValue = 'Today';

  void getSalesByTimeSlot() async {
    List<BarChartGroupData> temp = [];
    Map<String, int> stats = {
      "8": 0,
      "9": 0,
      "10": 0,
      "11": 0,
      "12": 0,
      "1": 0,
      "2": 0,
      "3": 0
    };
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("orders")
          .orderBy('placedat')
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime timestamp = data["placedat"].toDate();
        int hour = timestamp.hour;
        if (stats.containsKey(hour.toString())) {
          int price = data["price"];
          stats[hour.toString()] = (stats[hour.toString()]! + price);
        }
      }
    } catch (e) {
      print(e);
    }
    int i = 0;
    stats.forEach((key, value) {
      temp.add(BarChartGroupData(
        barsSpace: 2,
        x: i,
        barRods: [
          BarChartRodData(
            toY: value.toDouble(),
            color: widget.leftBarColor,
            width: width,
          )
        ],
      ));
      i++;
    });

    setState(() {
      items = temp;
      rawBarGroups = items;
      showingBarGroups = rawBarGroups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sales By Timeslot',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      DropdownButton<String>(
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        icon:
                            Icon(Icons.arrow_drop_down, color: Colors.white24),
                        underline: Container(),
                        dropdownColor: Colors.white12,
                        items: <String>[
                          'Today',
                          'Last Week',
                          'Last 30days',
                          'Last year'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 20,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                              in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: showingBarGroups[touchedGroupIndex]
                                .barRods
                                .map((rod) {
                              return rod.copyWith(
                                  toY: avg, color: widget.avgColor);
                            }).toList(),
                          );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 19) {
      text = '10K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      '08-09',
      '09-10',
      '10-11',
      '11-12',
      '12-01',
      '01-02',
      '02-03',
      '03-04',
    ];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData({required int x, double y1 = 0.0}) {
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        )
      ],
    );
  }
}
