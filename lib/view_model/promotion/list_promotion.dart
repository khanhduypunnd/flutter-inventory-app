import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../shared/core/theme/colors_app.dart';
import '../../../data/promotion.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/core/services/uriApi.dart';

class ListPromotionModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();

  int rowsPerPage = 20;
  int currentPage = 1;
  int totalPromotions = 0;
  List<Map<String, dynamic>> promotions = [];
  bool isLoading = false;

  List<bool> selectedRows = [];
  bool selectAll = false;

  Future<void> fetchPromotions(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(uriAPIService.apiUrlGiftCode);
      final response = await http.get(url);

      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        promotions = jsonData.map((data) {
          final promotion = Promotion.fromJson(data);
          return {
            "id": promotion.id,
            "code": promotion.code,
            "description": promotion.description,
            "value": promotion.value.toString(),
            "value_limit": promotion.valueLimit.toString(),
            "beginning": promotion.beginning.toIso8601String(),
            "expiration": promotion.expiration.toIso8601String() ?? '',
          };
        }).toList();
        totalPromotions = promotions.length;
        selectedRows = List<bool>.filled(promotions.length, false);
      } else {
        throw Exception('Failed to fetch promotions: ${response.statusCode}');
      }
    } catch (error) {
      showCustomToast(context, 'Lỗi khi tải dữ liệu');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterPromotions(String query) {
    promotions = promotions.where((promotion) {
      final id = promotion["id"].toLowerCase();
      final description = promotion["description"].toLowerCase();
      return id.contains(query.toLowerCase()) ||
          description.contains(query.toLowerCase());
    }).toList();
    totalPromotions = promotions.length;
    notifyListeners();
  }

  void updateRowsPerPage(int value) {
    rowsPerPage = value;
    currentPage = 1;
  }

  void toggleSelectAll(bool? value) {
    selectAll = value ?? false;
    selectedRows = List<bool>.filled(promotions.length, selectAll);
  }

  void toggleRowSelection(int index, bool? value) {
    selectedRows[index] = value ?? false;
    selectAll = selectedRows.every((isSelected) => isSelected);
  }

  Future<void> deleteSelectedRows(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final selectedIds = promotions
          .asMap()
          .entries
          .where((entry) => selectedRows[entry.key])
          .map((entry) => entry.value["id"])
          .toList();

      for (String id in selectedIds) {
        final url = Uri.parse('${uriAPIService.apiUrlGiftCode}/$id');
        final response = await http.delete(url);

        if (response.statusCode != 200) {
          throw Exception('Failed to delete promotion with ID $id');
        }
      }

      promotions = promotions
          .asMap()
          .entries
          .where((entry) => !selectedRows[entry.key])
          .map((entry) => entry.value)
          .toList();
      selectedRows = List<bool>.filled(promotions.length, false);
      selectAll = false;

      showCustomToast(context, 'Đã xóa các mục được chọn');
    } catch (error) {
      showCustomToast(context, 'Xóa mã thất bại');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void showCustomToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
