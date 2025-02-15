import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/core/services/uriApi.dart';
import '../../../../shared/core/theme/colors_app.dart';
import 'adjust_inven_detail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../data/gan.dart';

class AdjustInventoryHistory extends StatefulWidget {
  final Map<String, dynamic>? staffData;

  const AdjustInventoryHistory({super.key, this.staffData});

  @override
  State<AdjustInventoryHistory> createState() => _AdjustInventoryHistory();
}

class _AdjustInventoryHistory extends State<AdjustInventoryHistory> {
  final ApiService uriAPIService = ApiService();

  int rowsPerPage = 20;
  int currentPage = 1;
  int totalChecks = 0;
  List<Map<String, dynamic>> adjustments = [];
  List<Map<String, dynamic>> adjustments_details = [];
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
      final url = Uri.parse(
          uriAPIService.apiUrlGan);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          adjustments =
              (data as List<dynamic>? ?? []).map<Map<String, dynamic>>((item) {
            final adjustment = GAN(
              ganId: item['ganId'] ?? '',
              staffId: item['sId'] ?? '',
              date: DateTime.fromMillisecondsSinceEpoch(
                  item['date']['_seconds'] * 1000).toUtc(),
              increasedQuantity: item['increasedQuantity'] ?? 0,
              decreasedQuantity: item['descreaedQuantity'] ?? 0,
              note: item['note'] ?? '',
            );

            final details = (item['details'] as List<dynamic>? ?? [])
                .map<Map<String, dynamic>>((detail) {
              final adjustmentsDetail = GANDetail(
                ganId: detail['ganId'] ?? '',
                productId: detail['pid'] ?? '',
                size: (detail['size'] as List<dynamic>?)
                        ?.map((s) => s.toString())
                        .toList() ??
                    [],
                oldQuantity:
                    int.tryParse(detail['oldQuantity']?.toString() ?? '0') ?? 0,
                newQuantity:
                    int.tryParse(detail['newQuantity']?.toString() ?? '0') ?? 0,
              );

              return {
                "ganId": adjustmentsDetail.ganId,
                "pid": adjustmentsDetail.productId,
                "size": adjustmentsDetail.size,
                "oldQuantity": adjustmentsDetail.oldQuantity,
                "newQuantity": adjustmentsDetail.newQuantity,
              };
            }).toList();

            return {
              "ganId": adjustment.ganId,
              "sId": adjustment.staffId,
              "date": adjustment.date.toIso8601String(),
              "increasedQuantity": adjustment.increasedQuantity,
              "decreasedQuantity": adjustment.decreasedQuantity,
              "note": adjustment.note,
              "details": details,
            };
          }).toList();

          adjustments.sort((a, b) {
            final dateA = DateTime.parse(a['date']);
            final dateB = DateTime.parse(b['date']);
            return dateB.compareTo(dateA);
          });

          totalChecks = adjustments.length;
        });
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (error) {
      print('Error fetching adjustments: $error');
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
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.titleColor)),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
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
                                    DataColumn(
                                        label: Text('Mã người thay đổi')),
                                    DataColumn(label: Text('Ngày')),
                                    DataColumn(label: Text('Số lượng tăng')),
                                    DataColumn(label: Text('Số lượng giảm')),
                                  ],
                                  rows: adjustments
                                      .map<DataRow>((adjustment) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Text(adjustment["ganId"] ??
                                                    'N/A'),
                                                onTap: () {
                                                  context.go('/adjust_detail/${adjustment["ganId"]}', extra: adjustment);
                                                },
                                              ),
                                              DataCell(
                                                Text(
                                                    adjustment["sId"] ?? 'N/A'),
                                                onTap: () {
                                                  context.go('/adjust_detail/${adjustment["ganId"]}', extra: adjustment);
                                                },
                                              ),
                                              DataCell(
                                                Text(adjustment["date"] ??
                                                    'N/A'),
                                                onTap: () {
                                                  context.go('/adjust_detail/${adjustment["ganId"]}', extra: adjustment);
                                                },
                                              ),
                                              DataCell(
                                                Text(adjustment[
                                                        "increasedQuantity"]
                                                    .toString()),
                                                onTap: () {
                                                  context.go('/adjust_detail/${adjustment["ganId"]}', extra: adjustment);
                                                },
                                              ),
                                              DataCell(
                                                Text(adjustment[
                                                        "decreasedQuantity"]
                                                    .toString()),
                                                onTap: () {
                                                  context.go('/adjust_detail/${adjustment["ganId"]}', extra: adjustment);
                                                },
                                              ),
                                            ],
                                          ))
                                      .toList(),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
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
