import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../../../../view_model/report.dart';
import '../chart/line_chart.dart';
import '../chart/pie_chart.dart';
import '../chart/best_product.dart';
import '../kpi_cards/kpi_card.dart';
import '../../pickdate/pick_date.dart';

class InventoryAnalysis extends StatefulWidget {
  const InventoryAnalysis({super.key});

  @override
  State<InventoryAnalysis> createState() => _ReportDashboardState();
}

class _ReportDashboardState extends State<InventoryAnalysis> {

  late double maxWidth, maxHeight;

  DateTime? startDate1, endDate1;
  DateTime? startDate2, endDate2;

  void _onDateSelected1(DateTime? start, DateTime? end) {
    setState(() {
      startDate1 = start;
      endDate1 = end;
    });
  }

  void _onDateSelected2(DateTime? start, DateTime? end) {
    setState(() {
      startDate2 = start;
      endDate2 = end;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
  }

  void _fetchComparisonData() {
    if (startDate1 != null && startDate2 != null) {
      Future.microtask(() {
        Provider.of<ReportModel>(context, listen: false).fetchComparisonData(startDate1!, endDate1!, startDate2!, endDate2!);
        Provider.of<ReportModel>(context, listen: false).fetchProducts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isStop = maxWidth < 650;
    bool isWarning = maxWidth < 900;

    final reportModel = Provider.of<ReportModel>(context);

    Map<String, double> paymentData = reportModel.getPaymentMethodData(reportModel.filteredOrders1);

    List<MapEntry<String, int>>  bestSellingProducts = reportModel.bestSellingProducts;

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
                  height: 250,
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
                      TimeSelection(onDateSelected: _onDateSelected1),
                      const SizedBox(height: 10,),
                      const Text('So sánh với', style: TextStyle(color: AppColors.titleColor, fontSize: 18, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      TimeSelection(onDateSelected: _onDateSelected2),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 2,
                          side: const BorderSide(color: Colors.blueAccent, width: 1),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onPressed: () {
                          _fetchComparisonData();
                        },
                        child: const Text("So sánh dữ liệu", ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Số đơn hàng', value:  reportModel.filteredOrders1.length.toString(), percentage: reportModel.orderQuantityPercent.toString())),
                const SizedBox(height: 16),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Số lượng tồn', value: reportModel.inOfStock.toString(), percentage: '--')),
                const SizedBox(height: 16),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Giá trị tồn',value:  reportModel.formatCurrencyDouble(reportModel.residualValue), percentage: '--')),
                const SizedBox(height: 16),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Số sản phẩm đã bán', value:  reportModel.productNumberSold.toString(), percentage: reportModel.productNumberSoldPercent.toString())),
                const SizedBox(height: 16),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: InfoCard(title: 'Doanh thu', value: reportModel.formatCurrencyDouble(reportModel.receivedMoney), percentage: reportModel.receivedMoneyPercent.toString())),
                // const SizedBox(height: 16),
                // _buildLineChart(),
                // const SizedBox(height: 16),
                // _buildPiechart(),
                const SizedBox(height: 16),
                _build_best_product(bestSellingProducts),
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TimeSelection(onDateSelected: _onDateSelected1),
                        const SizedBox(width: 10,),
                        const Text('So sánh với', style: TextStyle(color: AppColors.titleColor, fontSize: 18, fontWeight: FontWeight.bold),),
                        const SizedBox(width: 10,),
                        TimeSelection(onDateSelected: _onDateSelected2),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 2,
                            side: const BorderSide(color: Colors.blueAccent, width: 1),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onPressed: () {
                            _fetchComparisonData();
                          },
                          child: const Text("So sánh dữ liệu"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(child: InfoCard(title: 'Số đơn hàng', value:  reportModel.filteredOrders1.length.toString(), percentage: reportModel.orderQuantityPercent.toString())),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: InfoCard(title: 'Số lượng tồn', value: reportModel.inOfStock.toString(), percentage: '--')),
                    const SizedBox(width: 16),
                    Expanded(child:InfoCard(title: 'Giá trị tồn',value:  reportModel.formatCurrencyDouble(reportModel.residualValue), percentage: '--')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Số sản phẩm đã bán', value:  reportModel.productNumberSold.toString(), percentage: reportModel.productNumberSoldPercent.toString())),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Doanh thu', value: reportModel.formatCurrencyDouble(reportModel.receivedMoney), percentage: reportModel.receivedMoneyPercent.toString())),
                  ],
                ),
                // const SizedBox(height: 16),
                // _buildLineChart(),
                const SizedBox(height: 16),
                _build_best_product(bestSellingProducts),
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TimeSelection(onDateSelected: _onDateSelected1),
                        const SizedBox(width: 10,),
                        const Text('So sánh với', style: TextStyle(color: AppColors.titleColor, fontSize: 18, fontWeight: FontWeight.bold),),
                        const SizedBox(width: 10,),
                        TimeSelection(onDateSelected: _onDateSelected2),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 2,
                            side: const BorderSide(color: Colors.blueAccent, width: 1),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onPressed: () {
                            _fetchComparisonData();
                          },
                          child: const Text("So sánh dữ liệu"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Số đơn hàng', value:  reportModel.filteredOrders1.length.toString(), percentage: reportModel.orderQuantityPercent.toString())),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Số lượng tồn', value: reportModel.inOfStock.toString(), percentage: '--')),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Giá trị tồn',value:  reportModel.formatCurrencyDouble(reportModel.residualValue), percentage: '--')),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Số sản phẩm đã bán', value:  reportModel.productNumberSold.toString(), percentage: reportModel.productNumberSoldPercent.toString())),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 1,
                        child: InfoCard(title: 'Doanh thu', value: reportModel.formatCurrencyDouble(reportModel.receivedMoney), percentage: reportModel.receivedMoneyPercent.toString())),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Expanded(flex: 1, child: _buildLineChart()),
                    const SizedBox(width: 20),
                    Expanded(flex: 1, child: _build_best_product(bestSellingProducts)),
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

  // Widget _buildLegendItem(Color color, String text) {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min, // Keeps row compact
  //     children: [
  //       Container(
  //         height: 12,
  //         width: 12,
  //         decoration: BoxDecoration(
  //           color: color,
  //           borderRadius: BorderRadius.circular(2), // Rounded corners
  //         ),
  //       ),
  //       const SizedBox(width: 5),
  //       Text(text, style: TextStyle(color: color)),
  //     ],
  //   );
  // }
  //
  // Widget _buildLineChart() {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
  //     height: 400,
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border.all(color: Colors.black.withOpacity(0.1)),
  //       borderRadius: BorderRadius.circular(8),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           spreadRadius: 2,
  //           blurRadius: 5,
  //           offset: const Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Expanded(
  //           child: Line_Chart(
  //             spots1: ChartDataProvider.generateCurrentDayData(),
  //             spots2: ChartDataProvider.generateComparisonDayData(),
  //             check_size: maxWidth,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Align(
  //           alignment: Alignment.center,
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               _buildLegendItem(Colors.blue, '29/12/2024'),
  //               const SizedBox(width: 20),
  //               _buildLegendItem(Colors.green.withOpacity(0.5), '28/12/2024'),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _build_best_product(List<MapEntry<String, int>> bestSellingProducts){
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
      child: BestProductList(bestSellingSizes: bestSellingProducts),
    );
  }
}

// class ChartDataProvider {
//
//   static List<FlSpot> generateCurrentDayData() {
//     final random = Random();
//     return List.generate(24, (hour) {
//       final value = random.nextInt(10001).toDouble(); // Giá trị từ 0-10,000
//       return FlSpot(hour.toDouble(), value);
//     });
//   }
//
//   static List<FlSpot> generateComparisonDayData() {
//     final random = Random();
//     return List.generate(24, (hour) {
//       final value = random.nextInt(10001).toDouble(); // Giá trị từ 0-10,000
//       return FlSpot(hour.toDouble(), value);
//     });
//   }
// }