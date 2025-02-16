import 'package:dacntt1_mobile_admin/view/mobile/dashboard_mobile.dart';
import 'package:dacntt1_mobile_admin/view/mobile/setting/account/account.dart';
import 'package:dacntt1_mobile_admin/view_model/customer/customer.dart';
import 'package:dacntt1_mobile_admin/view_model/inventory/adjust_inventory.dart';
import 'package:dacntt1_mobile_admin/view_model/inventory/adjust_inventory_detail.dart';
import 'package:dacntt1_mobile_admin/view_model/inventory/adjust_inventory_list.dart';
import 'package:dacntt1_mobile_admin/view_model/product/list_product.dart';
import 'package:dacntt1_mobile_admin/view_model/product/new_product.dart';
import 'package:dacntt1_mobile_admin/view_model/promotion/list_promotion.dart';
import 'package:dacntt1_mobile_admin/view_model/promotion/new_promotion.dart';
import 'package:dacntt1_mobile_admin/view_model/setting/account.dart';
import 'package:dacntt1_mobile_admin/view_model/product/product_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared/core/router/router.dart';
import 'view_model/login/login.dart';
import 'view_model/dashboard/dashboard.dart';
import 'view_model/inventory/inventory_overall.dart';
import 'view_model/setting/new_employee.dart';
import 'view_model/order/order.dart';
import 'view_model/report/report.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginModel()),
        ChangeNotifierProvider(create: (_) => DashboardModel()),
        ChangeNotifierProvider(create: (_) => NewEmployee()),
        ChangeNotifierProvider(create: (_) => ListOrderModel()),
        ChangeNotifierProvider(create: (_) => ListProductModel()),
        ChangeNotifierProvider(create: (_) => NewProductModel()),
        ChangeNotifierProvider(create: (_) => ProductDetailModel()),
        ChangeNotifierProvider(create: (_) => ProductDetailModel()),
        ChangeNotifierProvider(create: (_) => CustomerModel()),
        ChangeNotifierProvider(create: (_) => InventoryOverallModel()),
        ChangeNotifierProvider(create: (_) => AdjustInventoryListModel()),
        ChangeNotifierProvider(create: (_) => AdjustInventoryModel()),
        ChangeNotifierProvider(create: (_) => AdjustInventoryDetailModel()),
        ChangeNotifierProvider(create: (_) => ListPromotionModel()),
        ChangeNotifierProvider(create: (_) => NewPromotionModel()),
        ChangeNotifierProvider(create: (_) => ReportModel()),
        ChangeNotifierProvider(create: (_) => ProductDetailModel()),
        ChangeNotifierProvider(
          create: (context) => AccountModel(),
          child: Account(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hype Inventory - Web',
      routerConfig: AppRouter.router,
    );


    // return kIsWeb
    //     ? MaterialApp.router(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Hype Inventory - Web',
    //   routerConfig: AppRouter.router,
    // )
    //     : MaterialApp(
    //   // navigatorKey: navigatorKey,
    //   debugShowCheckedModeBanner: false,
    //   title: 'Hype Inventory - Mobile',
    //   home: InventoryMobile(
    //     navigatorKey: navigatorKey,
    //   ),
    // );
  }
}