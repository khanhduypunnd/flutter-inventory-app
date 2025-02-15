import 'package:flutter/material.dart';
import 'dart:math';
import '../../../../data/customer.dart';
import '../../../../shared/core/services/uriApi.dart';
import '../../../../shared/core/theme/colors_app.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerList extends StatefulWidget {
  final Map<String, dynamic>? staffData;
  const CustomerList({super.key, this.staffData});


  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  final ApiService uriAPIService = ApiService();


  late int rowsPerPage = 20;
  int currentPage = 1;
  int totalCustomers = 682;
  List<Customer> customers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    if (customers.isNotEmpty) return;
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
          uriAPIService.apiUrlCustomer);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final customer =
        jsonData.map((data) => Customer.fromJson(data)).toList();
        customers.clear();
        customers.addAll(customer);
      } else {
        throw Exception('Failed to fetch customers: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching customers: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalCustomers / rowsPerPage).ceil();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Text('Danh sách khách hàng',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.titleColor)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50, bottom: 30),
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
                            label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                        rows: customers.map<DataRow>((customer) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(customer.name, style: const TextStyle(color: Colors.blueAccent),)),
                              DataCell(Text(customer.phone, style: const TextStyle(color: Colors.blueAccent))),
                              DataCell(Text(customer.email, style: const TextStyle(color: Colors.blueAccent))),
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
                      onSelected: (value) {
                        setState(() {
                          rowsPerPage = value;
                          fetchCustomers();
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
                            setState(() {
                              currentPage = 1;
                              fetchCustomers();
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
                              fetchCustomers();
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
                              fetchCustomers();
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
                              fetchCustomers();
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
