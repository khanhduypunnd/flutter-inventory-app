import 'package:flutter/material.dart';

class Variants extends StatefulWidget {
  final List<Map<String, dynamic>> variants;
  final Function(List<Map<String, dynamic>>) onVariantsChanged;

  const Variants({
    super.key,
    required this.variants,
    required this.onVariantsChanged,
  });

  @override
  State<Variants> createState() => _VariantsState();
}

class _VariantsState extends State<Variants> {
  bool isAdding = false;
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
      widget.variants.add({
        'size': sizeController.text,
        'basePrice': int.tryParse(basePriceController.text) ?? 0,
        'sellingPrice': int.tryParse(sellingPriceController.text) ?? 0,
      });

      widget.onVariantsChanged(widget.variants);

      sizeController.clear();
      basePriceController.clear();
      sellingPriceController.clear();
      isAdding = false;
    });
  }

  // Xóa biến thể
  void _deleteVariant(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa biến thể này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.variants.removeAt(index);
                  widget.onVariantsChanged(widget.variants);
                });
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Danh sách biến thể',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          widget.variants.isNotEmpty
              ? ListView.builder(
            shrinkWrap: true,
            itemCount: widget.variants.length,
            itemBuilder: (context, index) {
              final variant = widget.variants[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('Kích thước: ${variant['size']}'),
                  subtitle: Text(
                    'Giá vốn: ${variant['basePrice']} - Giá bán: ${variant['sellingPrice']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteVariant(index),
                  ),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: basePriceController,
                  decoration: InputDecoration(
                    labelText: 'Giá vốn',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: sellingPriceController,
                  decoration: InputDecoration(
                    labelText: 'Giá bán',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
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
