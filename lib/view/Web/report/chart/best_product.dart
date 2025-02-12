import 'package:dacntt1_mobile_admin/shared/core/theme/colors_app.dart';
import 'package:flutter/material.dart';

class BestProductList extends StatelessWidget {
  final List<MapEntry<String, int>> bestSellingSizes;

  const BestProductList({super.key, required this.bestSellingSizes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sản phẩm bán chạy nhất theo kích thước',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: bestSellingSizes.length,
            itemBuilder: (context, index) {
              final entry = bestSellingSizes[index];
              List<String> parts = entry.key.split('-'); // Tách productId và size
              String productId = parts[0];
              String size = parts.length > 1 ? parts[1] : "N/A";

              return ListTile(
                title: Text(
                  "$productId",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.titleColor),
                ),
                subtitle: Text("Kích thước: $size"),
                trailing: Text(
                  "Đã bán: ${entry.value}",
                  style: const TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
