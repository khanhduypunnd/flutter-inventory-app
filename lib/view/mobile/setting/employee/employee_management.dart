import 'package:flutter/material.dart';
import '../../../../data/employee.dart';
import '../../../../shared/core/theme/colors_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: EmployeeManagement(),
      ),
    );
  }
}

class EmployeeManagement extends StatefulWidget {
  const EmployeeManagement({super.key});

  @override
  State<EmployeeManagement> createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {
  final List<Employee> employees = [
    Employee(
      id: '1',
      name: 'John Doe',
      address: '123 Elm St',
      email: 'john.doe@example.com',
      phone: '123-456-7890',
      pass: 'password123',
      role: 'Manager',
    ),
    Employee(
      id: '2',
      name: 'Jane Smith',
      address: '456 Oak St',
      email: 'jane.smith@example.com',
      phone: '234-567-8901',
      pass: 'password124',
      role: 'Staff',
    ),
    Employee(
      id: '3',
      name: 'Bob Johnson',
      address: '789 Pine St',
      email: 'bob.johnson@example.com',
      phone: '345-678-9012',
      pass: 'password125',
      role: 'Admin',
    ),
    Employee(
      id: '4',
      name: 'Alice Brown',
      address: '101 Maple St',
      email: 'alice.brown@example.com',
      phone: '456-789-0123',
      pass: 'password126',
      role: 'Staff',
    ),
    Employee(
      id: '5',
      name: 'Charlie Davis',
      address: '123 Spruce St',
      email: 'charlie.davis@example.com',
      phone: '567-890-1234',
      pass: 'password127',
      role: 'Supervisor',
    ),
    Employee(
      id: '6',
      name: 'Diane Evans',
      address: '456 Birch St',
      email: 'diane.evans@example.com',
      phone: '678-901-2345',
      pass: 'password128',
      role: 'Staff',
    ),
    Employee(
      id: '7',
      name: 'Frank Green',
      address: '789 Cedar St',
      email: 'frank.green@example.com',
      phone: '789-012-3456',
      pass: 'password129',
      role: 'Manager',
    ),
    Employee(
      id: '8',
      name: 'Grace Hill',
      address: '101 Elm St',
      email: 'grace.hill@example.com',
      phone: '890-123-4567',
      pass: 'password130',
      role: 'Staff',
    ),
    Employee(
      id: '9',
      name: 'Henry Adams',
      address: '123 Oak St',
      email: 'henry.adams@example.com',
      phone: '901-234-5678',
      pass: 'password131',
      role: 'Admin',
    ),
    Employee(
      id: '10',
      name: 'Irene Baker',
      address: '456 Pine St',
      email: 'irene.baker@example.com',
      phone: '012-345-6789',
      pass: 'password132',
      role: 'Staff',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int employeeCount = employees.length;
    return SingleChildScrollView(
      child: Container(
        color: AppColors.backgroundColor,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chủ cửa hàng',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.titleColor),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tài khoản toàn quyền truy cập cửa hàng của bạn',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.subtitleColor,
                fontFamily: 'Arial',
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      'M',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.titleColor),
                      ),
                      Text(
                        'baotram.nguyencgoc0906@gmail.com',
                        style: TextStyle(color: AppColors.subtitleColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people_alt_outlined),
                    const SizedBox(width: 8),
                    Text(
                      'Đã tạo $employeeCount tài khoản nhân viên',
                      style: const TextStyle(fontSize: 16, color: AppColors.subtitleColor),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
            const SizedBox(width: 15),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Danh sách nhân viên',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ...employees.map((e) => ListTile(
                    title: Text(e.name),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.mail_outline),
                        const SizedBox(width: 3),
                        Text(e.email),
                      ],
                    ),
                    trailing: const Icon(Icons.delete_outline),
                    onTap: () {
                      // Handle onTap action here
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
