import 'package:flutter/material.dart';
import 'analysis/business_analysis.dart';
import 'analysis/inventory_analysis.dart';
import '../../../shared/core/theme/colors_app.dart';

class Analysis extends StatelessWidget {
  final Map<String, dynamic>? staffData;
  const Analysis({super.key, this.staffData});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor ,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Phân tích kinh doanh'),
              Tab(text: 'Quản lý tồn kho'),
            ],
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.black,
            indicator: UnderlineTabIndicator(
              insets: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: BusinessAnalysis()),
            Center(child: InventoryAnalysis()),
          ],
        ),
      ),
    );
  }
}

