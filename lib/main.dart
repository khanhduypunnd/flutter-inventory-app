import 'package:dacntt1_mobile_admin/view/mobile/setting/account/account.dart';
import 'package:dacntt1_mobile_admin/view_model/account.dart';
import 'package:dacntt1_mobile_admin/view_model/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared/core/router/router.dart';
import 'view_model/login.dart';
import 'view_model/dashboard.dart';
import 'view_model/inventory_overall.dart';
import 'view_model/new_employee.dart';
import 'view_model/order.dart';
import 'view_model/report.dart';

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
        ChangeNotifierProvider(create: (_) => InventoryOverallModel()),
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hype inventory',
      routerConfig: AppRouter.router,
    );
  }
}
