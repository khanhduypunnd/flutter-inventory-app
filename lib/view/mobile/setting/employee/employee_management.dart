import 'package:flutter/material.dart';
import '../../../../data/employee.dart';
import '../../../../shared/core/theme/colors_app.dart';

class EmployeeManagement extends StatefulWidget {
  const EmployeeManagement({super.key});

  @override
  State<EmployeeManagement> createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {
  final List<Staff> employees = [
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
