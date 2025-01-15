import 'package:flutter/material.dart';
import 'analysis/business_analysis.dart';
import 'analysis/inventory_analysis.dart';
import '../../../shared/core/theme/colors_app.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: Analysis(),
//   ));
// }


class Analysis extends StatelessWidget {
  const Analysis({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          centerTitle: true,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(10.0),
            child: TabBar(
              isScrollable: false,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black54,
              tabs: [
                Tab(text: 'Phân tích kinh doanh'),
                Tab(text: 'Quản lý tồn kho'),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            // Các widget của từng tab
            Center(child: BusinessAnalysis()),
            Center(child: InventoryAnalysis()),
          ],
        ),
      ),
    );
  }

}

