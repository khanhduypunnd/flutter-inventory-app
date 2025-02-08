import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../data/customer.dart';
import '../data/order.dart';

class ListOrderModel extends ChangeNotifier{
  List<Order> orders = [];
  List<Customer> customers = [];

  int rowsPerPage = 20;
  int currentPage = 1;
  int totalOrders = 50;
  bool isLoading = false;

  Future<void> fetchOrders() async{
    isLoading = true;
    notifyListeners();

    final int startIndex = (currentPage - 1) * rowsPerPage;
    final String apiUrl =
        'https://dacntt1-api-server-5nhee8ay7-haonguyen9191s-projects.vercel.app/api/orders';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Order> allOrders = jsonData.map((data) => Order.fromJson(data)).toList();

        List<Order> filteredOrders = allOrders.toList();
        filteredOrders.sort((a, b) => b.date.compareTo(a.date));
        orders = filteredOrders;

        totalOrders = orders.length;

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

  Future<void> fetchCustomers() async {
    isLoading = true;
    try {
      final url = Uri.parse(
          'https://dacntt1-api-server-5nhee8ay7-haonguyen9191s-projects.vercel.app/api/customers');
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

  String getCustomerName(String cid) {
    final customer = customers.firstWhere(
          (c) => c.cid == cid,
      orElse: () => Customer(id: '', cid: '', name: 'Không xác định', email: '', dob: DateTime.now(), pass: '',phone: '', address: ''),
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



}