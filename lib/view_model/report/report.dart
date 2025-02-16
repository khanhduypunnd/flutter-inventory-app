import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../data/order.dart';
import '../../data/product.dart';
import '../../shared/core/services/uriApi.dart';

class ReportModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();

  List<Product> listProducts = [];
  List<Order> listOrders = [];

  List<Order> filteredOrders1 = [];
  List<Order> filteredOrders2 = [];

  List<Product> filteredProduct1 = [];
  List<Product> filteredProduct2 = [];

  bool isLoading = false;

  //bussiness_analysis
  double orderQuantityPercent = 0.0;
  double netRevenue = 0.0;
  double receivedMoney = 0.0;
  double netRevenuePercent = 0.0;
  double receivedMoneyPercent = 0.0;

  //inventory_analysis
  double inOfStock = 0.0;
  double outOfStock = 0.0;
  double residualValue = 0.0;
  int productNumberSold = 0;
  double productNumberSoldPercent = 0.0;

  List<MapEntry<String, int>> bestSellingProducts = [];


  Timer? _debounce;



  Future<void> fetchProducts() async {
    if (listProducts.isNotEmpty) return;
    isLoading = true;

    try {
      final url = Uri.parse(uriAPIService.apiUrlProduct);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final products =
            jsonData.map((data) => Product.fromJson(data)).toList();

        listProducts.clear();
        listProducts.addAll(products);

        inOfStock = listProducts.fold(0, (sum, product) {
          return sum +
              product.quantities
                  .where((q) => q > 0)
                  .fold<int>(0, (subSum, q) => subSum + q);
        });

        residualValue = listProducts.fold<double>(0.0, (sum, product) {
          return sum +
              product.quantities
                  .asMap()
                  .entries
                  .where((entry) => entry.value > 0)
                  .fold<double>(
                      0.0,
                      (subSum, entry) =>
                          subSum +
                          (product.actualPrices[entry.key] *
                              entry.value));
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error loading products: $error');
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> fetchComparisonData(
      DateTime start1, DateTime end1, DateTime start2, DateTime end2) async {

    _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () async {
      isLoading = true;
      notifyListeners();

      String apiUrl = uriAPIService.apiUrlOrder;


      try {
        final response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {

          final List<dynamic> jsonData = json.decode(response.body);

          List<Order> allOrders =
          jsonData.map((data) => Order.fromJson(data)).toList();

          filteredOrders1.clear();
          filteredOrders2.clear();
          listOrders.clear();
          bestSellingProducts.clear();

          filteredOrders1 = allOrders.where((order) {
            return order.date.isAfter(start1.subtract(Duration(days: 1))) &&
                order.date.isBefore(end1.add(Duration(days: 1)));
          }).toList();

          filteredOrders2 = allOrders.where((order) {
            return order.date.isAfter(start2) && order.date.isBefore(end2);
          }).toList();

          orderQuantityPercent = calculatePercentageChangeInt(
              filteredOrders1.length, filteredOrders2.length);

          double totalReceived1 = filteredOrders1.fold(
              0.0, (sum, order) => sum + order.receivedMoney.toDouble());
          double totalReceived2 = filteredOrders2.fold(
              0.0, (sum, order) => sum + order.receivedMoney.toDouble());
          double totalRevenue1 = filteredOrders1.fold(
              0.0, (sum, order) => sum + order.totalPrice.toDouble());
          double totalRevenue2 = filteredOrders2.fold(
              0.0, (sum, order) => sum + order.totalPrice.toDouble());

          receivedMoney = totalReceived1;
          netRevenue = totalRevenue1;

          receivedMoneyPercent =
              calculatePercentageChangeDouble(totalReceived1, totalReceived2);
          netRevenuePercent =
              calculatePercentageChangeDouble(totalRevenue1, totalRevenue2);
          orderQuantityPercent = calculatePercentageChangeInt(
              filteredOrders1.length, filteredOrders2.length);

          //inventory_analysis
          int productNumberSold1 = filteredOrders1.fold<int>(0, (sum, order) {
            return sum +
                order.orderDetails.fold<int>(0, (detailSum, detail) {
                  return detailSum + detail.quantity;
                });
          });
          int productNumberSold2 = filteredOrders2.fold<int>(0, (sum, order) {
            return sum +
                order.orderDetails.fold<int>(0, (detailSum, detail) {
                  return detailSum + detail.quantity;
                });
          });

          productNumberSold = productNumberSold1;

          productNumberSoldPercent = calculatePercentageChangeInt(
              productNumberSold1, productNumberSold2);

          listOrders = {
            for (var order in [...filteredOrders1, ...filteredOrders2])
              order.id: order
          }.values.toList();

          getPaymentMethodData(listOrders);

          List<MapEntry<String, int>> rawBestSellingSizes =
          getTop5BestSellingSizes(
              [...filteredOrders1, ...filteredOrders2], listProducts);

          bestSellingProducts = rawBestSellingSizes.map((entry) {
            List<String> parts = entry.key.split('-');
            String productId = parts[0];
            String size = parts.length > 1 ? parts[1] : "N/A";

            Product? product = getProductById(productId);

            return MapEntry("${product?.name} - $size", entry.value);
          }).toList();

        } else {
          print('Lỗi khi lấy dữ liệu đơn hàng: ${response.statusCode}');
        }
      } catch (error) {
        print('Lỗi khi gọi API: $error');
      }

      isLoading = false;
      notifyListeners();
    });
  }

  Map<String, double> getPaymentMethodData(List<Order> filteredOrders) {
    Map<String, double> paymentData = {};

    for (var order in filteredOrders) {
      String method = order.paymentMethod;
      double amount = order.actualReceived;

      if (paymentData.containsKey(method)) {
        paymentData[method] = paymentData[method]! + amount;
      } else {
        paymentData[method] = amount;
      }
    }
    return paymentData;
  }

  List<MapEntry<String, int>> getTop5BestSellingSizes(
      List<Order> orders, List<Product> listProducts) {
    Map<String, int> sizeSales = {};

    for (Order order in orders) {
      for (OrderDetail detail in order.orderDetails) {
        String key = "${detail.productId}-${detail.size}";
        int quantity = detail.quantity;

        sizeSales.update(key, (existingQuantity) => existingQuantity + quantity,
            ifAbsent: () => quantity);
      }
    }

    List<MapEntry<String, int>> sortedSizes = sizeSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedSizes.take(5).toList();
  }

  double calculatePercentageChangeInt(int value1, int value2) {
    if (value1 == 0) {
      return value2 > 0 ? -100.0 : 0.0;
    }
    return ((value1 - value2) / value1) * 100;
  }

  double calculatePercentageChangeDouble(double value1, double value2) {
    if (value1 == 0) {
      return value2 > 0 ? -100.0 : 0.0;
    }
    return ((value1 - value2) / value1) * 100;
  }

  Product? getProductById(String productId) {
    return listProducts.firstWhere((product) => product.id == productId);
  }

  String formatCurrencyDouble(double amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return formatter.format(amount);
  }

  String formatCurrencyInt(int amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return formatter.format(amount);
  }
}
