import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/customer.dart';
import '../../shared/core/services/uriApi.dart';

class CustomerModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();


  late int rowsPerPage = 20;
  int currentPage = 1;
  int totalCustomers = 1000000;
  List<Customer> customers = [];
  List<Customer> displayedCustomers = [];
  List<Customer> filteredCustomers = [];
  String searchQuery = "";

  bool isLoading = false;

  Future<void> fetchCustomers() async {
    if (customers.isNotEmpty) {
      _updateDisplayedCustomers();
      return;
    }
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
        filteredCustomers = List.from(customers);
        _updateDisplayedCustomers();
      } else {
        throw Exception('Failed to fetch customers: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching customers: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void onSearchCustomer(String query) {
    searchQuery = query.toLowerCase().trim();

    if (query.isEmpty) {
      filteredCustomers = List.from(customers);
    } else {
      filteredCustomers = customers.where((customer) {
        return customer.name.toLowerCase().contains(searchQuery) ||
            customer.phone.toLowerCase().contains(searchQuery);
      }).toList();
    }

    _updateDisplayedCustomers();
    notifyListeners();
  }


  void _updateDisplayedCustomers() {
    int startIndex = (currentPage - 1) * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;

    List<Customer> sourceList = searchQuery.isEmpty ? customers : filteredCustomers;

    displayedCustomers = sourceList.sublist(
        startIndex, endIndex > sourceList.length ? sourceList.length : endIndex);
    notifyListeners();
  }

  void setRowsPerPage(int value) {
    rowsPerPage = value;
    currentPage = 1;
    _updateDisplayedCustomers();
  }

  void goToPage(int page) {
    if (page > 0 && page <= totalPages) {
      currentPage = page;
      _updateDisplayedCustomers();
    }
  }

  int get totalPages => (customers.length / rowsPerPage).ceil();
}
