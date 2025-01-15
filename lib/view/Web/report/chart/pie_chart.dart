import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Pie_Chart())),
    );
  }
}

class Pie_Chart extends StatelessWidget {
  const Pie_Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          width: 300,
          child: PieChart(
            PieChartData(
              sections: showingSections(),
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 50,
            ),
          ),
        ),


        const SizedBox(height: 20),


        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendContainer(Colors.orange, "Visa/Master"),
            const SizedBox(width: 20),
            _buildLegendContainer(Colors.teal, "Chuyển khoản"),
          ],
        ),
      ],
    );
  }

  // Dữ liệu cho Pie Chart
  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 64.55,
        title: '64.55%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 35.45,
        title: '35.45%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  // Widget để tạo các container mô tả dữ liệu
  Widget _buildLegendContainer(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
