import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';
class CustomerInfoHeader extends StatelessWidget {
  final String customerName;
  final double cumulativeRevenue;
  final int totalOrders;

  const CustomerInfoHeader({
    Key? key,
    required this.customerName,
    required this.cumulativeRevenue,
    required this.totalOrders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tên khách hàng: $customerName',
            style: TextStyle(color: AppColors.titleColor, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Container(
              child: Text('Doanh thu tích lũy: \ ${cumulativeRevenue.toStringAsFixed(2)}', style: TextStyle(fontSize: 15, color: Colors.blueAccent),)),
          const SizedBox(height: 4),
          Container(
              child: Text('Tổng số đơn: $totalOrders', style: TextStyle(fontSize: 15, color:  Colors.blueAccent),)),
        ],
      ),
    );
  }
}