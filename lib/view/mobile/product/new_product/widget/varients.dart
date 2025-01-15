import 'package:flutter/material.dart';

class Variants extends StatefulWidget {
  const Variants({super.key});

  @override
  State<Variants> createState() => _VariantsState();
}

class _VariantsState extends State<Variants> {
  final List<Map<String, dynamic>> variants = [];
  bool isAdding = false; // Hiển thị form nhập nếu là true
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController basePriceController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();

  void _addVariant() {
    setState(() {
      isAdding = true;
    });
  }

  void _saveVariant() {
    setState(() {
      variants.add({
        'size': sizeController.text,
        'basePrice': int.tryParse(basePriceController.text) ?? 0,
        'sellingPrice': int.tryParse(sellingPriceController.text) ?? 0,
      });
      sizeController.clear();
      basePriceController.clear();
      sellingPriceController.clear();
      isAdding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Danh sách biến thể',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          variants.isNotEmpty
              ? ListView.builder(
            shrinkWrap: true,
            itemCount: variants.length,
            itemBuilder: (context, index) {
              final variant = variants[index];
              return ListTile(
                title: Text('Kích thước: ${variant['size']}'),
                subtitle: Text(
                  'Giá vốn: ${variant['basePrice']} - Giá bán: ${variant['sellingPrice']}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      variants.removeAt(index);
                    });
                  },
                ),
              );
            },
          )
              : const Center(
            child: Text(
              'Chưa có biến thể nào.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),

          // Hiển thị form thêm biến thể
          if (isAdding)
            Column(
              children: [
                TextFormField(
                  controller: sizeController,
                  decoration: InputDecoration(
                    labelText: 'Kích thước',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: basePriceController,
                  decoration: InputDecoration(
                    labelText: 'Giá vốn',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: sellingPriceController,
                  decoration: InputDecoration(
                    labelText: 'Giá bán',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _saveVariant,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Lưu'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isAdding = false;
                        });
                      },
                      child: const Text('Hủy'),
                    ),
                  ],
                ),
              ],
            ),

          // Nút thêm biến thể
          if (!isAdding)
            ElevatedButton.icon(
              onPressed: _addVariant,
              icon: const Icon(Icons.add),
              label: const Text('Thêm biến thể'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
