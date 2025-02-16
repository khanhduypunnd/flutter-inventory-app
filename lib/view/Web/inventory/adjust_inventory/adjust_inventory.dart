import 'package:dacntt1_mobile_admin/view_model/inventory/adjust_inventory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../../../../data/gan.dart';

class AdjustInventory extends StatefulWidget {
  final Map<String, dynamic>? staffData;
  const AdjustInventory({super.key, this.staffData});

  @override
  State<AdjustInventory> createState() => _AdjustInventoryState();
}

class _AdjustInventoryState extends State<AdjustInventory> {
  late String staffId = '';
  late String staffName = '';

  @override
  Widget build(BuildContext context) {
    final adjustInventoryModel = Provider.of<AdjustInventoryModel>(context);

    staffId = widget.staffData?['id'] ?? "Không có mã";
    staffName = widget.staffData?['name'] ?? "Không có tên";

    return Stack(
      children: [
        SafeArea(
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
                              controller: adjustInventoryModel.searchController,
                              onChanged: adjustInventoryModel.searchProduct,
                              decoration: InputDecoration(
                                labelText: 'Tìm kiếm sản phẩm',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () async {
                                    await adjustInventoryModel
                                        .fetchProducts(context);
                                    adjustInventoryModel.searchProduct(
                                        adjustInventoryModel.searchController.text);
                                    adjustInventoryModel.showSearchResults(context);
                                  },
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
                            itemCount: adjustInventoryModel.selectedProducts.length,
                            itemBuilder: (context, index) {
                              final product =
                              adjustInventoryModel.selectedProducts[index];
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
                                              adjustInventoryModel.selectedProducts
                                                  .removeAt(index);
                                              adjustInventoryModel
                                                  .quantityControllers
                                                  .remove(index);
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
                                            adjustInventoryModel
                                                .quantityControllers[index]
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
                                              "Tồn thực tế: ${actualQuantity + (int.tryParse(adjustInventoryModel.quantityControllers[product.id]![size]?.text ?? '0') ?? 0)}",
                                              style: const TextStyle(
                                                  color: Colors.blueAccent),
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: 50,
                                              child: TextFormField(
                                                controller: adjustInventoryModel
                                                    .quantityControllers[
                                                product.id]![size],
                                                keyboardType: TextInputType.number,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    adjustInventoryModel
                                                        .updateTotalQuantities();
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
                                      'Số lượng lệch tăng',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    Text(
                                      '${adjustInventoryModel.increaseAmount}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Số lượng lệch giảm',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    Text(
                                      ' - ${adjustInventoryModel.decreaseAmount}',
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
                                  controller: adjustInventoryModel.noteController,
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

                                      int currentId = await adjustInventoryModel
                                          .loadCurrentId();
                                      String newGanId = adjustInventoryModel
                                          .generateGanId(currentId);

                                      for (var product in adjustInventoryModel
                                          .selectedProducts) {
                                        for (var sizeIndex = 0;
                                        sizeIndex < product.sizes.length;
                                        sizeIndex++) {
                                          String size = product.sizes[sizeIndex];
                                          int oldQuantity =
                                          product.quantities[sizeIndex];
                                          int adjustedQuantity = int.tryParse(
                                              adjustInventoryModel
                                                  .quantityControllers[
                                              product.id]?[size]
                                                  ?.text ??
                                                  '0') ??
                                              0;
                                          int newQuantity =
                                              oldQuantity + adjustedQuantity;

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
                                            product.quantities[sizeIndex] =
                                                newQuantity;
                                          });
                                        }
                                      }

                                      try {
                                        await adjustInventoryModel.sendGan(
                                            context, ganDetails, staffId);

                                        await adjustInventoryModel
                                            .updateProductQuantities(ganDetails);

                                        adjustInventoryModel.showCustomToast(
                                            context,
                                            'Lưu thành công và cập nhật số lượng sản phẩm!');

                                        adjustInventoryModel.clearForm();
                                      } catch (error) {
                                        adjustInventoryModel.showCustomToast(
                                            context, 'Lưu thất bại: $error');
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
        ),

        if (adjustInventoryModel.isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.blueAccent,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
