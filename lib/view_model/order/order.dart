import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../data/customer.dart';
import '../../data/order.dart';
import '../../shared/core/services/uriApi.dart';

class ListOrderModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();

  List<Order> orders = [];
  List<Customer> customers = [];

  String searchQuery = "";
  List<Order> filteredOrders = [];


  int rowsPerPage = 20;
  int currentPage = 1;
  List<Order> displayedOrders = [];
  bool isLoading = false;

  Future<void> fetchOrders() async {
    if (orders.isNotEmpty) {
      _updateDisplayedOrders();
      return;
    }
    isLoading = true;
    notifyListeners();

    final String apiUrl = uriAPIService.apiUrlOrder;

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Order> allOrders =
            jsonData.map((data) => Order.fromJson(data)).toList();

        List<Order> filteredOrders = allOrders.toList();

        filteredOrders.sort((a, b) => b.date.compareTo(a.date));

        orders = filteredOrders;

        _updateDisplayedOrders();

        notifyListeners();
      } else {
        if (kDebugMode) {
          print('Failed to fetch orders: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching orders: $error');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void _updateDisplayedOrders() {
    int startIndex = (currentPage - 1) * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (orders.isEmpty) {
      displayedOrders = [];
    } else {
      displayedOrders = orders.sublist(
        startIndex,
        endIndex > orders.length ? orders.length : endIndex,
      );
    }
    notifyListeners();
  }

  void setRowsPerPage(int value) {
    rowsPerPage = value;
    currentPage = 1;
    _updateDisplayedOrders();
  }

  void goToPage(int page) {
    if (page > 0 && page <= totalPages) {
      currentPage = page;
      _updateDisplayedOrders();
    }
  }

  int get totalPages => (orders.length / rowsPerPage).ceil();

  Future<void> fetchCustomers() async {
    isLoading = true;
    notifyListeners();
    try {
      final url = Uri.parse(uriAPIService.apiUrlCustomer);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final customer =
            jsonData.map((data) => Customer.fromJson(data)).toList();
        customers.clear();
        customers.addAll(customer);
      } else {
        throw Exception('Failed to fetch customers: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching customers: $error');
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  String getCustomerName(String id) {
    final customer = customers.firstWhere(
      (c) => c.id == id,
      orElse: () => Customer(
          id: '',
          cid: '',
          name: 'Không xác định',
          email: '',
          dob: DateTime.now(),
          pass: '',
          phone: '',
          address: ''),
    );
    return customer.name;
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return "Đã đặt";
      case 1:
        return "Đã nhận đơn";
      case 2:
        return "Đang chuẩn bị đơn";
      case 3:
        return "Đang giao";
      case 4:
        return "Đã nhận";
      case 5:
        return "Đã hủy";
      default:
        return "Không xác định";
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.amber;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.green;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatPrice(double price) {
    final format = NumberFormat("#,##0", "en_US");
    return format.format(price);
  }

  void onSearchOrder(String query) {
    searchQuery = query.toLowerCase().trim();

    print("Search query: $searchQuery");
    print("Total orders: ${orders.length}");

    if (query.isEmpty) {
      filteredOrders = orders;
    } else {
      filteredOrders = orders.where((order) {
        return order.id.toLowerCase().contains(searchQuery);
      }).toList();
    }

    _updateDisplayedOrders();
    notifyListeners();
  }


}
