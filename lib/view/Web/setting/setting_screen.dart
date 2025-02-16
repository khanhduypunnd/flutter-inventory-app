import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/core/theme/colors_app.dart';
import 'account/account.dart';
import 'employee/employee_management.dart';
import 'payment/payment.dart';
import 'role/role.dart';

class SettingScreen extends StatelessWidget {
  final Map<String, dynamic>? staffData;
  const SettingScreen({super.key, this.staffData});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 750;
    bool isAdmin = staffData?['role'] == 'admin';

    final List<MenuItem> displayMenuItems = menuItems.where((item) {
      if (item.title == 'Nhân viên' && !isAdmin) {
        return false;
      }
      return true;
    }).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: isMobile
              ? Container(
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
                children: displayMenuItems
                    .map((item) => buildMenuItem(item, context))
                    .toList(),
              ),
            ),
          )
              : Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 700,
              height: 200,
              alignment: Alignment.topCenter,
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
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: displayMenuItems
                        .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: buildMenuItem(item, context),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget buildMenuItem(MenuItem item, BuildContext context) {
    return InkWell(
      onTap: () {
        handleMenuTap(item, context);
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
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.suptitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleMenuTap(MenuItem item, BuildContext context) {
    switch (item.title) {
      case 'Nhân viên':
        context.go('/staffs');
      case 'Tài khoản':
        context.go('/account', extra: staffData);
      default:
        print('Không tìm thấy hành động');
    }
  }
}

class MenuItem {
  final String title;
  final String suptitle;
  final IconData icon;

  MenuItem({required this.title, required this.suptitle, required this.icon});
}

final List<MenuItem> menuItems = [
  MenuItem(
    title: 'Nhân viên',
    suptitle: 'Tạo, phân quyền và quản lý nhân viên',
    icon: Icons.people_alt_outlined,
  ),
  MenuItem(
    title: 'Tài khoản',
    suptitle: 'Cấu hình tài khoản',
    icon: Icons.account_circle_outlined,
  ),
];
