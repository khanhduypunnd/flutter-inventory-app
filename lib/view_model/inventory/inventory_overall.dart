import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../data/product.dart';
import '../../shared/core/services/uriApi.dart';

class InventoryOverallModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();

  List<Product> listProducts = [];
  List<Product> productsInStock = [];
  List<Product> productsOutOfStock = [];

  int totalStock = 0;
  double totalSalePrice = 0;
  double totalValue = 0;
  double totalProfit = 0;
  int totalProducts = 0;

  bool isLoading = false;

  Future<void> fetchProducts(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(uriAPIService.apiUrlProduct);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        listProducts = jsonData.map<Product>((data) {
          return Product.fromJson(data);
        }).toList();

        productsInStock.clear();
        productsOutOfStock.clear();

        for (var product in listProducts) {
          List<String> sizesInStock = [];
          List<String> sizesOutOfStock = [];

          for (int i = 0; i < product.sizes.length; i++) {
            (product.quantities[i] > 0 ? sizesInStock : sizesOutOfStock).add(product.sizes[i]);
          }

          if (sizesInStock.isNotEmpty) productsInStock.add(_filteredProduct(product, sizesInStock));
          if (sizesOutOfStock.isNotEmpty) productsOutOfStock.add(_filteredProduct(product, sizesOutOfStock));
        }

        totalSalePrice = listProducts.fold(0.0, (sum, product) {
          return sum + product.quantities.asMap().entries
              .where((entry) => entry.value > 0)
              .fold<double>(0.0, (subSum, entry) => subSum + (product.sellPrices[entry.key] * entry.value)); // Nhân actualPrices * quantities
        });

        totalValue = listProducts.fold<double>(0.0, (sum, product) {
          return sum + product.quantities.asMap().entries
              .where((entry) => entry.value > 0)
              .fold<double>(0.0, (subSum, entry) => subSum + (product.actualPrices[entry.key] * entry.value)); // Nhân actualPrices * quantities
        });


        totalProfit = totalSalePrice - totalValue;

        totalStock = listProducts.fold(0, (sum, product) {
          return sum + product.quantities
              .where((q) => q > 0)
              .fold<int>(0, (subSum, q) => subSum + q);
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
      isLoading = false;
      notifyListeners();
    }
  }

  Product _filteredProduct(Product product, List<String> selectedSizes) {
    return Product(
      id: product.id,
      name: product.name,
      supplier: product.supplier,
      category: product.category,
      usage: product.usage,
      origin: product.origin,
      description: product.description,
      notes: product.notes,
      sizes: selectedSizes,
      actualPrices: _mapSelectedValues(product.sizes, product.actualPrices, selectedSizes),
      sellPrices: _mapSelectedValues(product.sizes, product.sellPrices, selectedSizes),
      quantities: _mapSelectedValues(product.sizes, product.quantities, selectedSizes),
      image: product.image,
      averageRating: product.averageRating,
      totalReviews: product.totalReviews,
    );
  }

  List<T> _mapSelectedValues<T>(List<String> allSizes, List<T> values, List<String> selectedSizes) {
    return selectedSizes.map((size) => values[allSizes.indexOf(size)]).toList();
  }

  String formatCurrencyDouble(double amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return formatter.format(amount);
  }
}
