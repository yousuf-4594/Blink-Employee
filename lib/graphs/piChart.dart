import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_restraunt/mysql.dart';

import '../classes/CategorySales.dart';

class PieChartSample extends StatefulWidget {
  final int restaurantID;
  const PieChartSample({super.key, required this.restaurantID});

  @override
  State<StatefulWidget> createState() =>
      PieChart2State(restaurantID: restaurantID);
}

class PieChart2State extends State {
  int touchedIndex = -1;
  List<Indicator> categorySalesIndicator = [];
  final int restaurantID;

  PieChart2State({required this.restaurantID});

  void getCategorySales() async {
    var db = Mysql();
    List<CategorySales> temp;
    List<Indicator> indicators = [];
    temp = await db.getCategorySales(restaurantID);
    for (int i = 0; i < temp.length; i++) {
      indicators.add(
        Indicator(
          color: temp[i].color,
          text: temp[i].categoryName,
          isSquare: false,
          textColor: Colors.white,
          percentage: temp[i].percentage,
        ),
      );
    }
    setState(() {
      categorySalesIndicator = indicators;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategorySales();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 3,
                  centerSpaceRadius: 20,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categorySalesIndicator,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(categorySalesIndicator.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: categorySalesIndicator[i].color,
        value: double.parse('${categorySalesIndicator[i].percentage}'),
        title: '${categorySalesIndicator[i].percentage}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      );
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator(
      {super.key,
      required this.color,
      required this.text,
      required this.isSquare,
      this.size = 16,
      this.textColor,
      required this.percentage});
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
