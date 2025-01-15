import 'package:dacntt1_mobile_admin/view/Web/dashboard_web.dart';
import 'package:dacntt1_mobile_admin/view/mobile/dashboard_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'tilte',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return DashboardWeb(navigatorKey: navigatorKey,);
    } else {
      return DashboardMobile(navigatorKey: navigatorKey);
    }
  }
}
