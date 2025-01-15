import 'package:flutter/material.dart';

class Variants extends StatelessWidget {
  final List<Map<String, dynamic>> variants;
  final Function(Map<String, dynamic>) onEditVariant;

  const Variants({
    super.key,
    required this.variants,
    required this.onEditVariant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ...variants.map((variant) {
            return ListTile(
              title: Text('Kích thước: ${variant['size']}'),
              subtitle: Text('Giá: ${variant['price']} - Số lượng: ${variant['quantity']}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEditVariant(variant),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
