import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';

class CustomerOrdersTable extends StatelessWidget {
  final List<Map<String, String>> orderList;

  const CustomerOrdersTable({
    Key? key,
    required this.orderList,
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
          Text('Danh sách đơn hàng', style: TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold, fontSize: 20),),
          SizedBox(height: 20,),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Mã Đơn Hàng', style: TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Ngày', style: TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Giá Trị', style: TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold))),
                ],
                rows: orderList.map((order) {
                  return DataRow(cells: [
                    DataCell(Text(order['id'] ?? '')),
                    DataCell(Text(order['date'] ?? '')),
                    DataCell(Text(order['value'] ?? '')),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
