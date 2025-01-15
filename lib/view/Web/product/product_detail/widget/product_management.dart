import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';

class InventoryManagement extends StatefulWidget {
  final TextEditingController skuController;
  final TextEditingController barcodeController;
  final String? selectedWarehouse;
  final List<String> warehouseOptions;
  final Function(String?) onWarehouseChanged;

  const InventoryManagement({
    super.key,
    required this.skuController,
    required this.barcodeController,
    required this.selectedWarehouse,
    required this.warehouseOptions,
    required this.onWarehouseChanged,
  });

  @override
  _InventoryManagementState createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement> {
  late double maxWidth;
  late bool isWideScreen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
    isWideScreen = maxWidth > 700;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          const BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Quản lý tồn kho',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.titleColor),
            ),
          ),
          const SizedBox(height: 20),
          isWideScreen
              ? Row(
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    TextFormField(
                      controller: widget.skuController,
                      decoration: InputDecoration(
                        hintText: 'SKU',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    TextFormField(
                      controller: widget.barcodeController,
                      decoration: InputDecoration(
                        hintText: 'Barcode',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
              : Column(
            children: [
              TextFormField(
                controller: widget.skuController,
                decoration: InputDecoration(
                  hintText: 'SKU',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: widget.barcodeController,
                decoration: InputDecoration(
                  hintText: 'Barcode',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
