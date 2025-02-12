import 'package:flutter/material.dart';
import '../../../../shared/core/services/uriApi.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../../../../../data/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  final ApiService uriAPIService = ApiService();

  late int rowsPerPage = 20;
  int currentPage = 1;
  int totalProducts = 0;
  List<dynamic> products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(uriAPIService.apiUrlProduct);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // print('API Response: ${response.body}');
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          products = jsonData.map((data) {
            return Product.fromJson(data);
          }).toList();
          totalProducts = products.length;
        });
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải sản phẩm: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  void _updateProductsByPage(int pageIndex) {
    setState(() {
      currentPage = pageIndex;
    });
  }

  List<dynamic> _getPaginatedProducts() {
    int startIndex = (currentPage - 1) * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    return products.sublist(
      startIndex,
      endIndex > products.length ? products.length : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalProducts / rowsPerPage).ceil();
    const int maxPagesToShow = 5;

    int startPage = (currentPage - maxPagesToShow ~/ 2) > 0
        ? (currentPage - maxPagesToShow ~/ 2)
        : 1;

    int endPage = startPage + maxPagesToShow - 1;
    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = totalPages - maxPagesToShow + 1;
    }

    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50, bottom: 30, top: 50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: "Tìm kiếm sản phẩm...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidth,
                    ),
                    child: DataTable(
                      columnSpacing: 50.0,
                      columns: const [
                        DataColumn(label: Text('Tên')),
                        DataColumn(label: Text('Nhà cung cấp')),
                        DataColumn(label: Text('Danh mục')),
                        DataColumn(label: Text('Tồn kho')),
                      ],
                      rows: _getPaginatedProducts().map((product) {
                        final Product prod = product as Product;
                        return DataRow(cells: [
                          DataCell(Text(prod.name)),
                          DataCell(Text(prod.supplier)),
                          DataCell(Text(prod.category.join(', '))),
                          DataCell(Text(prod.quantities.fold(0, (sum, q) => sum + q).toString())),
                        ]);
                      }).toList(),
            
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PopupMenuButton<int>(
                      onSelected: (value) {
                        setState(() {
                          rowsPerPage = value;
                          currentPage = 1;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem<int>(
                            value: 10,
                            child: Text("Hiển thị 10"),
                          ),
                          const PopupMenuItem<int>(
                            value: 20,
                            child: Text("Hiển thị 20"),
                          ),
                          const PopupMenuItem<int>(
                            value: 50,
                            child: Text("Hiển thị 50"),
                          ),
                        ];
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Text("Hiển thị $rowsPerPage",
                                style: const TextStyle(fontSize: 16)),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.first_page),
                          onPressed: currentPage > 1
                              ? () {
                            _updateProductsByPage(1);
                          }
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: currentPage > 1
                              ? () {
                            _updateProductsByPage(currentPage - 1);
                          }
                              : null,
                        ),
                        Row(
                          children: List.generate(
                            totalPages,
                                (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentPage == index + 1
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  foregroundColor: currentPage == index + 1
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                onPressed: () {
                                  _updateProductsByPage(index + 1);
                                },
                                child: Text('${index + 1}'),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: currentPage < totalPages
                              ? () {
                            _updateProductsByPage(currentPage + 1);
                          }
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.last_page),
                          onPressed: currentPage < totalPages
                              ? () {
                            _updateProductsByPage(totalPages);
                          }
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
