import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Line_Chart extends StatelessWidget {
  final List<FlSpot> spots1;
  final List<FlSpot> spots2;
  final double check_size;

  const Line_Chart({
    required this.spots1,
    required this.spots2,
    required this.check_size,
    Key? key,
  }) : super(key: key);


  double getIntervalBasedOnScreenSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 1400) {
      return 2;
    } else {
      return 1;
    }
  }


  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData(context),
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData sampleData(BuildContext context) => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1(context),
    borderData: borderData,
    lineBarsData: lineBarsData,
    minX: 0,
    maxX: 23,
    maxY: 10000,
    minY: 0,
  );


  List<LineChartBarData> get lineBarsData => [
    LineChartBarData(
      spots: spots1,
      isCurved: true,
      color: Colors.blue,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.2),
            Colors.blue.withOpacity(0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    ),
    LineChartBarData(
      spots: spots2,
      isCurved: true,
      color: Colors.green,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      dashArray: [5, 5], // Line nét đứt
    ),
  ];

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData titlesData1(BuildContext context) => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles(context),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
    );
    String text = '\$' + value.toInt().toString();
    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 1000,
    reservedSize: 40,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 9,
    );
    Widget text;
    text = Text('${value.toInt()}h', style: style);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles bottomTitles(BuildContext context) => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: getIntervalBasedOnScreenSize(context),
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData => FlGridData(
    show: true,
    drawHorizontalLine: true,
    horizontalInterval: 1000,
    getDrawingHorizontalLine: (value) {
      return FlLine(
        color: Colors.grey.withOpacity(0.2),
        strokeWidth: 1,
      );
    },
    drawVerticalLine: false,
  );

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(
        color: Colors.blue.withOpacity(0.2),
        width: 4,
      ),
      left: const BorderSide(color: Colors.transparent),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    ),
  );
}
