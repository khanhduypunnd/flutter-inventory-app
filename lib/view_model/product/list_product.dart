import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../shared/core/services/uriApi.dart';
import '../../../../../data/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListProductModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();

  int rowsPerPage = 20;
  int currentPage = 1;
  List<Product> products = [];
  List<Product> displayedProducts = [];
  int totalProducts = 0;
  bool isLoading = false;

  String searchQuery = "";
  List<Product> filteredProducts = [];


  Future<void> fetchProducts(BuildContext context) async {
    if (products.isNotEmpty) {
      _updateDisplayedProducts();
      return;
    }
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(uriAPIService.apiUrlProduct);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        products.clear();
        products = jsonData.map((data) {
          return Product.fromJson(data);
        }).toList();
        _updateDisplayedProducts();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (error) {
      showCustomToast(context, 'Lỗi khi tải sản phẩm');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _updateDisplayedProducts() {
    int startIndex = (currentPage - 1) * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (products.isEmpty) {
      displayedProducts = [];
    } else {
      displayedProducts = products.sublist(
        startIndex,
        endIndex > products.length ? products.length : endIndex,
      );
    }
    notifyListeners();
  }

  void setRowsPerPage(int value) {
    rowsPerPage = value;
    currentPage = 1;
    _updateDisplayedProducts();
  }

  void goToPage(int page) {
    if (page > 0 && page <= totalPages) {
      currentPage = page;
      _updateDisplayedProducts();
    }
  }

  int get totalPages => (products.length / rowsPerPage).ceil();


  void onSearchProduct(String query) {
    searchQuery = query.toLowerCase().trim();

    if (query.isEmpty) {
      filteredProducts = products;
    } else {
      filteredProducts = products.where((product) {
        return product.name.toLowerCase().contains(searchQuery) ||
            product.supplier.toLowerCase().contains(searchQuery);
      }).toList();
    }

    _updateDisplayedProducts();
    notifyListeners();
  }



  void showCustomToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
