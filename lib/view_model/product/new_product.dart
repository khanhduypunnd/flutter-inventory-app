import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/core/services/uriApi.dart';

class NewProductModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();

  TextEditingController nameController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController usageController = TextEditingController();

  String? selectedAttribute;
  final List<String> attributeOptions = [
    'Nam',
    'Nữ',
    'Giftset',
    'Unisex',
    'Mini size'
  ];

  List<Map<String, dynamic>> variants = [];

  String? imageUrl;

  void onVariantsChanged(List<Map<String, dynamic>> updatedVariants) {
    variants = updatedVariants;
    notifyListeners();
  }

  String generateRandomCode(int length) {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  Future<void> onSave(BuildContext context) async {
    final String name = nameController.text.trim();
    final String supplier = supplierController.text.trim();
    final String description = desController.text.trim();
    final String origin = originController.text.trim();

    final List<String> usage = usageController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (name.isEmpty ||
        supplier.isEmpty ||
        description.isEmpty ||
        origin.isEmpty) {
      showCustomToast(context, 'Vui lòng điền đầy đủ thông tin sản phẩm!');
      notifyListeners();
      return;
    }

    if (variants.isEmpty) {
      showCustomToast(context, 'Vui lòng thêm ít nhất một biến thể!');
      notifyListeners();
      return;
    }

    final List<String> sizes = variants
        .map((variant) => variant['size']?.toString().trim() ?? '')
        .where((size) => size.isNotEmpty)
        .toList();

    final List<int> actualPrices = variants
        .map((variant) {
          final price = int.tryParse(variant['basePrice'].toString());
          return price != null && price > 0 ? price : null;
        })
        .whereType<int>()
        .toList();

    final List<int> sellPrices = variants
        .map((variant) {
          final price = int.tryParse(variant['sellingPrice'].toString());
          return price != null && price > 0 ? price : null;
        })
        .whereType<int>()
        .toList();

    final List<int> quantities = variants.map((variant) {
      final quantity = int.tryParse(variant['quantity'].toString());
      return quantity != null && quantity >= 0 ? quantity : 0;
    }).toList();

    if (sizes.isEmpty ||
        actualPrices.isEmpty ||
        sellPrices.isEmpty ||
        quantities.isEmpty) {
      showCustomToast(context, 'Vui lòng điền đầy đủ thông tin biến thể!');
      notifyListeners();
      return;
    }

    final Map<String, dynamic> productData = {
      'pid': generateRandomCode(20),
      'name': name,
      'supplier': supplier,
      'description': description,
      'category': [selectedAttribute ?? ''],
      'origin': origin,
      'usage': usage,
      'sizes': sizes,
      'actualPrices': actualPrices,
      'sellPrices': sellPrices,
      'quantities': quantities,
      'image': imageUrl,
      'notes': notesController.text
          .split(',')
          .map((note) => note.trim())
          .where((note) => note.isNotEmpty)
          .toList(),
      'averageRating': 0,
      'totalReviews': 0,
    };

    print('Dữ liệu sản phẩm gửi lên: $productData');

    try {
      await _sendProductData(productData);
      showCustomToast(context, 'Sản phẩm đã được lưu thành công!');

      _clearForm();
    } catch (e) {
      showCustomToast(context, 'Lỗi khi lưu sản phẩm: $e');
    }
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

    // Remove the toast after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  Future<void> _sendProductData(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse(uriAPIService.apiUrlProduct),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      if (response.statusCode == 201) {
        print('Sản phẩm được lưu thành công!');
        print('Phản hồi từ server: ${response.body}');
      } else {
        print('Lỗi khi lưu sản phẩm. Mã lỗi: ${response.statusCode}');
        print('Phản hồi từ server: ${response.body}');
      }
    } catch (error) {
      print('Lỗi kết nối tới server: $error');
    }
  }

  void _clearForm() {
    nameController.clear();
    supplierController.clear();
    notesController.clear();
    originController.clear();
    desController.clear();
    imageUrl = '';
    usageController.clear();
    variants.clear();
    selectedAttribute = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    supplierController.dispose();
    notesController.dispose();
    originController.dispose();
    desController.dispose();
    usageController.dispose();
    super.dispose();
  }
}
