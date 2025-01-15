import 'package:flutter/material.dart';
import 'analysis/business_analysis.dart';
import 'analysis/inventory_analysis.dart';
import '../../../shared/core/theme/colors_app.dart';

void main() {
  runApp(const MaterialApp(
    home: Analysis(),
  ));
}


class Analysis extends StatelessWidget {
  const Analysis({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor ,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Tổng quan'),
              Tab(text: 'Phân tích kinh doanh'),
              Tab(text: 'Quản lý tồn kho'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Nội dung Tổng quan')),
            Center(child: BusinessAnalysis()),
            Center(child: InventoryAnalysis()),
          ],
        ),
      ),
    );
  }
}

