import 'package:flutter/material.dart';
import '../../../../shared/core/theme/colors_app.dart';
import 'widget/product_table.dart';
import 'widget/card_infor.dart';
import '../../../../../data/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InventoryOverall extends StatelessWidget {
  const InventoryOverall({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InventoryDetails(),
    );
  }
}

class InventoryDetails extends StatefulWidget {
  const InventoryDetails({super.key});

  @override
  State<InventoryDetails>  createState() => _InventoryDetailsState();
}

class _InventoryDetailsState extends State<InventoryDetails> {
  List<Product> products = [];
  List<Product> productsInStock = [];
  List<Product> productsOutOfStock = [];

  int totalStock = 0;
  int totalSalePrice = 0;
  int totalValue = 0;
  int totalProfit = 0;
  int totalProducts = 0;

  late double maxWidth = 0.0;



  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('https://dacntt1-api-server-5uchxlkka-haonguyen9191s-projects.vercel.app/api/products');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);


        setState(() {
          products = jsonData.map<Product>((data) {
            return Product.fromJson(data);
          }).toList();


          for (var product in products) {

            List<String> sizesInStock = [];
            List<String> sizesOutOfStock = [];

            for(int i = 0; i < product.sellPrices.length; i ++){
              totalSalePrice = product.sellPrices[i] as int;
              totalValue = product.actualPrices[i] as int;
            }

            for (int i = 0; i < product.sizes.length; i++) {
              if (product.quantities[i] > 0) {
                totalStock += product.quantities[i];
                sizesInStock.add(product.sizes[i]);
              } else {
                sizesOutOfStock.add(product.sizes[i]);
              }
            }

            totalProfit = totalSalePrice - totalValue;

            if (sizesInStock.isNotEmpty) {
              productsInStock.add(Product(
                id: product.id,
                name: product.name,
                supplier: product.supplier,
                category: product.category,
                usage: product.usage,
                origin: product.origin,
                description: product.description,
                notes: product.notes,
                sizes: sizesInStock,
                actualPrices: product.actualPrices,
                sellPrices: product.sellPrices,
                quantities: sizesInStock.map((size) {
                  int index = product.sizes.indexOf(size);
                  return product.quantities[index];
                }).toList(),
                image: product.image,
                averageRating: product.averageRating,
                totalReviews: product.totalReviews,
              ));
            }

            if (sizesOutOfStock.isNotEmpty) {
              productsOutOfStock.add(Product(
                id: product.id,
                name: product.name,
                supplier: product.supplier,
                category: product.category,
                usage: product.usage,
                origin: product.origin,
                description: product.description,
                notes: product.notes,
                sizes: sizesOutOfStock,
                actualPrices: product.actualPrices,
                sellPrices: product.sellPrices,
                quantities: sizesOutOfStock.map((size) {
                  int index = product.sizes.indexOf(size);
                  return product.quantities[index];
                }).toList(),
                image: product.image,
                averageRating: product.averageRating,
                totalReviews: product.totalReviews,
              ));
            }
          }

          totalProducts = products.length;
          print(totalProducts);
        });
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải sản phẩm: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title: const Text('Chi tiết tồn kho', style: TextStyle(color: AppColors.titleColor),),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
          child: Column(
            children: [
              SummaryCards(
                totalStock: totalStock,
                totalSalePrice: totalSalePrice,
                totalValue: totalValue,
                totalProfit: totalProfit,
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
                              ProductTable(maxWidth: maxWidth,productList: productsInStock),
                              ProductTable(maxWidth: maxWidth,productList: productsOutOfStock),
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
