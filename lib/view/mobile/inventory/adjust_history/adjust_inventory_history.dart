import 'package:flutter/material.dart';
import 'dart:math';
import '../../../../shared/core/theme/colors_app.dart';
class AdjustInventoryHistory extends StatefulWidget {
  @override
  State<AdjustInventoryHistory> createState() => _AdjustInventoryHistory();
}

class _AdjustInventoryHistory extends State<AdjustInventoryHistory> {
  int rowsPerPage = 20;
  int currentPage = 1;
  int totalChecks = 50;
  List<Map<String, dynamic>> stockChecks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStockChecks();
  }


  Future<void> _fetchStockChecks() async {
    setState(() {
      isLoading = true;
    });


    await Future.delayed(const Duration(seconds: 1));

    final random = Random();
    stockChecks = List.generate(
      rowsPerPage,
          (index) => {
        "code": "IA1010${(currentPage - 1) * rowsPerPage + index}",
        "warehouse": "Địa điểm ${random.nextInt(5) + 1}", // Giả lập kho kiểm
        "checkDate": getRandomDate(),
        "quantityDiff": random.nextInt(50) - 25, // Giá trị âm hoặc dương
        "totalValueDiff": "${random.nextInt(1000000)} đ",
      },
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalChecks / rowsPerPage).ceil();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('Danh sách phiếu điều chỉnh',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.titleColor)),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
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
                                hintText: "Tìm kiếm mã phiếu...",
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
                              DataColumn(label: Text('Mã phiếu')),
                              DataColumn(label: Text('Kho kiểm')),
                              DataColumn(label: Text('Ngày kiểm')),
                              DataColumn(label: Text('Số lượng lệch')),
                              DataColumn(label: Text('Tổng giá trị hàng lệch')),
                            ],
                            rows: stockChecks.map<DataRow>((check) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(check["code"])),
                                DataCell(Text(check["warehouse"])),
                                DataCell(Text(check["checkDate"])),
                                DataCell(
                                  Text(
                                    check["quantityDiff"].toString(),
                                    style: TextStyle(
                                      color: check["quantityDiff"] < 0
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(Text(check["totalValueDiff"])),
                              ],
                            )).toList(),
                          ),
                        ),
                      ),
                    ),
                
                
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.first_page),
                                    onPressed: currentPage > 1
                                        ? () {
                                      setState(() {
                                        currentPage = 1;
                                        _fetchStockChecks();
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
                                        _fetchStockChecks();
                                      });
                                    }
                                        : null,
                                  ),
                                  Text("Trang $currentPage/$totalPages"),
                                  IconButton(
                                    icon: const Icon(Icons.chevron_right),
                                    onPressed: currentPage < totalPages
                                        ? () {
                                      setState(() {
                                        currentPage++;
                                        _fetchStockChecks();
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
                                        _fetchStockChecks();
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String getRandomDate() {
    final random = Random();
    int day = 1 + random.nextInt(28); // Ngày ngẫu nhiên từ 1 đến 28
    int month = 1 + random.nextInt(12); // Tháng ngẫu nhiên từ 1 đến 12
    int year = 2020 + random.nextInt(6); // Năm ngẫu nhiên từ 2020 đến 2025
    return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";
  }
}
