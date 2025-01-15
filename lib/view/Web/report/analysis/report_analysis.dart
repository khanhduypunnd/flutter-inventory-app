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
      home: ReportDashboard(),
    );
  }
}

class ReportDashboard extends StatefulWidget {
  const ReportDashboard({super.key});

  @override
  _ReportDashboardState createState() => _ReportDashboardState();
}

class _ReportDashboardState extends State<ReportDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng phân tích báo cáo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [

                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildCard('Số đơn hàng', '11', '22.22%', Colors.blue),
                        const SizedBox(height: 16), // Khoảng cách giữa các thẻ
                        _buildCard('Doanh thu thuần', '24,590,000 ₫', '12.03%', Colors.green),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),


                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildCard('Hoàn trả', '0', '--', Colors.red),
                        const SizedBox(height: 16),
                        _buildCard('Thực nhận', '24,730,000 ₫', '-94.59%', Colors.red),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    minX: 0,
                    maxX: 10,
                    minY: 0,
                    maxY: 10,
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 1),
                          FlSpot(2, 2),
                          FlSpot(4, 1),
                          FlSpot(6, 4),
                          FlSpot(8, 2),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.blue.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Doanh thu theo chi nhánh bán', style: TextStyle(fontSize: 16)),
                    Icon(Icons.bar_chart),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildCard(String title, String value, String percent, Color color) {
    return Container(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$percent', style: TextStyle(color: color, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  static Widget _buildProductCard(String productName, String price) {
    return ListTile(
      leading: const Icon(Icons.shopping_basket, color: Colors.blue),
      title: Text(productName),
      subtitle: Text(price),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
