import 'package:flutter/material.dart';
import 'dart:math';
import '../../../../shared/core/theme/colors_app.dart';
import '../new_product/new_product.dart';

class ListProduct extends StatefulWidget {
  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  late int rowsPerPage = 20;
  int promotionType = 0;
  int currentPage = 1;
  int totalProducts = 682;
  List<dynamic> products = [];
  bool isLoading = false;

  int sreenLaptop = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProducts();
    });
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });


    await Future.delayed(const Duration(seconds: 1));


    int startIndex = (currentPage - 1) * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;

    List<dynamic> newProducts = List.generate(
      rowsPerPage,
          (index) => {
        "name": "Sản phẩm ${startIndex + index + 1}",
        "variants": "${(index % 5) + 1} biến thể",
        "available": (index % 20),
        "type": "Loại ${index % 3}",
        "supplier": "Nhà cung cấp ${(index % 10) + 1}",
      },
    );


    setState(() {
      products = newProducts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalProducts / rowsPerPage).ceil();
    const int maxPagesToShow = 5;

    int startPage = max(1, currentPage - maxPagesToShow ~/ 2);

    int endPage = startPage + maxPagesToShow - 1;
    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = max(1, totalPages - maxPagesToShow + 1);
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double minWidth = 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text('Danh sách sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.titleColor),),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blueAccent), // Icon cho nút
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewProduct()),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: LayoutBuilder(
          builder:(context, constraints) {
            if(constraints.maxWidth < minWidth){
              sreenLaptop = 1;
            }
            else{
              sreenLaptop = 0;
            }
            return
              SizedBox(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidth < minWidth ? minWidth : screenWidth,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: const TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: "Tìm kiếm sản phẩm...",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                            child: isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth,
                                ),
                                child: DataTable(
                                  columnSpacing: 50.0,
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Text('Tên sản phẩm'),
                                    ),
                                    DataColumn(
                                      label: Text('Khả dụng'),
                                    ),
                                    DataColumn(
                                      label: Text('Loại'),
                                    ),
                                    DataColumn(
                                      label: Text('Nhà cung cấp'),
                                    ),
                                  ],
                                  rows: products.map<DataRow>((product) {
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(product["name"], style: const TextStyle(color: Colors.blueAccent),),
                                        ),
                                        DataCell(
                                          Text(
                                            (product["available"] ?? 0).toString(),
                                            style: TextStyle(
                                              color: (product["available"] ?? 0) > 0 ? Colors.green : Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(product["type"]),
                                        ),
                                        DataCell(
                                          Text(product["supplier"]),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),

                          // Phân trang
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Nút "Hiển thị"
                                  PopupMenuButton<int>(
                                    onSelected: (value) {
                                      setState(() {
                                        rowsPerPage = value;
                                        _fetchProducts();
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
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                          setState(() {
                                            currentPage = 1;
                                            _fetchProducts();
                                          });
                                        }
                                            : null,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.chevron_left),
                                        onPressed: currentPage > 1
                                            ? () {
                                          setState(() {
                                            currentPage--;
                                            _fetchProducts();
                                          });
                                        }
                                            : null,
                                      ),
                                      Row(
                                        children:
                                        List.generate(endPage - startPage + 1, (index) {
                                          int pageIndex = startPage + index;
                                          return Padding(
                                            padding:
                                            const EdgeInsets.symmetric(horizontal: 4.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: pageIndex == currentPage
                                                    ? Colors.blue
                                                    : Colors.grey[300],
                                                foregroundColor: pageIndex == currentPage
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  currentPage = pageIndex;
                                                  _fetchProducts();
                                                });
                                              },
                                              child: Text('$pageIndex'),
                                            ),
                                          );
                                        }),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.chevron_right),
                                        onPressed: currentPage < totalPages
                                            ? () {
                                          setState(() {
                                            currentPage++;
                                            _fetchProducts();
                                          });
                                        }
                                            : null,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.last_page),
                                        onPressed: currentPage < totalPages
                                            ? () {
                                          setState(() {
                                            currentPage = totalPages;
                                            _fetchProducts();
                                          });
                                        }
                                            : null,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}

String getPromotionTypeName(int type) {
  switch (type) {
    case 0:
      return "Tất cả";
    case 1:
      return "Loại";
    case 2:
      return "Nhà cung cấp";
    default:
      return "Tất cả";
  }
}
