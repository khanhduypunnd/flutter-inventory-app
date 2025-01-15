import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../chart/line_chart.dart';
import '../chart/pie_chart.dart';
import '../chart/best_product.dart';
import '../kpi_cards/kpi_card.dart';
import '../pick_date.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InventoryAnalysis(),
    );
  }
}

class InventoryAnalysis extends StatefulWidget {
  const InventoryAnalysis({super.key});

  @override
  State<InventoryAnalysis> createState() => _ReportDashboardState();
}

class _ReportDashboardState extends State<InventoryAnalysis> {

  late double maxWidth, maxHeight;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    bool isStop = maxWidth < 650;
    bool isWarning = maxWidth < 900;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30),
            child: isStop
                ? Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TimeSelection(),
                      SizedBox(height: 10,),
                      Text('So sánh với', style: TextStyle(color: AppColors.titleColor, fontSize: 18, fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      TimeSelection(),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Số đơn hàng', value:  '11', percentage: '22.22')),
                const SizedBox(height: 16),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Số đơn hàng trung bình/ngày', value: '13',percentage: '87.71',)),
                const SizedBox(height: 16),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Số lượng tồn', value: '2,113', percentage: '--')),
                const SizedBox(height: 16),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Giá trị tồn',value:  '1,400,000 ₫', percentage: '--')),
                const SizedBox(height: 16),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Số sản phẩm đã bán', value:  '17', percentage: '54.55')),
                const SizedBox(height: 16),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Số sản phẩm trung bình/ngày', value: '17',percentage: '54.55',)),
                const SizedBox(height: 16),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Doanh thu', value: '23,810,000 ₫', percentage: '57.68')),
                const SizedBox(height: 16),
                _buildLineChart(),
                const SizedBox(height: 16),
                // _buildPiechart(),
                const SizedBox(height: 16),
                _build_best_product(),
              ],
            )
                : isWarning
                ? Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TimeSelection(),
                      SizedBox(width: 20,),
                      Text('So sánh với', style: TextStyle(color: AppColors.titleColor, fontSize: 18, fontWeight: FontWeight.bold),),
                      SizedBox(width: 10,),
                      TimeSelection(),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(child: InfoCard(title: 'Số đơn hàng', value:  '11', percentage: '22.22')),
                    const SizedBox(width: 16),
                    Expanded(child:InfoCard(title: 'Số đơn hàng trung bình/ngày', value: '13',percentage: '87.71',)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: InfoCard(title: 'Số lượng tồn', value: '2,113', percentage: '--')),
                    const SizedBox(width: 16),
                    Expanded(child:InfoCard(title: 'Giá trị tồn',value:  '1,400,000 ₫', percentage: '--')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Số sản phẩm đã bán', value:  '17', percentage: '54.55')),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Số sản phẩm trung bình/ngày', value: '17',percentage: '54.55',)),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Doanh thu', value: '23,810,000 ₫', percentage: '57.68')),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLineChart(),
                const SizedBox(height: 16),
                _build_best_product(),
              ],
            )
                : Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TimeSelection(),
                      SizedBox(width: 20,),
                      Text('So sánh với', style: TextStyle(color: AppColors.titleColor, fontSize: 18, fontWeight: FontWeight.bold),),
                      SizedBox(width: 10,),
                      TimeSelection(),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Số đơn hàng', value:  '11', percentage: '22.22')),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Số đơn hàng trung bình/ngày', value: '13',percentage: '87.71',)),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Số lượng tồn', value: '2,113', percentage: '--')),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Giá trị tồn',value:  '1,400,000 ₫', percentage: '--')),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Số sản phẩm đã bán', value:  '17', percentage: '54.55')),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Số sản phẩm trung bình/ngày', value: '17',percentage: '54.55',)),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Doanh thu', value: '23,810,000 ₫', percentage: '57.68')),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(flex: 1, child: _buildLineChart()),
                    const SizedBox(width: 20),
                    Expanded(flex: 1, child: _build_best_product()),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Keeps row compact
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2), // Rounded corners
          ),
        ),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }

  Widget _buildLineChart() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Line_Chart(
              spots1: ChartDataProvider.generateCurrentDayData(),
              spots2: ChartDataProvider.generateComparisonDayData(),
              check_size: maxWidth,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLegendItem(Colors.blue, '29/12/2024'),
                const SizedBox(width: 20),
                _buildLegendItem(Colors.green.withOpacity(0.5), '28/12/2024'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPiechart(){
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Pie_Chart(),
    );
  }

  Widget _build_best_product(){
    return Container(
      padding: const EdgeInsets.all(30),
      height: 420,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BestProductList(),
    );
  }
}

class ChartDataProvider {

  static List<FlSpot> generateCurrentDayData() {
    final random = Random();
    return List.generate(24, (hour) {
      final value = random.nextInt(10001).toDouble(); // Giá trị từ 0-10,000
      return FlSpot(hour.toDouble(), value);
    });
  }

  // Dữ liệu cho ngày so sánh
  static List<FlSpot> generateComparisonDayData() {
    final random = Random();
    return List.generate(24, (hour) {
      final value = random.nextInt(10001).toDouble(); // Giá trị từ 0-10,000
      return FlSpot(hour.toDouble(), value);
    });
  }
}