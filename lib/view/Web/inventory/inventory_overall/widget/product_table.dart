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
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: maxWidth
            ),
            child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(label: Text('Tên sản phẩm')),
                DataColumn(label: Text('Nhà cung cấp')),
                DataColumn(label: Text('Danh mục')),
                DataColumn(label: Text('Size')),
                DataColumn(label: Text('Tồn kho')),
              ],
              rows: productList.map((product) {
                return DataRow(cells: [
                  DataCell(Text(product.name)),
                  DataCell(Text(product.supplier)),
                  DataCell(Text(product.category.join(', '))),
                  DataCell(Text(product.sizes.join(', '))),
                  DataCell(Text(product.quantities.fold(0, (sum, q) => sum + q).toString())),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}


