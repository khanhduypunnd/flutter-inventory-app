import 'package:flutter/material.dart';
import '../../../../data/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: BestProductList()),
      ),
    );
  }
}

class BestProductList extends StatelessWidget {
  BestProductList({super.key});

  final List<Product> products = [
    // Product(
    //   id: '1',
    //   name: 'NAR CRISTAL',
    //   supplier: 'NAR Supplier',
    //   description: 'Nước hoa cao cấp dành cho nữ.',
    //   category: ['Nước hoa'],
    //   origin: 'Pháp',
    //   usage: ['Xịt vào cổ tay', 'Sau tai để lưu hương lâu'],
    //   notes: [], // Thêm giá trị mặc định
    //   sizes: ['50ml', '100ml'], // Sửa thành danh sách
    //   salePrices: ['2,530,000 đ', '4,530,000 đ'], // Sửa thành danh sách
    //   actualPrices: ['2,200,000 đ', '4,000,000 đ'], // Sửa thành danh sách
    //   quantities: ['20', '10'], // Sửa thành danh sách
    //   image: 'https://example.com/images/nar_cristal.png',
    //   averageRating: '4.5',
    //   totalReviews: '120',
    // ),
    // Product(
    //   id: '1',
    //   name: 'NAR CRISTAL',
    //   supplier: 'NAR Supplier',
    //   description: 'Nước hoa cao cấp dành cho nữ.',
    //   category: ['Nước hoa'],
    //   origin: 'Pháp',
    //   usage: ['Xịt vào cổ tay', 'Sau tai để lưu hương lâu'],
    //   notes: [], // Thêm giá trị mặc định
    //   sizes: ['50ml', '100ml'], // Sửa thành danh sách
    //   salePrices: ['2,530,000 đ', '4,530,000 đ'], // Sửa thành danh sách
    //   actualPrices: ['2,200,000 đ', '4,000,000 đ'], // Sửa thành danh sách
    //   quantities: ['20', '10'], // Sửa thành danh sách
    //   image: 'https://example.com/images/nar_cristal.png',
    //   averageRating: '4.5',
    //   totalReviews: '120',
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sản phẩm bán chạy',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              product.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: product.sizes.length,
                          itemBuilder: (context, sizeIndex) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Size: ${product.sizes[sizeIndex]}"),
                                Text("Giá: ${product.sellPrices[sizeIndex]}"),
                                Text(
                                    "Tồn kho: ${product.quantities[sizeIndex]}"),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
