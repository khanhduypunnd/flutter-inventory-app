import 'package:dacntt1_mobile_admin/view_model/order/order.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../../shared/core/theme/colors_app.dart';

class ListOrder extends StatefulWidget {
  final Map<String, dynamic>? staffData;

  const ListOrder({super.key, this.staffData});

  @override
  State<ListOrder> createState() => _ListOrderState();
}

class _ListOrderState extends State<ListOrder> {
  Map<String, dynamic>? staffData;
  List<int>? roleDetail;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ListOrderModel>(context, listen: false).fetchOrders();
      Provider.of<ListOrderModel>(context, listen: false).fetchCustomers();
    });
  }


  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<ListOrderModel>(context);
    int totalPages = ordersModel.totalPages;
    // const int maxPagesToShow = 5;
    //
    // int startPage = ordersModel.currentPage - (maxPagesToShow ~/ 2);
    // int endPage = ordersModel.currentPage + (maxPagesToShow ~/ 2);
    //
    // if (startPage < 1) {
    //   startPage = 1;
    //   endPage = maxPagesToShow;
    // }
    //
    // if (endPage > totalPages) {
    //   endPage = totalPages;
    //   startPage = totalPages - maxPagesToShow + 1;
    //   if (startPage < 1) startPage = 1;
    // }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      child: ordersModel.isLoading
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
                                  rows: ordersModel.displayedOrders
                                      .map<DataRow>((order) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text(order.id)),
                                              DataCell(
                                                  Text(order.date.toString())),
                                              DataCell(Text(ordersModel.getCustomerName(order.cid))),
                                              DataCell(Text(
                                                ordersModel.getStatusText(
                                                    order.status),
                                                style: TextStyle(
                                                    color: ordersModel
                                                        .getStatusColor(
                                                            order.status),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                              DataCell(Text(
                                                  order.totalPrice.toString())),
                                              DataCell(Text(order.channel)),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                    ),


                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PopupMenuButton<int>(
                            color: Colors.white,
                            onSelected: (value) {
                              ordersModel.setRowsPerPage(value);
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem<int>(value: 10, child: Text("Hiển thị 10")),
                                const PopupMenuItem<int>(value: 20, child: Text("Hiển thị 20")),
                                const PopupMenuItem<int>(value: 50, child: Text("Hiển thị 50")),
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
                                  Text("Hiển thị ${ordersModel.rowsPerPage}", style: const TextStyle(fontSize: 16)),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.first_page),
                                onPressed: ordersModel.currentPage > 1
                                    ? () => ordersModel.goToPage(1)
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: ordersModel.currentPage > 1
                                    ? () => ordersModel.goToPage(ordersModel.currentPage - 1)
                                    : null,
                              ),
                              Text("Trang ${ordersModel.currentPage}/$totalPages"),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: ordersModel.currentPage < totalPages
                                    ? () => ordersModel.goToPage(ordersModel.currentPage + 1)
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.last_page),
                                onPressed: ordersModel.currentPage < totalPages
                                    ? () => ordersModel.goToPage(totalPages)
                                    : null,
                              ),
                            ],
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
