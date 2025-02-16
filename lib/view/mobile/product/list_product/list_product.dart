import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../../../data/product.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../../../../view_model/product/list_product.dart';
import '../new_product/new_product.dart';

class ListProduct extends StatefulWidget {
  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      Provider.of<ListProductModel>(context, listen: false).fetchProducts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listProductModel = Provider.of<ListProductModel>(context);

    int totalPages = listProductModel.totalPages;

    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding:
        const EdgeInsets.only(left: 50, right: 50, bottom: 30, top: 50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: "Tìm kiếm sản phẩm...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                listProductModel. isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidth,
                    ),
                    child: DataTable(
                      columnSpacing: 50.0,
                      columns: const [
                        DataColumn(label: Text('Tên')),
                        DataColumn(label: Text('Nhà cung cấp')),
                        DataColumn(label: Text('Danh mục')),
                        DataColumn(label: Text('Tồn kho')),
                      ],
                      rows: listProductModel.displayedProducts.map((product) {
                        final Product prod = product;
                        return DataRow(cells: [
                          DataCell(
                            Text(prod.name),
                          ),
                          DataCell(
                            Text(prod.supplier),
                          ),
                          DataCell(
                            Text(prod.category.join(', ')),
                          ),
                          DataCell(
                            Text(prod.quantities
                                .fold(0, (sum, q) => sum + q)
                                .toString()),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupMenuButton<int>(
                        onSelected: (value) {
                          listProductModel.setRowsPerPage(value);
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem<int>(value: 10, child: Text("Hiển thị 10")),
                            const PopupMenuItem<int>(value: 20, child: Text("Hiển thị 20")),
                            const PopupMenuItem<int>(value: 50, child: Text("Hiển thị 50")),
                          ];
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Text("Hiển thị ${listProductModel.rowsPerPage}", style: const TextStyle(fontSize: 16)),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.first_page),
                            onPressed: listProductModel.currentPage > 1
                                ? () => listProductModel.goToPage(1)
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: listProductModel.currentPage > 1
                                ? () => listProductModel.goToPage(listProductModel.currentPage - 1)
                                : null,
                          ),
                          Text("Trang ${listProductModel.currentPage}/$totalPages"),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: listProductModel.currentPage < totalPages
                                ? () => listProductModel.goToPage(listProductModel.currentPage + 1)
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.last_page),
                            onPressed: listProductModel.currentPage < totalPages
                                ? () => listProductModel.goToPage(totalPages)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
