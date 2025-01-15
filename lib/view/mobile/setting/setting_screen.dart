import 'package:flutter/material.dart';
import '../../../shared/core/theme/colors_app.dart';
import 'employee/employee_management.dart';
import 'role/role.dart';
import 'account/account.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: ResponsiveLayout(),
      ),
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Column(
                children: menuItems.map((item) => buildMenuItem(item, context)).toList(),
              ),
            ),
          )),
    );
  }

  Widget buildMenuItem(MenuItem item, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item.widget()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.backgroundIconColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon,
                size: 30,
                color: AppColors.titleColor,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor)),
                const SizedBox(height: 5),
                Text(
                  item.suptitle,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final String suptitle;
  final Widget Function() widget; // Hàm trả về Widget tương ứng

  MenuItem({
    required this.icon,
    required this.title,
    required this.suptitle,
    required this.widget,
  });
}

final List<MenuItem> menuItems = [
  MenuItem(
      title: 'Nhân viên',
      suptitle: 'Tạo, phân quyền và quản lý nhân viên',
      icon: Icons.people_alt_outlined,
      widget: () => EmployeeManagement()),
  MenuItem(
      title: 'Vai trò',
      suptitle: 'Tạo, phân quyền và quản lý vai trò',
      icon: Icons.accessibility_new,
      widget: () => RoleList()),
  MenuItem(
      title: 'Tài khoản',
      suptitle: 'Cấu hình tài khoản',
      icon: Icons.account_circle_outlined,
      widget: () => Account()),
];
