import 'package:connectionscherished/styles/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WeeklyChart extends StatefulWidget {
  WeeklyChart({super.key, required this.data, this.friendData});
  Map<String, dynamic> data = {};
  Map<String, dynamic> ? friendData;

  @override
  WeeklyChartState createState() => WeeklyChartState();
}

class WeeklyChartState extends State<WeeklyChart> {
  var weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  @override
  void initState() {
    super.initState();
    getCombinedData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<BarChartGroupData> getCombinedData() {
    List<BarChartGroupData> bars = [];
    widget.data.forEach((key, value) {
      int index = weekDays.indexOf(key);
      if (index != -1) {
        double friendValue = widget.friendData != null && widget.friendData!.containsKey(key)
            ? widget.friendData![key].toDouble()
            : 0.0;
        bars.add(
          BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                fromY: 0,
                toY: friendValue,
                color: Colors.blueAccent,
                width: 12,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  fromY: 0,
                  toY: value.toDouble(),
                  color: widget.friendData != null ? Colors.grey[300] : Colors.blueAccent,
                ),
              ),
            ],
          ),
        );
      }
    });
    return bars;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(
            show: false,
          ),
          backgroundColor: Colors.transparent,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, metaData) {
                return getAxisTitles(value);
              }
            )),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: getCombinedData()
        )
      )
    );
  }

  Widget axisText(String text) {
    return Text(text, style: GlobalStyles.textStyles.textCaption2.copyWith(color: Colors.white),);
  }

  Widget getAxisTitles(double value) {
    return axisText(weekDays[value.toInt()]);
  }
}