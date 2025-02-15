import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../data/product.dart';
import '../../../../view_model/product_detail.dart';
import 'widget/general_container.dart';
import 'widget/price_container.dart';
import 'widget/add_image.dart';
import 'widget/variants.dart';
import '../../../../shared/core/theme/colors_app.dart';

class ProductDetailView extends StatefulWidget {
  final Product product;
  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final productDetailModel = Provider.of<ProductDetailModel>(context, listen: false);
    productDetailModel.loadProduct(widget.product);
    print('sản phẩm: ${widget.product.toString()}');
  }


  @override
  Widget build(BuildContext context) {

    final productDetailModel = Provider.of<ProductDetailModel>(context);

    if (productDetailModel.variants.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                    onPressed:() => productDetailModel.updateProduct(context, widget.product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Màu nền
                      foregroundColor: Colors.white, // Màu chữ
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
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
                nameController: productDetailModel.nameController,
                supplierController: productDetailModel.supplierController,
                notesController: productDetailModel.notesController,
                origin: productDetailModel.originController,
                desController: productDetailModel.desController,
                usageController: productDetailModel.usageController,
                selectedAttribute: productDetailModel.selectedAttribute,
                attributeOptions: productDetailModel.attributeOptions,
                onAttributeChanged: (value) {
                  setState(() {
                    productDetailModel.selectedAttribute = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ImageUpload(
                urlController: productDetailModel.imageUrl,
              ),
              const SizedBox(height: 20),
              Variants(
                variants: productDetailModel.variants,
                onEditVariant: (variant) {
                  productDetailModel.editPricing(variant, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
