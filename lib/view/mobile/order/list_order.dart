import 'package:flutter/material.dart';
import 'dart:math';
import '../../../shared/core/theme/colors_app.dart';

class ListOrder extends StatefulWidget {
  @override
  State<ListOrder> createState() => _ListOrderState();
}

class _ListOrderState extends State<ListOrder> {
  int rowsPerPage = 20;
  int currentPage = 1;
  int totalOrders = 50;
  List<Map<String, dynamic>> orders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final random = Random();
    int startIndex = (currentPage - 1) * rowsPerPage;

    orders = List.generate(
      rowsPerPage,
          (index) => {
        "orderCode": "#1109${startIndex + index}",
        "date": getRandomDate(),
        "customer": "Khách hàng ${startIndex + index}",
        "paymentStatus": random.nextBool() ? "Đã thanh toán" : "Chưa thanh toán",
        "deliveryStatus": random.nextBool() ? "Đã giao" : "Chưa giao",
        "totalAmount": "${random.nextInt(5000000)} đ",
        "channel": "POS",
      },
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalOrders / rowsPerPage).ceil();
    const int maxPagesToShow = 5;

    int startPage = max(1, currentPage - maxPagesToShow ~/ 2);

    int endPage = startPage + maxPagesToShow - 1;
    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = max(1, totalPages - maxPagesToShow + 1);
    }


    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: const Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: "Tìm kiếm đơn hàng...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
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
                          columnSpacing: 16.0,
                          columns: const <DataColumn>[
                            DataColumn(label: Text('Mã')),
                            DataColumn(label: Text('Ngày tạo')),
                            DataColumn(label: Text('Khách hàng')),
                            DataColumn(label: Text('Thanh toán')),
                            DataColumn(label: Text('Tổng tiền')),
                            DataColumn(label: Text('Kênh')),
                          ],
                          rows: orders.map<DataRow>((order) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(order["orderCode"])),
                              DataCell(Text(order["date"])),
                              DataCell(Text(order["customer"])),
                              DataCell(
                                Text(
                                  order["paymentStatus"],
                                  style: TextStyle(
                                    color: order["paymentStatus"] == "Đã thanh toán"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                              DataCell(Text(order["totalAmount"])),
                              DataCell(Text(order["channel"])),
                            ],
                          )).toList(),
                        ),
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PopupMenuButton<int>(
                            color: Colors.white,
                            onSelected: (value) {
                              setState(() {
                                rowsPerPage = value;
                                _fetchOrders();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem<int>(
                                  value: 10,
                                  child: Text("Hiển thị 10", style: TextStyle(color: Colors.blueAccent),),
                                ),
                                const PopupMenuItem<int>(
                                  value: 20,
                                  child: Text("Hiển thị 20", style: TextStyle(color: Colors.blueAccent)),
                                ),
                                const PopupMenuItem<int>(
                                  value: 50,
                                  child: Text("Hiển thị 50", style: TextStyle(color: Colors.blueAccent)),
                                ),
                              ];
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                    _fetchOrders();
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
                                    _fetchOrders();
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
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0), // Làm cho nút có góc vuông
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          currentPage = pageIndex;
                                          _fetchOrders();
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
                                    _fetchOrders();
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
                                    _fetchOrders();
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
          );
        },
      ),
    );
  }

  String getRandomDate() {
    final random = Random();
    int day = 1 + random.nextInt(28);
    int month = 1 + random.nextInt(12);
    int year = 2020 + random.nextInt(6);
    return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";
  }
}
