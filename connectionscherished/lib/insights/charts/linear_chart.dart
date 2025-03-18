import 'package:connectionscherished/insights/insight_detail.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LinearChart extends StatefulWidget {
  LinearChart({super.key, required this.data, this.friendData, required this.selectedChartType});
  Map<String, dynamic> data = {};
  Map<String, dynamic> ? friendData;
  ChartType selectedChartType;

  @override
  LinearChartState createState() => LinearChartState();
}

class LinearChartState extends State<LinearChart> {
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  var years = List<String>.generate(6, (index) => (DateTime.now().year - 5 + index).toString());

  @override
  void initState() {
    super.initState();
    getOverallData();
  }

  @override
  void dispose() {
    super.dispose();
  }


  List<FlSpot> getOverallData(){
    List<FlSpot> spots = [];
    widget.data.forEach((key, value) {
      int index = (widget.selectedChartType == ChartType.month ? months : years).indexOf(key);
      if (index != -1) {
        spots.add(FlSpot(index.toDouble(), value.toDouble()));
      }
    });
    return spots;
  }

  List<FlSpot> getFriendData(){
    List<FlSpot> spots = [];
    if(widget.friendData != null){
      widget.friendData?.forEach((key, value) {
        int index = (widget.selectedChartType == ChartType.month ? months : years).indexOf(key);
        if (index != -1) {
          spots.add(FlSpot(index.toDouble(), value.toDouble()));
        }
      });
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(
            show: false,
          ),
          backgroundColor: Colors.transparent,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
              showTitles: true,
              interval: widget.selectedChartType == ChartType.month ? 2 : 1,
              getTitlesWidget: (value, metaData) {
                return getAxisTitles(value);
              }
            )),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: getOverallData(),
              color: Colors.blueAccent,
              barWidth: 5,
              isCurved: true,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false
              ),
              preventCurveOverShooting: true,
              show: true
            ),
            LineChartBarData(
              spots: getFriendData(),
              color: const Color.fromARGB(255, 255, 227, 68),
              barWidth: 5,
              isCurved: true,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false
              ),
              preventCurveOverShooting: true,
              show: widget.friendData != null
            ),
          ]
        )
      )
    );
  }

  Widget axisText(String text) {
    return Text(text, style: GlobalStyles.textStyles.textCaption2.copyWith(color: Colors.white),);
  }

  Widget getAxisTitles(double value) {
    return axisText((widget.selectedChartType == ChartType.month ? months : years)[value.toInt()]);
  }
}