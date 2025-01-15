import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';

class PricingDialog extends StatefulWidget {
  final TextEditingController basepriceController;
  final TextEditingController sellingpriceController;

  const PricingDialog({
    super.key,
    required this.basepriceController,
    required this.sellingpriceController,
  });

  @override
  _PricingDialogState createState() => _PricingDialogState();
}

class _PricingDialogState extends State<PricingDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Chỉnh sửa giá',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.titleColor),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.basepriceController,
              decoration: InputDecoration(
                labelText: 'Giá vốn',
                hintText: 'Nhập giá vốn',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.sellingpriceController,
              decoration: InputDecoration(
                labelText: 'Giá bán',
                hintText: 'Nhập giá bán',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy', style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop({
                      'basePrice': widget.basepriceController.text,
                      'sellingPrice': widget.sellingpriceController.text,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: const Text('Lưu'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>?> showPricingDialog(
    BuildContext context,
    TextEditingController basepriceController,
    TextEditingController sellingpriceController,
    ) async {
  return await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return PricingDialog(
        basepriceController: basepriceController,
        sellingpriceController: sellingpriceController,
      );
    },
  );
}

