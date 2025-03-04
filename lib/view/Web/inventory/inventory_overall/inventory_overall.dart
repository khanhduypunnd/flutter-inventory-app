import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../../../../view_model/inventory/inventory_overall.dart';
import 'widget/product_table.dart';
import 'widget/card_infor.dart';

class InventoryOverall extends StatefulWidget {
  final Map<String, dynamic>? staffData;
  const InventoryOverall({super.key, this.staffData});

  @override
  State<InventoryOverall> createState() => _InventoryOverallState();
}

class _InventoryOverallState extends State<InventoryOverall> {
  late double maxWidth = 0.0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<InventoryOverallModel>(context, listen: false).fetchProducts(context);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    final inventoryOverall = Provider.of<InventoryOverallModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title: const Text(
            'Chi tiết tồn kho',
            style: TextStyle(color: AppColors.titleColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
          child: Column(
            children: [
              SummaryCards(
                totalStock: inventoryOverall.totalStock,
                totalSalePrice: inventoryOverall.totalSalePrice,
                totalValue: inventoryOverall.totalValue,
                totalProfit: inventoryOverall.totalProfit,
                maxWidth: maxWidth,
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
                    length: 3,
                    child: Column(
                      children: [
                        const TabBar(
                          labelColor: Colors.blueAccent,
                          indicatorColor: Colors.blueAccent,
                          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          unselectedLabelStyle: TextStyle(fontSize: 16),
                          tabs: [
                            Tab(text: 'Sản phẩm còn hàng'),
                            Tab(text: 'Sản phẩm sắp hết hàng'),
                            Tab(text: 'Sản phẩm hết hàng'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              ProductTable(
                                  maxWidth: maxWidth,
                                  productList:inventoryOverall.productsInStock),
                              ProductTable(
                                  maxWidth: maxWidth,
                                  productList: inventoryOverall.productsLowStock),
                              ProductTable(
                                  maxWidth: maxWidth,
                                  productList: inventoryOverall.productsOutOfStock),
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
