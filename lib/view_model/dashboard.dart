import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../data/order.dart';
import '../data/product.dart';

class DashboardModel extends ChangeNotifier{
  List<Order> listOrders =[];
  List<Product> listProducts = [];

  int outOfStock = 0;
  double revenue = 0.0;

  int productQuantity = 0;
  int orderQuantity = 0;

  bool isLoading = false;

  Future<void> fetchOrders() async{
    isLoading = true;
    notifyListeners();

    final String apiUrl =
        'https://dacntt1-api-server-5nhee8ay7-haonguyen9191s-projects.vercel.app/api/orders';

    try {

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Order> allOrders = jsonData.map((data) => Order.fromJson(data)).toList();

        DateTime today = DateTime.now();
        String todayString = "${today.year}-${today.month}-${today.day}";

        List<Order> filteredOrders = allOrders.where((order) {
          DateTime orderDate = order.date;
          String orderDateString = "${orderDate.year}-${orderDate.month}-${orderDate.day}";
          return orderDateString == todayString;
        }).toList();

        filteredOrders.sort((a, b) => b.date.compareTo(a.date));
        listOrders = filteredOrders;
        revenue = listOrders.fold(0, (sum, order) =>sum + order.receivedMoney);
        orderQuantity = listOrders.length;
        notifyListeners();
      } else {
        if (kDebugMode) {
          print('Failed to fetch orders: ${response.statusCode}');
        }
      }
    }catch (error) {
      if (kDebugMode) {
        print('Error fetching orders: $error');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    if (listProducts.isNotEmpty) return;
    isLoading = true;

    try {
      final url = Uri.parse(
          'https://dacntt1-api-server-5nhee8ay7-haonguyen9191s-projects.vercel.app/api/products');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final products =
        jsonData.map((data) => Product.fromJson(data)).toList();

        listProducts.clear();
        listProducts.addAll(products);

        // productQuantity = listProducts.length;
        // outOfStock = listProducts.fold<int>(0, (sum, product) {
        //   return sum + product.quantities.where((q) => q == 0).length;
        // });
        for (var product in listProducts){
          for(var quantity  in product.quantities){
            if(quantity == 0){
              outOfStock ++;
            }else{
              productQuantity += quantity;
            }
          }
        }

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

  Map<int, double> getRevenueByHour() {
    Map<int, double> revenueByHour = {};

    for (var order in listOrders) {
      int hour = order.date.hour;
      revenueByHour[hour] = (revenueByHour[hour] ?? 0) + order.receivedMoney.toDouble();
    }
    return revenueByHour;
  }


  String formatPriceDouble(double price) {
    final format = NumberFormat("#,##0", "en_US");
    return format.format(price);
  }
  String formatPriceInt(int price) {
    final format = NumberFormat("#,##0", "en_US");
    return format.format(price);
  }
}