import 'package:flutter/material.dart';
import 'dart:math';
import '../../../../shared/core/theme/colors_app.dart';
import '../customer_details/customer_detail.dart';
import '../../../../data/customer.dart';

class CustomerList extends StatefulWidget {
  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  late int rowsPerPage = 20;
  int currentPage = 1;
  int totalCustomers = 682;
  List<Map<String, dynamic>> customers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    int startIndex = (currentPage - 1) * rowsPerPage;

    List<Map<String, dynamic>> newCustomers = List.generate(
      rowsPerPage,
          (index) => {
        "id": "C${startIndex + index + 1}", // ID khách hàng
        "name": "Khách hàng ${startIndex + index + 1}",
        "dob": "01/01/1990", // Ngày sinh mẫu
        "address": "123 Đường ABC, Thành phố XYZ", // Địa chỉ mẫu
        "email": "customer${startIndex + index + 1}@example.com", // Email mẫu
        "phone": "098${Random().nextInt(10000000).toString().padLeft(7, '0')}", // Số điện thoại mẫu
        "pass": "password123", // Mật khẩu mẫu
        "lastOrder": getRandomDate(),
        "orderCount": Random().nextInt(100),
        "totalSpend": "${Random().nextInt(1000000)} đ",
      },
    );


    setState(() {
      customers = newCustomers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalCustomers / rowsPerPage).ceil();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      // appBar: AppBar(
      //   backgroundColor: AppColors.backgroundColor,
      //   title: const Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 50),
      //     child: Text('Danh sách khách hàng',
      //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.titleColor)),
      //   ),
      // ),
      body: Container(
        padding: const EdgeInsets.all(10),
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
            children: [
              // Thanh tìm kiếm
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Tìm kiếm khách hàng...",
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
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: DataTable(
                      columnSpacing: 50.0,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text('Tên khách hàng', style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        DataColumn(
                          label: Text('Điện thoại', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Đơn gần nhất', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Số lượng đơn hàng', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Tổng chi tiêu', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                      rows: customers.map<DataRow>((customer) {
                        return DataRow(
                          onSelectChanged: (selected) {
                            if (selected != null && selected) {

                              final selectedCustomer = Customer(
                                id: customer["id"],
                                cid: customer["cid"],
                                name: customer["name"],
                                dob: customer["dob"],
                                address: customer["address"],
                                email: customer["email"],
                                phone: customer["phone"],
                                pass: customer["pass"],
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomerInfoWidget(
                                    customer: selectedCustomer,
                                    orderList: [
                                      {'id': 'C001', 'date': '01/01/2025', 'value': '\$500'},
                                      {'id': 'C002', 'date': '02/01/2025', 'value': '\$700'},
                                      {'id': 'C003', 'date': '03/01/2025', 'value': '\$300'},
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                          cells: <DataCell>[
                            DataCell(Text(customer["name"], style: const TextStyle(color: Colors.blueAccent))),
                            DataCell(Text(customer["phone"], style: const TextStyle(color: Colors.blueAccent))),
                            DataCell(Text(customer["lastOrder"], style: const TextStyle(color: Colors.blueAccent))),
                            DataCell(Text(customer["orderCount"].toString())),
                            DataCell(Text(customer["totalSpend"])),
                          ],
                        );
                      }).toList(),

                    ),
                  ),
                ),
              ),

              // Phân trang
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (value) {
                      setState(() {
                        rowsPerPage = value;
                        _fetchCustomers();
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
                          child: Text("Hiển thị 20", style: TextStyle(color: Colors.blueAccent),),
                        ),
                        const PopupMenuItem<int>(
                          value: 50,
                          child: Text("Hiển thị 50", style: TextStyle(color: Colors.blueAccent),),
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
                          setState(() {
                            currentPage = 1;
                            _fetchCustomers();
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
                            _fetchCustomers();
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
                            _fetchCustomers();
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
                            _fetchCustomers();
                          });
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
