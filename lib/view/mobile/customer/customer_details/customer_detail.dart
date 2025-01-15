import 'package:flutter/material.dart';
import 'widget/infor_header.dart';
import 'widget/order_table.dart';
import 'widget/contact_infor.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../../../../data/customer.dart';

class CustomerInfoWidget extends StatefulWidget {
  final Customer customer; // Nhận một đối tượng Customer
  final List<Map<String, String>> orderList;

  const CustomerInfoWidget({
    Key? key,
    required this.customer,
    required this.orderList,
  }) : super(key: key);

  @override
  State<CustomerInfoWidget> createState() => _CustomerInfoWidgetState();
}

class _CustomerInfoWidgetState extends State<CustomerInfoWidget> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
              width: MediaQuery.of(context).size.width,
              child: CustomerInfoHeader(
                customerName: widget.customer.name,
                cumulativeRevenue: 20000.00, // Cộng doanh thu mẫu
                totalOrders: 10, // Số lượng đơn mẫu
              ),
            ),
            const SizedBox(height: 16),
            Container(child: CustomerOrdersTable(orderList: widget.orderList)),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width,
              child: CustomerContactInfo(
                phoneNumber: widget.customer.phone,
                email: widget.customer.email,
                birthDate: widget.customer.dob,
                address: widget.customer.address,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Customer sampleCustomer = Customer(
//       id: 'C001',
//       name: 'Nguyễn Văn A',
//       dob: '01/01/1990',
//       address: '123 Đường ABC, Thành phố XYZ',
//       email: 'nguyenvana@example.com',
//       phone: '0123456789',
//       pass: 'password123',
//     );
//
//     List<Map<String, String>> orderList = [
//       {'id': 'C001', 'date': '01/01/2025', 'value': '\$500'},
//       {'id': 'C002', 'date': '02/01/2025', 'value': '\$700'},
//       {'id': 'C003', 'date': '03/01/2025', 'value': '\$300'},
//     ];
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         body: CustomerInfoWidget(
//           customer: sampleCustomer,
//           orderList: orderList,
//         ),
//       ),
//     );
//   }
// }
