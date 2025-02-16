import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../data/product.dart';
import '../../shared/core/services/uriApi.dart';
import '../../view/Web/product/product_detail/widget/price_container.dart';

class ProductDetailModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();

  TextEditingController nameController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController usageController = TextEditingController();

  TextEditingController basePriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();

  String? selectedAttribute;
  final List<String> attributeOptions = [
    'Nam',
    'Nữ',
    'Giftset',
    'Unisex',
    'Mini size'
  ];

  List<Map<String, dynamic>> variants = [];

  TextEditingController imageUrl = TextEditingController();

  void _onVariantsChanged(List<Map<String, dynamic>> updatedVariants) {
    variants = updatedVariants;
    notifyListeners();
  }

  late Product product;

  bool isLoading = false;

  void loadProduct(Product newProduct) {
    product = newProduct;

    nameController.text = product.name;
    supplierController.text = product.supplier;
    notesController.text = product.notes.toString();
    originController.text = product.origin;
    desController.text = product.description;
    usageController.text = product.usage.toString();
    selectedAttribute =
        product.category.isNotEmpty ? product.category.first : null;

    imageUrl.text = product.image;

    variants = product.sizes.asMap().entries.map((entry) {
      return {
        'size': entry.value,
        'basePrice': product.actualPrices[entry.key],
        'sellingPrice': product.sellPrices[entry.key],
        'quantity': product.quantities[entry.key],
      };
    }).toList();

    notifyListeners();
  }

  Future<void> updateProduct(BuildContext context, Product product) async {
    isLoading = true;
    notifyListeners();

    try {
      final urlGet = Uri.parse('${uriAPIService.apiUrlProduct}/${product.id}');
      final responseGet = await http.get(urlGet);

      if (responseGet.statusCode == 200) {
        final apiResponse = jsonDecode(responseGet.body);

        if (!apiResponse.containsKey("product") ||
            apiResponse["product"] == null) {
          print("Không tìm thấy sản phẩm ${product.id}");
          return;
        }

        final productData = apiResponse["product"];

        final List<String> usage = usageController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        final List<String> notes = notesController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        productData["name"] = nameController.text;
        productData["supplier"] = supplierController.text;
        productData["notes"] = notes;
        productData["origin"] = originController.text;
        productData["description"] = desController.text;
        productData["usage"] = usage;
        productData["category"] =
            selectedAttribute != null ? [selectedAttribute] : [];
        productData["image"] = imageUrl.text;

        for (var variant in variants) {
          final sizeIndex = productData['sizes'].indexOf(variant['size']);
          if (sizeIndex != -1) {
            productData['actualPrices'][sizeIndex] = variant['basePrice'];
            productData['sellPrices'][sizeIndex] = variant['sellingPrice'];
            productData['quantities'][sizeIndex] = variant['quantity'];
          } else {
            print(
                'Size ${variant['size']} không tồn tại trong sản phẩm ${product.id}');
          }
        }

        print("Dữ liệu sản phẩm sau khi cập nhật: $productData");

        final urlPut =
            Uri.parse('${uriAPIService.apiUrlProduct}/${product.id}');
        final responsePut = await http.put(
          urlPut,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(productData),
        );

        if (responsePut.statusCode == 200 || responsePut.statusCode == 204) {
          showCustomToast(context, 'Cập nhật sản phẩm thành công');
          if (kDebugMode) {
            print('Sản phẩm ${product.id} cập nhật thành công');
          }
        } else {
          showCustomToast(context, 'Cập nhật sản phẩm thất bại');
          if (kDebugMode) {
            print(
                'Lỗi khi cập nhật sản phẩm ${product.id}: ${responsePut.statusCode}');
          }
          if (kDebugMode) {
            print('Response: ${responsePut.body}');
          }
        }
      } else {
        if (kDebugMode) {
          print(
              'Lỗi khi lấy sản phẩm ${product.id}: ${responseGet.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        showCustomToast(context, 'Cập nhật sản phẩm thất bại');
        print('Lỗi khi cập nhật sản phẩm ${product.id}: $error');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void editPricing(Map<String, dynamic> variant, BuildContext context) {
    basePriceController.text = variant['basePrice'].toString();
    sellingPriceController.text = variant['sellingPrice'].toString();

    showPricingDialog(context, basePriceController, sellingPriceController)
        .then((result) {
      if (result != null) {
        variant['basePrice'] =
            int.tryParse(result['basePrice']) ?? variant['basePrice'];
        variant['sellingPrice'] =
            int.tryParse(result['sellingPrice']) ?? variant['sellingPrice'];
        notifyListeners();
      }
    });
  }


  String formatPrice(double price) {
    final format = NumberFormat("#,##0", "en_US");
    return format.format(price);
  }

  String formatCustomerPayInput(String value) {
    String newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    final format = NumberFormat("#,###", "en_US");
    return format.format(int.tryParse(newValue) ?? 0);
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
