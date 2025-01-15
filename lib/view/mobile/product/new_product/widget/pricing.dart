import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';

class PricingDialog extends StatelessWidget {
  final TextEditingController basepriceController;
  final TextEditingController sellingpriceController;

  const PricingDialog({
    super.key,
    required this.basepriceController,
    required this.sellingpriceController,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Chỉnh sửa giá',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.titleColor),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: basepriceController,
              decoration: InputDecoration(
                labelText: 'Giá vốn',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: sellingpriceController,
              decoration: InputDecoration(
                labelText: 'Giá bán',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop({
                      'basePrice': basepriceController.text,
                      'sellingPrice': sellingpriceController.text,
                    });
                  },
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

