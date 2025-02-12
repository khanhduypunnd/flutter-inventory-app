import 'package:dacntt1_mobile_admin/view/Web/login/login_view.dart';
import 'package:dacntt1_mobile_admin/view/mobile/login/mobile_login.dart';
import 'package:dacntt1_mobile_admin/view_model/dashboard.dart';
import 'package:dacntt1_mobile_admin/view_model/inventory_overall.dart';
import 'package:dacntt1_mobile_admin/view_model/new_employee.dart';
import 'package:dacntt1_mobile_admin/view_model/order.dart';
import 'package:dacntt1_mobile_admin/view_model/report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'view/Web/dashboard_web.dart';
import 'view/Mobile/dashboard_mobile.dart';
import 'view_model/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  runApp(MyApp(isLoggedIn: true));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginModel()),
        ChangeNotifierProvider(create: (_) => DashboardModel()),
        ChangeNotifierProvider(create: (_) => NewEmployee()),
        ChangeNotifierProvider(create: (_) => ListOrderModel()),
        ChangeNotifierProvider(create: (_) => InventoryOverallModel()),
        ChangeNotifierProvider(create: (_) => ReportModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLoggedIn
            ? (kIsWeb
            ? DashboardWeb(navigatorKey: GlobalKey<NavigatorState>())
            : DashboardMobile(navigatorKey: GlobalKey<NavigatorState>(),))
            : (kIsWeb
            ? WebLogin()
            : MobileLogin()),
      ),
    );
  }
}
