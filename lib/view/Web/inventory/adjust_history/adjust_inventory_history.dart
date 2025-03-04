import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../shared/core/services/uriApi.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../../../../view_model/inventory/adjust_inventory_list.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      Provider.of<AdjustInventoryListModel>(context, listen: false)
          .fetchAdjustments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adjustInventoryListModel =
        Provider.of<AdjustInventoryListModel>(context);

    int totalPages = adjustInventoryListModel.totalPages;

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
              padding: const EdgeInsets.all(30),
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                Provider.of<AdjustInventoryListModel>(context, listen: false)
                                    .filterAdjustments(value);
                              },
                              decoration: const InputDecoration(
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
                      child: adjustInventoryListModel.isLoading
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
                                  rows: adjustInventoryListModel
                                      .displayedAdjustments
                                      .map<DataRow>((adjustment) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Text(adjustment["ganId"] ??
                                                    'N/A'),
                                                onTap: () {
                                                  context.go(
                                                      '/adjust_detail/${adjustment["ganId"]}',
                                                      extra: adjustment);
                                                },
                                              ),
                                              DataCell(
                                                Text(
                                                    adjustment["sId"] ?? 'N/A'),
                                                onTap: () {
                                                  context.go(
                                                      '/adjust_detail/${adjustment["ganId"]}',
                                                      extra: adjustment);
                                                },
                                              ),
                                              DataCell(
                                                Text(DateFormat(
                                                        "yyyy-MM-dd HH:mm:ss")
                                                    .format(
                                                        DateTime.parse(adjustment["date"] ??
                                                            'N/A'))),
                                                onTap: () {
                                                  context.go(
                                                      '/adjust_detail/${adjustment["ganId"]}',
                                                      extra: adjustment);
                                                },
                                              ),
                                              DataCell(
                                                Text(adjustment[
                                                        "increasedQuantity"]
                                                    .toString()),
                                                onTap: () {
                                                  context.go(
                                                      '/adjust_detail/${adjustment["ganId"]}',
                                                      extra: adjustment);
                                                },
                                              ),
                                              DataCell(
                                                Text(adjustment[
                                                        "decreasedQuantity"]
                                                    .toString()),
                                                onTap: () {
                                                  context.go(
                                                      '/adjust_detail/${adjustment["ganId"]}',
                                                      extra: adjustment);
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PopupMenuButton<int>(
                            color: Colors.white,
                            onSelected: (value) {
                              adjustInventoryListModel.setRowsPerPage(value);
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem<int>(
                                    value: 10, child: Text("Hiển thị 10")),
                                const PopupMenuItem<int>(
                                    value: 20, child: Text("Hiển thị 20")),
                                const PopupMenuItem<int>(
                                    value: 50, child: Text("Hiển thị 50")),
                              ];
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                      "Hiển thị ${adjustInventoryListModel.rowsPerPage}",
                                      style: const TextStyle(fontSize: 16)),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: adjustInventoryListModel.currentPage > 1
                                ? () => adjustInventoryListModel.goToPage(
                                    adjustInventoryListModel.currentPage - 1)
                                : null,
                          ),
                          Text(
                              "Trang ${adjustInventoryListModel.currentPage}/$totalPages"),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: adjustInventoryListModel.currentPage <
                                    totalPages
                                ? () => adjustInventoryListModel.goToPage(
                                    adjustInventoryListModel.currentPage + 1)
                                : null,
                          ),
                        ],
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
