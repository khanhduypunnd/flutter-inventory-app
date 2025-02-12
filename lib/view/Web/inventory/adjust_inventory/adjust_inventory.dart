import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../shared/core/services/uriApi.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../popup/search_product.dart';
import '../../../../data/gan.dart';
import '../../../../data/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdjustInventory extends StatefulWidget {
  @override
  _AdjustInventoryState createState() => _AdjustInventoryState();
}

class _AdjustInventoryState extends State<AdjustInventory> {
  final ApiService uriAPIService = ApiService();

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool isLoading = false;

  List<Product> _allProducts = [];
  List<Product> _searchResults = [];
  List<Product> _selectedProducts = [];
  Map<String, Map<String, TextEditingController>> _quantityControllers = {};

  int increaseAmount = 0;
  int decreaseAmount = 0;

  String sId = 'S0001';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(uriAPIService.apiUrlProduct);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          _allProducts =
              jsonData.map((data) => Product.fromJson(data)).toList();
          _searchResults = _allProducts;
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

  void _searchProduct(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _allProducts
            .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showSearchResults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SearchResultsDialog(
          searchResults: _searchResults,
          onSelect: (Product product, List<String> selectedSizes) {
            setState(() {
              for (var size in selectedSizes) {
                if (!_selectedProducts
                    .any((p) => p.id == product.id && p.sizes.contains(size))) {
                  _selectedProducts.add(Product(
                    id: product.id,
                    name: product.name,
                    supplier: product.supplier,
                    category: product.category,
                    usage: product.usage,
                    origin: product.origin,
                    description: product.description,
                    notes: product.notes,
                    sizes: [size],
                    actualPrices: [0],
                    sellPrices: [0],
                    quantities: [0],
                    image: product.image,
                    averageRating: product.averageRating,
                    totalReviews: product.totalReviews,
                  ));

                  if (!_quantityControllers.containsKey(product.id)) {
                    _quantityControllers[product.id] = {};
                  }
                  _quantityControllers[product.id]![size] =
                      TextEditingController(text: "");
                }
              }
            });
          },
          selectedProducts: _selectedProducts,
        );
      },
    );
  }

  void _updateTotalQuantities() {
    int totalIncrease = 0;
    int totalDecrease = 0;

    _quantityControllers.forEach((productId, sizeControllers) {
      sizeControllers.forEach((size, controller) {
        int value = int.tryParse(controller.text) ?? 0;
        if (value > 0) {
          totalIncrease += value;
        } else if (value < 0) {
          totalDecrease += value.abs();
        }
      });
    });

    setState(() {
      increaseAmount = totalIncrease;
      decreaseAmount = totalDecrease;
    });
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

  Future<void> _sendGan(List<GANDetail> details) async {
    int currentId = await loadCurrentId();

    String newGanId = generateGanId(currentId);

    final Map<String, dynamic> ganData = {
      'ganId': newGanId,
      'sId': sId,
      'date': DateTime.now().toIso8601String(),
      'increasedQuantity': increaseAmount,
      'descreaedQuantity': decreaseAmount,
      'note': _noteController.text,
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
      final response =
      await http.post(Uri.parse(uriAPIService.apiUrlGan),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(ganData));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('Data sent successfully: ${response.body}');
        }

        currentId++;
        await saveCurrentId(currentId);
      } else {
        if (kDebugMode) {
          print('Failed to send data: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error sending data: $error');
      }
    }
  }

  // Future<void> _updateProductQuantities(List<GANDetail> details) async {
  //   for (var detail in details) {
  //     try {
  //
  //       final urlGet = Uri.parse('${uriAPIService.apiUrlProduct}/${detail.productId}');
  //       final responseGet = await http.get(urlGet);
  //
  //       if (responseGet.statusCode == 200) {
  //         final productData = jsonDecode(responseGet.body);
  //
  //         final sizeIndex = productData['sizes'].indexOf(detail.size[0]);
  //         if (sizeIndex == -1) {
  //           print('Size ${detail.size[0]} not found for product ${detail.productId}');
  //         }
  //
  //         productData['quantities'][sizeIndex] = detail.newQuantity;
  //
  //         print(productData);
  //
  //         final urlPut = Uri.parse('${uriAPIService.apiUrlProduct}/${detail.productId}');
  //         final responsePut = await http.put(
  //           urlPut,
  //           headers: {
  //             'Content-Type': 'application/json',
  //           },
  //           body: jsonEncode(productData),
  //         );
  //
  //         if (responsePut.statusCode == 200 || responsePut.statusCode == 204) {
  //           if (kDebugMode) {
  //             print('Product ${detail.productId} updated successfully');
  //           }
  //         } else {
  //           if (kDebugMode) {
  //             print('Failed to update product ${detail.productId}: ${responsePut.statusCode}');
  //           }
  //           if (kDebugMode) {
  //             print('Response: ${responsePut.body}');
  //           }
  //         }
  //       } else {
  //         if (kDebugMode) {
  //           print('Failed to fetch product ${detail.productId}: ${responseGet.statusCode}');
  //         }
  //       }
  //     } catch (error) {
  //       if (kDebugMode) {
  //         print('Error updating product ${detail.productId}: $error');
  //       }
  //     }
  //   }
  // }
  //

  Future<void> _updateProductQuantities(List<GANDetail> details) async {
    for (var detail in details) {
      try {
        final urlGet = Uri.parse('${uriAPIService.apiUrlProduct}/${detail.productId}');
        final responseGet = await http.get(urlGet);

        if (responseGet.statusCode == 200) {
          final apiResponse = jsonDecode(responseGet.body);

          if (!apiResponse.containsKey("product") || apiResponse["product"] == null) {
            print("⚠ Không tìm thấy sản phẩm ${detail.productId}");
            continue;
          }

          final productData = apiResponse["product"];

          final sizeIndex = productData['sizes'].indexOf(detail.size[0]);
          if (sizeIndex == -1) {
            print('Size ${detail.size[0]} not found for product ${detail.productId}');
          }

          productData['quantities'][sizeIndex] = detail.newQuantity;
          print(productData);

          final urlPut = Uri.parse('${uriAPIService.apiUrlProduct}/${detail.productId}');
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
              print('Failed to update product ${detail.productId}: ${responsePut.statusCode}');
            }
            if (kDebugMode) {
              print('Response: ${responsePut.body}');
            }
          }
        } else {
          if (kDebugMode) {
            print('Failed to fetch product ${detail.productId}: ${responseGet.statusCode}');
          }
        }
      } catch (error) {
        if (kDebugMode) {
          print('Error updating product ${detail.productId}: $error');
        }
      }
    }
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


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _searchProduct,
                          decoration: InputDecoration(
                            labelText: 'Tìm kiếm sản phẩm',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: _showSearchResults,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Text(
                      'Sản phẩm đã chọn',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.titleColor),
                    ),
                    Flexible(
                      child: ListView.builder(
                        itemCount: _selectedProducts.length,
                        itemBuilder: (context, index) {
                          final product = _selectedProducts[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          _selectedProducts.removeAt(index);
                                          _quantityControllers.remove(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: product.sizes.length,
                                  itemBuilder: (context, sizeIndex) {
                                    final size = product.sizes[sizeIndex];
                                    final actualQuantity = int.tryParse(product
                                        .quantities[sizeIndex]
                                        .toString()) ??
                                        0;
                                    int adjustedQuantity = int.tryParse(
                                        _quantityControllers[index]
                                        ?[sizeIndex]
                                            ?.text ??
                                            '0') ??
                                        0;
                                    return Row(
                                      children: [
                                        Text(
                                          "$size",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "Tồn kho: $actualQuantity",
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "Tồn thực tế: ${actualQuantity + (int.tryParse(_quantityControllers[product.id]![size]?.text ?? '0') ?? 0)}",
                                          style: const TextStyle(
                                              color: Colors.blueAccent),
                                        ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 50,
                                          child: TextFormField(
                                            controller: _quantityControllers[
                                            product.id]![size],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _updateTotalQuantities();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 50),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Số lượng lệch tăng",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                Text(
                                  "$increaseAmount",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Số lượng lệch giảm",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                Text(
                                  " - $decreaseAmount",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Ghi chú',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.subtitleColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextFormField(
                              maxLines: 5,
                              controller: _noteController,
                              decoration: InputDecoration(
                                hintText: 'Nhập ghi chú',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 2),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  List<GANDetail> ganDetails = [];

                                  int currentId = await loadCurrentId();
                                  String newGanId = generateGanId(currentId);

                                  for (var product in _selectedProducts) {
                                    for (var sizeIndex = 0; sizeIndex < product.sizes.length; sizeIndex++) {
                                      String size = product.sizes[sizeIndex];
                                      int oldQuantity = product.quantities[sizeIndex];
                                      int adjustedQuantity = int.tryParse(
                                          _quantityControllers[product.id]?[size]?.text ?? '0') ??
                                          0;
                                      int newQuantity = oldQuantity + adjustedQuantity;

                                      ganDetails.add(
                                        GANDetail(
                                          ganId: newGanId,
                                          productId: product.id,
                                          size: [size],
                                          oldQuantity: oldQuantity,
                                          newQuantity: newQuantity,
                                        ),
                                      );

                                      setState(() {
                                        product.quantities[sizeIndex] = newQuantity;
                                      });
                                    }
                                  }

                                  try {
                                    await _sendGan(ganDetails);

                                    await _updateProductQuantities(ganDetails);

                                    showCustomToast(context, 'Lưu thành công và cập nhật số lượng sản phẩm!');

                                    setState(() {
                                      _selectedProducts.clear();
                                      _quantityControllers.clear();
                                      _noteController.clear();
                                      increaseAmount = 0;
                                      decreaseAmount = 0;
                                    });
                                  } catch (error) {
                                    showCustomToast(context, 'Lưu thất bại: $error');
                                  }
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text(
                                  'Lưu',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
