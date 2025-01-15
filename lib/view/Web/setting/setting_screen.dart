import 'package:flutter/material.dart';
import '../../../shared/core/theme/colors_app.dart';
import 'account/account.dart';
import 'employee/employee_management.dart';
import 'payment/payment.dart';
import 'role/role.dart';


void main() {
  runApp(const setting());
}

class setting extends StatelessWidget {
  const setting({super.key});

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
    bool isMobile = MediaQuery.of(context).size.width < 750;
    return SafeArea(
      child: Padding(
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
                    children:
                        menuItems.map((item) => buildMenuItem(item, context)).toList(),
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
                        children: [
                          buildMenuItem(menuItems[0], context),
                          const SizedBox(height: 16),
                          buildMenuItem(menuItems[2], context),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildMenuItem(menuItems[1], context),
                          const SizedBox(height: 16),
                          buildMenuItem(menuItems[3], context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildMenuItem(MenuItem item, BuildContext context) {
    return InkWell(
      onTap: (){
        handleMenuTap(item, context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(
                  height: 5,
                ),
                Text(
                  item.suptitle,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.normal),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmployeeManagement()),
        );
        break;
      case 'Vai trò':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RoleList()),
        );
        break;
      case 'Phương thức thanh toán':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Payment()),
        );
        break;
      case 'Tài khoản':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Account()),
        );
        break;
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
      icon: Icons.people_alt_outlined),
  MenuItem(
      title: 'Vai trò',
      suptitle: 'Tạo, phân quyền và quản lý vai trò',
      icon: Icons.accessibility_new),
  MenuItem(
      title: 'Phương thức thanh toán',
      suptitle: 'Quản lý, cấu hình phương thức thanh toán',
      icon: Icons.payment_outlined),
  MenuItem(
      title: 'Tài khoản',
      suptitle: 'Cấu hình tài khoản',
      icon: Icons.account_circle_outlined),
];
