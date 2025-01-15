import 'package:flutter/material.dart';
import 'widget/general_container.dart';
import 'widget/add_image.dart';
import 'widget/pricing.dart';
import 'widget/product_management.dart';
import 'widget/varients.dart';
import '../../../../shared/core/theme/colors_app.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController basepriceController = TextEditingController();
  TextEditingController sellingpriceController = TextEditingController();


  String? selectedAttribute;
  String? selectedWarehouse;

  final List<String> attributeOptions = ['Nam', 'Nữ', 'Giftset', 'Unisex', 'Mini size'];

  final List<Map<String, dynamic>> variants = [
    {'size': '500ml', 'price': 100000, 'quantity': 50},
    {'size': '750ml', 'price': 150000, 'quantity': 30},
  ];

  void _editVariant(Map<String, dynamic> variant) async {
    final result = await showPricingDialog(
      context,
      TextEditingController(text: variant['price'].toString()),
      TextEditingController(text: variant['quantity'].toString()),
    );

    if (result != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          variant['price'] = int.tryParse(result['basePrice']) ?? variant['price'];
          variant['quantity'] = int.tryParse(result['sellingPrice']) ?? variant['quantity'];
        });
      });
    }
  }

  void _saveProduct() {
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:5, left: 5, right: 5, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

              const SizedBox(height: 20),

              GeneralInfo(
                nameController: nameController,
                supplierController: supplierController,
                notesController: TextEditingController(),
                desController: desController,
                initialSelectedAttribute: selectedAttribute,
              ),

              const SizedBox(height: 20),

              ImageUpload(
                onAddImage: () {},
                onAddFromURL: () {},
              ),

              const SizedBox(height: 20),

              InventoryManagement(
                skuController: skuController,
                barcodeController: barcodeController,
              ),
              const SizedBox(height: 20),

              Variants(),
            ],
          ),
        ),
      ),
    );
  }
}
