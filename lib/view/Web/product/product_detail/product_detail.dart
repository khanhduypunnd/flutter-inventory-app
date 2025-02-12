import 'package:flutter/material.dart';
import 'widget/general_container.dart';
import 'widget/price_container.dart';
import 'widget/product_management.dart';
import 'widget/variants.dart';
import 'widget/add_image.dart';
import '../../../../shared/core/theme/colors_app.dart';


class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController basepriceController = TextEditingController();
  TextEditingController sellingpriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();

  String? selectedAttribute;
  String? selectedWarehouse;

  final List<String> attributeOptions = ['Nam', 'Nữ', 'Giftset', 'Unisex', 'Mini size'];

  final List<Map<String, dynamic>> fakeVariants = [
    {'size': '500ml', 'basePrice': 50000, 'sellingPrice': 60000},
    {'size': '750ml', 'basePrice': 75000, 'sellingPrice': 90000},
    {'size': '1L', 'basePrice': 100000, 'sellingPrice': 120000},
  ];

  void _editPricing(Map<String, dynamic> variant) {
    basepriceController.text = variant['basePrice'].toString();
    sellingpriceController.text = variant['sellingPrice'].toString();

    showPricingDialog(context, basepriceController, sellingpriceController).then((result) {
      if (result != null) {
        setState(() {
          variant['basePrice'] = int.tryParse(result['basePrice']) ?? variant['basePrice'];
          variant['sellingPrice'] = int.tryParse(result['sellingPrice']) ?? variant['sellingPrice'];
        });
      }
    });
  }

  void _saveProduct() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Màu nền
                      foregroundColor: Colors.white, // Màu chữ
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Lưu', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),

              GeneralInfo(
                nameController: nameController,
                supplierController: supplierController,
                notesController: notesController,
                desController: desController,
                selectedAttribute: selectedAttribute,
                attributeOptions: attributeOptions,
                onAttributeChanged: (value) => setState(() => selectedAttribute = value),
              ),
              const SizedBox(height: 20),
              ImageUpload(
                onAddImage: () {},
                onAddFromURL: () {},
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Biến thể',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ...fakeVariants.map((variant) {
                      return ListTile(
                        title: Text('Kích thước: ${variant['size']}'),
                        subtitle: Text(
                          'Giá vốn: ${variant['basePrice']} - Giá bán: ${variant['sellingPrice']}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editPricing(variant),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
