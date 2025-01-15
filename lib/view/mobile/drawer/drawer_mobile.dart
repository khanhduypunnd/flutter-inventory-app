import 'package:flutter/material.dart';
import '../../icon_pictures.dart';
class CustomDrawer extends StatelessWidget {
  final String selectedPage;
  final ValueChanged<String> onPageSelected;

  CustomDrawer({
    required this.selectedPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white, // Đặt màu nền của Drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Image.asset(logo_app.logo_size100, width: 150, height: 150),
            _buildDrawerItem(
              context,
              title: 'Tổng quan',
              icon: Icons.dashboard_outlined,
            ),
            _buildDrawerItem(
              context,
              title: 'Tất cả đơn hàng',
              icon: Icons.shopping_cart_outlined,
            ),
            _buildDrawerItem(
              context,
              title: 'Tất cả sản phẩm',
              icon: Icons.sell_outlined,
            ),
            _buildDrawerItem(
              context,
              title: 'Danh sách khách hàng',
              icon: Icons.people_alt_outlined,
            ),
            _buildDrawerItem(
              context,
              title: 'Chi tiết tồn kho',
              icon: Icons.inventory_2_outlined,
            ),
            _buildDrawerItem(
              context,
              title: 'Lịch sử điều chỉnh',
              icon: Icons.edit_calendar,
            ),
            _buildDrawerItem(
              context,
              title: 'Bảng phân tích',
              icon: Icons.insert_chart_outlined,
            ),
            _buildDrawerItem(
              context,
              title: 'Danh sách nhân viên',
              icon: Icons.people_alt_outlined,
            ),
            _buildDrawerItem(
              context,
              title: 'Vai trò',
              icon: Icons.accessibility_new,
            ),
            _buildDrawerItem(
              context,
              title: 'Cài đặt',
              icon: Icons.settings_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required String title,
        required IconData icon,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: selectedPage == title ? Colors.blueAccent : Colors.black54,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selectedPage == title ? Colors.black : Colors.black54,
          fontWeight:
          selectedPage == title ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        onPageSelected(title);
        Navigator.pop(context);
      },
      selected: selectedPage == title,
    );
  }
}
