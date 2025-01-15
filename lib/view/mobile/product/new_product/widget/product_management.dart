import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';

class InventoryManagement extends StatefulWidget {
  final TextEditingController skuController;
  final TextEditingController barcodeController;

  const InventoryManagement({
    super.key,
    required this.skuController,
    required this.barcodeController,
  });

  @override
  _InventoryManagementState createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Quản lý sản phẩm',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.titleColor),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.skuController,
            decoration: InputDecoration(
              hintText: 'SKU',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.barcodeController,
            decoration: InputDecoration(
              hintText: 'Barcode',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
        ],
      ),
    );
  }
}
