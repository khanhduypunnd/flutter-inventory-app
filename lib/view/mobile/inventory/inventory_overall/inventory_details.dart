import 'package:flutter/material.dart';
import 'dart:math';
import '../../../../shared/core/theme/colors_app.dart';
import 'widget/product_table.dart';
import 'widget/card_infor.dart';

class InventoryOverall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InventoryDetails(),
    );
  }
}

class InventoryDetails extends StatefulWidget {
  @override
  _InventoryDetailsState createState() => _InventoryDetailsState();
}

class _InventoryDetailsState extends State<InventoryDetails> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> productsInStock = [];
  List<Map<String, dynamic>> productsOutOfStock = [];
  int totalStock = 0;
  int totalSalePrice = 0;
  int totalValue = 0;
  int totalProfit = 0;

  @override
  void initState() {
    super.initState();
    _fetchInventoryData();
  }

  void _fetchInventoryData() {
    final random = Random();
    products = List.generate(
      50,
          (index) => {
        "kho": "Kho ${index + 1}",
        "name": "Sản phẩm ${index + 1}",
        "sku": "SKU${index + 1}",
        "barcode": "Barcode${index + 1}",
        "stock": index % 5 == 0 ? 0 : random.nextInt(100),
        "price": random.nextInt(500000) + 10000,
        "total": random.nextInt(5000000) + 100000,
      },
    );

    productsInStock = products.where((product) => product["stock"] > 0).toList();
    productsOutOfStock = products.where((product) => product["stock"] == 0).toList();

    totalStock = products.fold(0, (sum, item) => sum + item["stock"] as int);
    totalSalePrice = products.fold(0, (sum, item) => sum + item["price"] as int);
    totalValue = products.fold(0, (sum, item) => sum + item["total"] as int);
    totalProfit = totalValue - totalSalePrice;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        // appBar: AppBar(
        //   backgroundColor: AppColors.backgroundColor,
        //   title: const Text('Chi tiết tồn kho', style: TextStyle(color: AppColors.titleColor),),
        // ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
          child: Column(
            children: [
              SummaryCards(
                totalStock: totalStock,
                totalSalePrice: totalSalePrice,
                totalValue: totalValue,
                totalProfit: totalProfit,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(text: 'Sản phẩm còn hàng'),
                            Tab(text: 'Sản phẩm hết hàng'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal, // Hỗ trợ cuộn ngang DataTable
                                child: ProductTable(productList: productsInStock),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ProductTable(productList: productsOutOfStock),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
