import 'package:dacntt1_mobile_admin/view_model/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../../shared/core/theme/colors_app.dart';

class ListOrder extends StatefulWidget {
  @override
  State<ListOrder> createState() => _ListOrderState();
}

class _ListOrderState extends State<ListOrder> {
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
    final ordersmodel = Provider.of<ListOrderModel>(context);
    int totalPages = (ordersmodel.totalOrders / ordersmodel.rowsPerPage).ceil();
    const int maxPagesToShow = 5;

    int startPage = ordersmodel.currentPage - (maxPagesToShow ~/ 2);
    int endPage = ordersmodel.currentPage + (maxPagesToShow ~/ 2);

    if (startPage < 1) {
      startPage = 1;
      endPage = maxPagesToShow;
    }

    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = totalPages - maxPagesToShow + 1;
      if (startPage < 1) startPage = 1;
    }

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
                      child: ordersmodel.isLoading
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
                                  rows: ordersmodel.orders
                                      .map<DataRow>((order) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text(order.id)),
                                              DataCell(
                                                  Text(order.date.toString())),
                                              DataCell(Text(ordersmodel.getCustomerName(order.cid))),
                                              DataCell(Text(
                                                ordersmodel.getStatusText(
                                                    order.status),
                                                style: TextStyle(
                                                    color: ordersmodel
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
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PopupMenuButton<int>(
                              onSelected: (value) {
                                setState(() {
                                  ordersmodel.rowsPerPage = value;
                                  ordersmodel.fetchOrders();
                                });
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem<int>(
                                    value: 10,
                                    child: Text(
                                      "Hiển thị 10",
                                      style:
                                          TextStyle(color: Colors.blueAccent),
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 20,
                                    child: Text("Hiển thị 20",
                                        style: TextStyle(
                                            color: Colors.blueAccent)),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 50,
                                    child: Text("Hiển thị 50",
                                        style: TextStyle(
                                            color: Colors.blueAccent)),
                                  ),
                                ];
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Text("Hiển thị ${ordersmodel.rowsPerPage}",
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
                                  onPressed: ordersmodel.currentPage > 1
                                      ? () {
                                          setState(() {
                                            ordersmodel.currentPage = 1;
                                            ordersmodel.fetchOrders();
                                          });
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: ordersmodel.currentPage > 1
                                      ? () {
                                          setState(() {
                                            ordersmodel.currentPage--;
                                            ordersmodel.fetchOrders();
                                          });
                                        }
                                      : null,
                                ),
                                Row(
                                  children: List.generate(
                                      endPage - startPage + 1, (index) {
                                    int pageIndex = startPage + index;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: pageIndex ==
                                                  ordersmodel.currentPage
                                              ? Colors.blue
                                              : Colors.grey[300],
                                          foregroundColor: pageIndex ==
                                                  ordersmodel.currentPage
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            ordersmodel.currentPage = pageIndex;
                                            ordersmodel.fetchOrders();
                                          });
                                        },
                                        child: Text('$pageIndex'),
                                      ),
                                    );
                                  }),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed:
                                      ordersmodel.currentPage < totalPages
                                          ? () {
                                              setState(() {
                                                ordersmodel.currentPage++;
                                                ordersmodel.fetchOrders();
                                              });
                                            }
                                          : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.last_page),
                                  onPressed:
                                      ordersmodel.currentPage < totalPages
                                          ? () {
                                              setState(() {
                                                ordersmodel.currentPage =
                                                    totalPages;
                                                ordersmodel.fetchOrders();
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
          );
        },
      ),
    );
  }
}
