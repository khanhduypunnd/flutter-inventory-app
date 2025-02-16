//Web
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/product.dart';
import '../../../view/Web/customer/list_customer/list_customer.dart';
import '../../../view/Web/dashboard/dashboard.dart';
import '../../../view/Web/dashboard_web.dart';
import '../../../view/Web/inventory/adjust_history/adjust_inven_detail.dart';
import '../../../view/Web/inventory/adjust_history/adjust_inventory_history.dart';
import '../../../view/Web/inventory/adjust_inventory/adjust_inventory.dart';
import '../../../view/Web/inventory/inventory_overall/inventory_overall.dart';
import '../../../view/Web/login/login_view.dart';
import '../../../view/Web/order/list_order.dart';
import '../../../view/Web/product/list_product/list_product.dart';
import '../../../view/Web/product/new_product/new_product.dart';
import '../../../view/Web/product/product_detail/product_detail.dart';
import '../../../view/Web/promotion/list_promotion.dart';
import '../../../view/Web/promotion/new_promotion.dart';
import '../../../view/Web/report/analysis.dart';
import '../../../view/Web/setting/account/account.dart';
import '../../../view/Web/setting/employee/employee_management.dart';
import '../../../view/Web/setting/setting_screen.dart';
import '../wrapper/staff_data_wrapper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/login',
    redirect: (BuildContext context, GoRouterState state) {
      final staffData = StaffDataWrapper.of(context)?.staffData;
      final loggingIn = state.uri.path == '/login';

      if (staffData != null && loggingIn) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const WebLogin(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final staffData = state.extra is Map<String, dynamic>
              ? state.extra as Map<String, dynamic>
              : null;
          return StaffDataWrapper(
            staffData: staffData,
            child: InventoryWeb(
              child: child,
              staffData: staffData,
              navigatorKey: navigatorKey,
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) {
              return DashboardPage();
            },
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) {
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return ListProduct(staffData: staffData);
            },
          ),
          GoRoute(
            path: '/product_detail/:id',
            builder: (context, state) {
              final product = state.extra as Product;
              return ProductDetailView(
                  product: product,
              );
            },
          ),
          GoRoute(
            path: '/new_products',
            builder: (context, state) {
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return NewProduct(staffData: staffData);
            },
          ),
          GoRoute(
            path: '/customers',
            builder: (context, state) {
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return CustomerList(staffData: staffData);
            },
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) {
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return ListOrder(staffData: staffData);
            },
          ),
          GoRoute(
            path: '/adjusts',
            builder: (context, state) {
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return AdjustInventoryHistory(staffData: staffData);
            },
          ),
          GoRoute(
            path: '/adjust_detail/:ganId',
            builder: (context, state) {
              final ganData = state.extra as Map<String, dynamic>;
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return AdjustInventoryDetail(
                ganData: ganData,
                ganDetails: ganData["details"],
                  staffData: staffData
              );
            },
          ),
          GoRoute(
            path: '/new_adjust',
            builder: (context, state) {
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return AdjustInventory(
                staffData: staffData,
              );
            },
          ),
          GoRoute(
            path: '/adjust_overview',
            builder: (context, state) {
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return InventoryOverall(staffData: staffData);
            },
          ),
          GoRoute(
            path: '/promotions',
            builder: (context, state) {
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return ListPromotion(staffData: staffData);
            },
          ),
          GoRoute(
            path: '/new_promotion',
            builder: (context, state) {
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return NewPromotion(staffData: staffData);
            },
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) {
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return Analysis(staffData: staffData);
            },
          ),
          GoRoute(
            path: '/setting',
            builder: (context, state) {
              final staffData = StaffDataWrapper.of(context)?.staffData;
              return SettingScreen(staffData: staffData);
            },
          ),
          GoRoute(
            path: '/staffs',
            builder: (context, state) => const EmployeeManagement(),
          ),
          GoRoute(
            path: '/account',
            builder: (context, state) {
              final staffData = state.extra as Map<String, dynamic>?;
              return Account(staffData: staffData);
            },
          ),
        ],
      ),
    ],
  );
}
