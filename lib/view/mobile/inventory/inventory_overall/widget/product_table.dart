import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';

class ProductTable extends StatelessWidget {
  final List<Map<String, dynamic>> productList;

  const ProductTable({required this.productList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 80,
            showCheckboxColumn: false,
            columns: const [
              // DataColumn(label: Text('Kho')),
              DataColumn(label: Text('Sản phẩm')),
              // DataColumn(label: Text('SKU')),
              // DataColumn(label: Text('Barcode')),
              DataColumn(label: Text('Tồn')),
              DataColumn(label: Text('Giá')),
              DataColumn(label: Text('Tổng')),
            ],
            rows: productList.map((product) {
              return DataRow(cells: [
                // DataCell(Text(product["kho"])),
                DataCell(Text(product["name"])),
                // DataCell(Text(product["sku"])),
                // DataCell(Text(product["barcode"])),
                DataCell(Text('${product["stock"]}')),
                DataCell(Text('${product["price"]} đ')),
                DataCell(Text('${product["total"]} đ')),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
