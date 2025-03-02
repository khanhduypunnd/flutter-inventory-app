import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/core/theme/colors_app.dart';
import '../../../../../view_model/inventory/inventory_overall.dart';

class SummaryCards extends StatelessWidget {
  final int totalStock;
  final double totalSalePrice;
  final double totalValue;
  final double totalProfit;

  final double maxWidth;

  const SummaryCards({
    required this.totalStock,
    required this.totalSalePrice,
    required this.totalValue,
    required this.totalProfit,
    required this.maxWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inventoryOverall = Provider.of<InventoryOverallModel>(context);

    bool isCheck = maxWidth > 1000;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: AppColors.backgroundColor,
      child: isCheck ? Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildInfoCard('Tổng lượng tồn', '$totalStock'),
          ),
          SizedBox(width: 20,),
          Expanded(
            flex: 1,
            child: _buildInfoCard('Tổng giá bán', '${inventoryOverall.formatCurrencyDouble(totalSalePrice)} đ'),
          ),
          SizedBox(width: 20,),
          Expanded(
            flex: 1,
            child: _buildInfoCard('Tổng giá trị', '${inventoryOverall.formatCurrencyDouble(totalValue)} đ'),
          ),
          SizedBox(width: 20,),
          Expanded(
            flex: 1,
            child: _buildInfoCard('Tổng lợi nhuận', '${inventoryOverall.formatCurrencyDouble(totalProfit)} đ'),
          ),
        ],
      ):
      Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildInfoCard('Tổng lượng tồn', '$totalStock'),
              ),
              SizedBox(width: 20,),
              Expanded(
                flex: 1,
                child: _buildInfoCard('Tổng giá bán', '$totalSalePrice đ'),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildInfoCard('Tổng giá trị', '$totalValue đ'),
              ),
              SizedBox(width: 20,),
              Expanded(
                flex: 1,
                child: _buildInfoCard('Tổng lợi nhuận', '$totalProfit đ'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    final Map<String, Color> titleColorMap = {
      'Tổng lượng tồn': const Color(0xFFd01b1e),
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
