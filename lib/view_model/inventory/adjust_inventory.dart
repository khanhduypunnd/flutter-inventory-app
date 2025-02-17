import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/gan.dart';
import '../../data/product.dart';
import '../../shared/core/services/uriApi.dart';
import '../../view/Web/inventory/popup/search_product.dart';

class AdjustInventoryModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  bool isLoading = false;

  List<Product> allProducts = [];
  List<Product> searchResults = [];
  List<Product> selectedProducts = [];
  Map<String, Map<String, TextEditingController>> quantityControllers = {};

  int increaseAmount = 0;
  int decreaseAmount = 0;

  late String staffId = '';
  late String staffName = '';

  Future<void> fetchProducts(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(uriAPIService.apiUrlProduct);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        allProducts = jsonData.map((data) => Product.fromJson(data)).toList();

        searchResults.clear();
        searchResults = allProducts;
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải sản phẩm: ')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      searchResults = [];
    } else {
      searchResults = allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void showSearchResults(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SearchResultsDialog(
          searchResults: searchResults,
          onSelect: (Product product, List<String> selectedSizes) {
            for (var size in selectedSizes) {
              if (!selectedProducts
                  .any((p) => p.id == product.id && p.sizes.contains(size))) {
                final int index = product.sizes.indexOf(size);

                if (index != -1) {
                  selectedProducts.add(Product(
                    id: product.id,
                    name: product.name,
                    supplier: product.supplier,
                    category: product.category,
                    usage: product.usage,
                    origin: product.origin,
                    description: product.description,
                    notes: product.notes,
                    sizes: [size],
                    actualPrices: [product.actualPrices[index]],
                    sellPrices: [product.sellPrices[index]],
                    quantities: [product.quantities[index]],
                    image: product.image,
                    averageRating: product.averageRating,
                    totalReviews: product.totalReviews,
                  ));

                  if (!quantityControllers.containsKey(product.id)) {
                    quantityControllers[product.id] = {};
                  }
                  quantityControllers[product.id]![size] = TextEditingController(text: "");
                }
              }
            }
            notifyListeners();
          },
          selectedProducts: selectedProducts,
        );
      },
    );
  }

  void updateTotalQuantities() {
    int totalIncrease = 0;
    int totalDecrease = 0;

    quantityControllers.forEach((productId, sizeControllers) {
      sizeControllers.forEach((size, controller) {
        int value = int.tryParse(controller.text) ?? 0;
        if (value > 0) {
          totalIncrease += value;
        } else if (value < 0) {
          totalDecrease += value.abs();
        }
      });
    });

    increaseAmount = totalIncrease;
    decreaseAmount = totalDecrease;

    notifyListeners();
  }

  String generateGanId(int currentId) {
    final String formattedId = currentId.toString().padLeft(6, '0');
    return 'GAN$formattedId';
  }

  Future<void> saveCurrentId(int currentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentId', currentId);
  }

  Future<int> loadCurrentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('currentId') ?? 1;
  }

  Future<void> sendGan(
      BuildContext context, List<GANDetail> details, String staffId) async {
    isLoading = true;
    notifyListeners();

    int currentId = await loadCurrentId();

    String newGanId = generateGanId(currentId);

    final Map<String, dynamic> ganData = {
      'ganId': newGanId,
      'sId': staffId,
      'date': DateTime.now().toIso8601String(),
      'increasedQuantity': increaseAmount,
      'descreaedQuantity': decreaseAmount,
      'note': noteController.text,
      'details': details.map((details) {
        return {
          'ganId': newGanId,
          'pid': details.productId,
          'size': details.size,
          'oldQuantity': details.oldQuantity,
          'newQuantity': details.newQuantity
        };
      }).toList(),
    };

    try {
      final response = await http.post(Uri.parse(uriAPIService.apiUrlGan),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(ganData));

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomToast(context, 'Đã điều chỉnh');
      } else {
        showCustomToast(context, 'Điều chỉnh không thành công');
      }
    } catch (error) {
      print('Error sending data: $error');
      showCustomToast(context, 'Điều chỉnh không thành công');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProductQuantities(List<GANDetail> details) async {
    for (var detail in details) {
      try {
        final urlGet =
            Uri.parse('${uriAPIService.apiUrlProduct}/${detail.productId}');
        final responseGet = await http.get(urlGet);

        if (responseGet.statusCode == 200) {
          final apiResponse = jsonDecode(responseGet.body);

          if (!apiResponse.containsKey("product") ||
              apiResponse["product"] == null) {
            print("Không tìm thấy sản phẩm ${detail.productId}");
            continue;
          }

          final productData = apiResponse["product"];

          final sizeIndex = productData['sizes'].indexOf(detail.size[0]);
          if (sizeIndex == -1) {
            print(
                'Size ${detail.size[0]} not found for product ${detail.productId}');
          }

          productData['quantities'][sizeIndex] = detail.newQuantity;

          final urlPut =
              Uri.parse('${uriAPIService.apiUrlProduct}/${detail.productId}');
          final responsePut = await http.put(
            urlPut,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(productData),
          );

          if (responsePut.statusCode == 200 || responsePut.statusCode == 204) {
            if (kDebugMode) {
              print('Product ${detail.productId} updated successfully');
            }
          } else {
            if (kDebugMode) {
              print(
                  'Failed to update product ${detail.productId}: ${responsePut.statusCode}');
            }
            if (kDebugMode) {
              print('Response: ${responsePut.body}');
            }
          }
        } else {
          if (kDebugMode) {
            print(
                'Failed to fetch product ${detail.productId}: ${responseGet.statusCode}');
          }
        }
      } catch (error) {
        if (kDebugMode) {
          print('Error updating product ${detail.productId}: $error');
        }
      }
    }
  }

  void clearForm() {
    selectedProducts.clear();
    quantityControllers.clear();
    noteController.clear();
    increaseAmount = 0;
    decreaseAmount = 0;
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
