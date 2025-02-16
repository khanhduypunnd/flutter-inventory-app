import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../view_model/product/new_product.dart';
import 'widget/general_container.dart';
import 'widget/add_image.dart';
import 'widget/varients.dart';
import '../../../../shared/core/theme/colors_app.dart';

class NewProduct extends StatefulWidget {
  final Map<String, dynamic>? staffData;
  const NewProduct({super.key, this.staffData});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  @override
  Widget build(BuildContext context) {
    final newProductModel = Provider.of<NewProductModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nút lưu
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => newProductModel.onSave(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
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
                nameController: newProductModel.nameController,
                supplierController: newProductModel.supplierController,
                notesController: newProductModel.notesController,
                origin: newProductModel.originController,
                desController: newProductModel.desController,
                usageController: newProductModel.usageController,
                selectedAttribute: newProductModel.selectedAttribute,
                attributeOptions: newProductModel.attributeOptions,
                onAttributeChanged: (value) {
                  setState(() {
                    newProductModel.selectedAttribute = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ImageUpload(
                onAddFromURL: (String url) {
                  setState(() {
                    newProductModel.imageUrl = url;
                  });
                },
              ),
              const SizedBox(height: 20),
              Variants(
                variants: newProductModel.variants,
                onVariantsChanged: newProductModel.onVariantsChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
