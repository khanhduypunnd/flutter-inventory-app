import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String selectedPage;
  final ValueChanged<String> onPageSelected;
  final BuildContext context;

  CustomDrawer({
    required this.selectedPage,
    required this.onPageSelected,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                children: [
                  _overall('Tổng quan', Icons.dashboard_outlined),
                  _buildExpansionTile('Đơn hàng', Icons.shopping_cart_outlined, [
                    _buildDrawerItem('Tất cả đơn hàng'),
                    _buildDrawerItem('Đơn hàng mới'),
                  ]),
                  _buildExpansionTile('Vận chuyển', Icons.local_shipping_outlined, [
                    _buildDrawerItem('Tổng quan'),
                    _buildDrawerItem('Giao hàng'),
                    _buildDrawerItem('Hoàn hàng'),
                  ]),
                  _buildExpansionTile('Sản phẩm', Icons.sell_outlined, [
                    _buildDrawerItem('Tất cả sản phẩm'),
                    _buildDrawerItem('Sản phẩm mới'),
                  ]),
                  _buildExpansionTile('Khách hàng', Icons.people_alt_outlined, [
                    _buildDrawerItem('Danh sách khách hàng')
                  ]),
                  _buildExpansionTile('Quản lý tồn kho', Icons.inventory_2_outlined, [
                    _buildDrawerItem('Chi tiết tồn kho'),
                    _buildDrawerItem('Nhập kho'),
                    _buildDrawerItem('Xuất kho'),
                  ]),
                  _buildExpansionTile('Khuyến mãi', Icons.card_giftcard, [
                    _buildDrawerItem('Danh sách khuyến mãi'),
                    _buildDrawerItem('Khuyến mãi mới'),
                  ]),
                  _buildExpansionTile('Báo cáo', Icons.insert_chart_outlined,[
                    _buildDrawerItem('Tổng quan'),
                  ]),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: selectedPage == 'Cấu hình' ? Colors.blueAccent : Colors.black,
              ),
              title: Text(
                'Cấu hình',
                style: TextStyle(
                  color: selectedPage == 'Cấu hình' ? Colors.blueAccent : Colors.black,
                ),
              ),
              onTap: () => onPageSelected('Cấu hình'),
              selected: selectedPage == 'Cấu hình',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: selectedPage == title
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(0, 2), // Vị trí bóng
          )
        ]
            : [],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: selectedPage == title ? Colors.black : Colors.black,
            fontWeight: selectedPage == title ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => onPageSelected(title),
        selected: selectedPage == title,
      ),
    );
  }

  Widget _buildExpansionTile(String title, IconData icon, List<Widget> children) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: selectedPage.contains(title) ? Colors.blueAccent : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selectedPage.contains(title) ? Colors.black : Colors.black,
            fontWeight: selectedPage.contains(title) ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        initiallyExpanded: selectedPage.contains(title),
        children: children,
      ),
    );
  }

  Widget _overall(String title, IconData icon){
    return Container(
      decoration: BoxDecoration(
        color: selectedPage == 'Tổng quan' ? Colors.white : Colors
            .transparent,
        borderRadius: BorderRadius.circular(15),
        boxShadow: title == 'Tổng quan'
            ? [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 2,
            offset: Offset(0, 2),
          )
        ]
            : [],
      ),
      child: ListTile(
        leading: Icon(
          Icons.dashboard_outlined,
          color: title == 'Tổng quan'
              ? Colors.blueAccent
              : Colors.black,
        ),
        title: Text(
          'Tổng quan',
          style: TextStyle(
            color: selectedPage == 'Tổng quan'
                ? Colors.black
                : Colors.black,
            fontWeight: selectedPage == 'Tổng quan'
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        onTap: () => onPageSelected(title),
        selected: title == 'Tổng quan',
      ),
    );
  }

}
