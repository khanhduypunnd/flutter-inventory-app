import 'package:flutter/material.dart';
import 'widget/infor_header.dart';
import 'widget/order_table.dart';
import 'widget/contact_infor.dart';
import '../../../../shared/core/theme/colors_app.dart';

class CustomerInfoWidget extends StatefulWidget {
  final String customerName;
  final double cumulativeRevenue;
  final int totalOrders;
  final List<Map<String, String>> orderList;
  final String phoneNumber;
  final String email;
  final String birthDate;
  final String address;

  const CustomerInfoWidget({
    Key? key,
    required this.customerName,
    required this.cumulativeRevenue,
    required this.totalOrders,
    required this.orderList,
    required this.phoneNumber,
    required this.email,
    required this.birthDate,
    required this.address,
  }) : super(key: key);

  @override
  State<CustomerInfoWidget> createState() => _CustomerInfoWidgetState();
}

class _CustomerInfoWidgetState extends State<CustomerInfoWidget> {
  late double maxWidth, maxHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    bool isWarning = maxWidth < 850;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: isWarning
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin khách hàng',
                    style: TextStyle(
                      color: AppColors.titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: CustomerInfoHeader(
                      customerName: widget.customerName,
                      cumulativeRevenue: widget.cumulativeRevenue,
                      totalOrders: widget.totalOrders,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: CustomerOrdersTable(orderList: widget.orderList),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: CustomerContactInfo(
                      phoneNumber: widget.phoneNumber,
                      email: widget.email,
                      birthDate: widget.birthDate,
                      address: widget.address,
                    ),
                  ),
                ],
              )),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 100),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: CustomerInfoHeader(
                              customerName: widget.customerName,
                              cumulativeRevenue: widget.cumulativeRevenue,
                              totalOrders: widget.totalOrders,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            child: CustomerOrdersTable(
                                orderList: widget.orderList),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        child: CustomerContactInfo(
                          phoneNumber: widget.phoneNumber,
                          email: widget.email,
                          birthDate: widget.birthDate,
                          address: widget.address,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: CustomerInfoWidget(
          customerName: 'Nguyễn Văn A',
          cumulativeRevenue: 20000.00,
          totalOrders: 10,
          orderList: [
            {'id': 'C001', 'date': '01/01/2025', 'value': '\$500'},
            {'id': 'C002', 'date': '02/01/2025', 'value': '\$700'},
            {'id': 'C003', 'date': '03/01/2025', 'value': '\$300'},
          ],
          phoneNumber: '0123456789',
          email: 'nguyenvana@example.com',
          birthDate: '01/01/1990',
          address: '123 Đường ABC, Thành phố XYZ',
        ),
      ),
    );
  }
}
