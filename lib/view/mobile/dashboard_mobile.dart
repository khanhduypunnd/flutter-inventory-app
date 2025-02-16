import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dashboard/dashboard.dart';
import 'order/list_order.dart';
import 'product/list_product/list_product.dart';
// import 'product/new_product/new_product.dart';
import 'customer/list_customer/list_customer.dart';
import 'inventory/inventory_overall/inventory_details.dart';
import 'inventory/adjust_history/adjust_inventory_history.dart';
import 'report/analysis.dart';
import 'setting/setting_screen.dart';
import 'setting/employee/employee_management.dart';
import 'setting/role/role.dart';
import 'drawer/drawer_mobile.dart';
import '../../shared/core/theme/colors_app.dart';

class InventoryMobile extends StatefulWidget {
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> navigatorKey;
  const InventoryMobile({super.key, required this.navigatorKey});

  @override
  State<InventoryMobile> createState() => _DashboardWebState();
}

class _DashboardWebState extends State<InventoryMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedPage = 'Tổng quan';
  bool _isDrawerOpen = false;
  late double screenWidth;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {

    bool isScreenWide = screenWidth > 500;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _selectedPage.isEmpty ? "Tổng quan" : _selectedPage,
        ),
        backgroundColor: AppColors.tabbarColor,
        leading: isScreenWide
            ? null
            : IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            final scaffoldState = _scaffoldKey.currentState;
            if (scaffoldState != null) {
              if (scaffoldState.isDrawerOpen) {
                scaffoldState.closeDrawer();
              } else {
                scaffoldState.openDrawer();
              }
            }
            setState(() {});
          },
        ),
      ),
      drawer: CustomDrawer(
        selectedPage: _selectedPage,
        onPageSelected: _onPageSelected,
      ),
      body: Row(
        children: [
          Expanded(
            child: Navigator(
              key: widget.navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (context) => _buildPage(_selectedPage),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPageSelected(String page) {
    setState(() {
      _selectedPage = page;
    });

    widget.navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => _buildPage(page),
      ),
    );
  }


  Widget _buildPage(String page) {
    if (widget.navigatorKey.currentState?.canPop() ?? false) {
      widget.navigatorKey.currentState?.pop();
    }
    if (kDebugMode) {
      print(page);
    }
    switch (page) {
      case 'Tổng quan':
        return DashboardPage();
      case 'Tất cả đơn hàng':
        return ListOrder();
      case 'Tất cả sản phẩm':
        return ListProduct();
      case 'Danh sách khách hàng':
        return CustomerList();
      case 'Chi tiết tồn kho':
        return InventoryOverall();
      case 'Lịch sử điều chỉnh':
        return AdjustInventoryHistory();
      case 'Bảng phân tích':
        return const Analysis();
      case 'Danh sách nhân viên':
        return const EmployeeManagement();
      case 'Vai trò':
        return RoleList();
      case 'Cài đặt':
        return const SettingScreen();
      default:
        return const Center(child: Text("Màn hình không tồn tại"));
    }
  }
}
