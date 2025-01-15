import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';

class SummaryCards extends StatelessWidget {
  final int totalStock;
  final int totalSalePrice;
  final int totalValue;
  final int totalProfit;

  const SummaryCards({
    required this.totalStock,
    required this.totalSalePrice,
    required this.totalValue,
    required this.totalProfit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: _buildInfoCard('Tổng lượng tồn', '$totalStock')),
              Expanded(flex: 1, child: _buildInfoCard('Tổng giá bán', '$totalSalePrice đ')),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 1, child: _buildInfoCard('Tổng giá trị', '$totalValue đ')),
              Expanded(flex: 1, child: _buildInfoCard('Tổng lợi nhuận', '$totalProfit đ')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    final Map<String, Color> titleColorMap = {
      'Tổng lượng tồn': const Color(0xFFff938a),
      'Tổng giá trị': const Color(0xFF3ca8fc),
      'Tổng lợi nhuận': const Color(0xFF3cfca8),
      'Tổng giá bán': const Color(0xFFff7df9),
    };

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: titleColorMap[title],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: titleColorMap[title],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
