import 'package:flutter/material.dart';
import '../../../../shared/core/theme/colors_app.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../data/gan.dart';

class AdjustInventoryHistory extends StatefulWidget {
  const AdjustInventoryHistory({super.key});

  @override
  State<AdjustInventoryHistory> createState() => _AdjustInventoryHistory();
}

class _AdjustInventoryHistory extends State<AdjustInventoryHistory> {
  int rowsPerPage = 20;
  int currentPage = 1;
  int totalChecks = 0;
  List<Map<String, dynamic>> adjustments = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAdjustments();
  }

  Future<void> _fetchAdjustments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('http://localhost:9999/api/grn');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // print(data);

        setState(() {
          adjustments = data['data'].map<Map<String, dynamic>>((item) {
            final adjustment = GAN(
              ganId: item['ganId'] ?? '',
              staffId: item['sId'] ?? '',
              date: DateTime.fromMillisecondsSinceEpoch(item['date']['_seconds'] * 1000),
              increasedQuantity: item['increasedQuantity'] ?? 0,
              descreaedQuantity: item['descreaedQuantity'] ?? 0,
              note: item['note'] ?? '',
            );

            return {
              "ganId": adjustment.ganId,
              "staffId": adjustment.staffId,
              "date": adjustment.date.toIso8601String(),
              "increasedQuantity": adjustment.increasedQuantity.toString(),
              "descreaedQuantity": adjustment.descreaedQuantity.toString(),
              "note": adjustment.note,
            };
          }).toList();
          totalChecks = data['total'] ?? adjustments.length;
        });
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (error) {
      print('Error fetching adjustments: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalChecks / rowsPerPage).ceil();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Text('Danh sách phiếu điều chỉnh',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.titleColor)),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30),
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
                              DataColumn(label: Text('Mã điều chỉnh')),
                              DataColumn(label: Text('Mã người thay đổi')),
                              DataColumn(label: Text('Ngày')),
                              DataColumn(label: Text('Số lượng tăng')),
                              DataColumn(label: Text('Số lượng giảm')),
                            ],
                            rows: adjustments.map<DataRow>((adjustment) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(adjustment["id"] ?? 'N/A')),
                                DataCell(Text(adjustment["sid"] ?? 'N/A')),
                                DataCell(Text(adjustment["date"] ?? 'N/A')),
                                DataCell(Text(adjustment["increasedQuantity"].toString())),
                                DataCell(Text(adjustment["decreasedQuantity"].toString())),
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
                                        _fetchAdjustments();
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
                                        _fetchAdjustments();
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
                                        _fetchAdjustments();
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
                                        _fetchAdjustments();
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
}
