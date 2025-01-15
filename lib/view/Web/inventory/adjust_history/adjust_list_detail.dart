import 'package:flutter/material.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../../../../data/product_adjust.dart';

class AdjustListDetail extends StatelessWidget {
  final List<ProductDetail> productDetails;

  const AdjustListDetail({
    Key? key,
    required this.productDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Tên sản phẩm')),
                    DataColumn(label: Text('Kích thước')),
                    DataColumn(label: Text('Tồn kho')),
                    DataColumn(label: Text('Tồn thực tế')),
                    DataColumn(label: Text('Thay đổi')),
                  ],
                  rows: productDetails.map((product) {
                    return DataRow(cells: [
                      DataCell(Text(product.productName, style: TextStyle(color: Colors.blueAccent),)),
                      DataCell(Text(product.size)),
                      DataCell(Text(product.oldQuantity.toString())),
                      DataCell(Text(product.newQuantity.toString())),
                      DataCell(Text(product.different.toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Ghi chú',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
