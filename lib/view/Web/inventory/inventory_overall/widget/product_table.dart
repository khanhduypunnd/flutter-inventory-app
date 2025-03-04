import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';
import '../../../../../data/product.dart';

class ProductTable extends StatelessWidget {
  final List<Product> productList;
  final double maxWidth;

  const ProductTable({
  required this.productList,
  required this.maxWidth,
  Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: maxWidth
            ),
            child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(label: Text('Tên sản phẩm', style: TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold, fontSize: 18))),
                DataColumn(label: Text('Size', style: TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold, fontSize: 18))),
                DataColumn(label: Text('Tồn kho', style: TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold, fontSize: 18))),
              ],
              rows: productList.map((product) {
                return DataRow(cells: [
                  DataCell(Text(product.name, style: const TextStyle(fontSize: 16))),
                  DataCell(Text(product.sizes.join(', '), style: const TextStyle(fontSize: 16))),
                  // DataCell(Text(product.quantities.fold(0, (sum, q) => sum + q).toString())),
                  DataCell(Text(product.quantities.join(', '), style: const TextStyle(fontSize: 16))),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}


