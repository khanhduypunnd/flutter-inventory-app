import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  final String selectedPage;
  final ValueChanged<String> onPageSelected;
  final BuildContext context;
  final List<int>? roleDetail;

  CustomDrawer({
    required this.selectedPage,
    required this.onPageSelected,
    required this.context,
    this.roleDetail,
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
                  _overall('Tổng quan', Icons.dashboard_outlined, '/dashboard'),
                  _buildExpansionTile(
                      'Đơn hàng', Icons.shopping_cart_outlined, [
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[1] != 2)
                      _buildDrawerItem(
                        context,
                        title: 'Tất cả đơn hàng',
                        route: '/orders',
                      ),
                  ]),
                  _buildExpansionTile('Sản phẩm', Icons.sell_outlined, [
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[2] != 2)
                      _buildDrawerItem(context,
                          title: 'Tất cả sản phẩm', route: '/products'),
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[3] != 2)
                      _buildDrawerItem(context,
                          title: 'Sản phẩm mới', route: '/new_products'),
                  ]),
                  _buildExpansionTile('Khách hàng', Icons.people_alt_outlined, [
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[4] != 2)
                      _buildDrawerItem(context,
                          title: 'Danh sách khách hàng', route: '/customers')
                  ]),
                  _buildExpansionTile(
                      'Quản lý tồn kho', Icons.inventory_2_outlined, [
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[5] != 2)
                      _buildDrawerItem(context,
                          title: 'Chi tiết tồn kho', route: '/adjust_overview'),
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[6] != 2)
                      _buildDrawerItem(context,
                          title: 'Phiếu điều chỉnh', route: '/new_adjust'),
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[7] != 2)
                      _buildDrawerItem(context,
                          title: 'Lịch sử điều chỉnh', route: '/adjusts'),
                  ]),
                  _buildExpansionTile('Khuyến mãi', Icons.card_giftcard, [
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[8] != 2)
                      _buildDrawerItem(context,
                          title: 'Danh sách khuyến mãi', route: '/promotions'),
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[9] != 2)
                      _buildDrawerItem(context,
                          title: 'Khuyến mãi mới', route: '/new_promotion'),
                  ]),
                  _buildExpansionTile('Báo cáo', Icons.insert_chart_outlined, [
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[10] != 2)
                      _buildDrawerItem(context,
                          title: 'Báo cáo', route: '/reports'),
                  ]),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: selectedPage == 'Cấu hình'
                    ? Colors.blueAccent
                    : Colors.black,
              ),
              title: Text(
                'Cấu hình',
                style: TextStyle(
                  color: selectedPage == 'Cấu hình'
                      ? Colors.blueAccent
                      : Colors.black,
                ),
              ),
              onTap: () {
                onPageSelected('Cấu hình');
                context.go('/setting');
              },
              selected: selectedPage == 'Cấu hình',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required String route,
  }) {
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
            fontWeight:
                selectedPage == title ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          onPageSelected(route);
          context.go(route);
          Navigator.pop(context);
        },
        selected: selectedPage == title,
      ),
    );
  }

  Widget _buildExpansionTile(
      String title, IconData icon, List<Widget> children) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color:
              selectedPage.contains(title) ? Colors.blueAccent : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selectedPage.contains(title) ? Colors.black : Colors.black,
            fontWeight: selectedPage.contains(title)
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        initiallyExpanded: selectedPage.contains(title),
        children: children,
      ),
    );
  }

  Widget _overall(String title, IconData icon, String route) {
    return Container(
      decoration: BoxDecoration(
        color: selectedPage == 'Tổng quan' ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          Icons.dashboard_outlined,
          color: title == 'Tổng quan' ? Colors.blueAccent : Colors.black,
        ),
        title: Text(
          'Tổng quan',
          style: TextStyle(
            color: selectedPage == 'Tổng quan' ? Colors.black : Colors.black,
            fontWeight: selectedPage == 'Tổng quan'
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        onTap: () {
          onPageSelected(route);
          context.go(route);
          Navigator.pop(context);
        },
        selected: title == 'Tổng quan',
      ),
    );
  }
}
