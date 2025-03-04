import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/gan.dart';
import '../../shared/core/services/uriApi.dart';

class AdjustInventoryListModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();

  int rowsPerPage = 20;
  int currentPage = 1;
  List<Map<String, dynamic>> adjustments = [];
  List<Map<String, dynamic>> displayedAdjustments = [];
  List<Map<String, dynamic>> adjustments_details = [];
  bool isLoading = false;

  Future<void> fetchAdjustments() async {
    if (adjustments.isNotEmpty) {
      _updateDisplayedAdjustments();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(uriAPIService.apiUrlGan);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        adjustments =
            (data as List<dynamic>? ?? []).map<Map<String, dynamic>>((item) {
          final adjustment = GAN(
            ganId: item['ganId'] ?? '',
            staffId: item['sId'] ?? '',
            date: DateTime.fromMillisecondsSinceEpoch(
                    item['date']['_seconds'] * 1000).toUtc(),
            increasedQuantity: item['increasedQuantity'] ?? 0,
            decreasedQuantity: item['descreaedQuantity'] ?? 0,
            note: item['note'] ?? '',
          );

          final details = (item['details'] as List<dynamic>? ?? [])
              .map<Map<String, dynamic>>((detail) {
            final adjustmentsDetail = GANDetail(
              ganId: detail['ganId'] ?? '',
              productId: detail['pid'] ?? '',
              size: (detail['size'] as List<dynamic>?)
                      ?.map((s) => s.toString())
                      .toList() ??
                  [],
              oldQuantity:
                  int.tryParse(detail['oldQuantity']?.toString() ?? '0') ?? 0,
              newQuantity:
                  int.tryParse(detail['newQuantity']?.toString() ?? '0') ?? 0,
            );

            return {
              "ganId": adjustmentsDetail.ganId,
              "pid": adjustmentsDetail.productId,
              "size": adjustmentsDetail.size,
              "oldQuantity": adjustmentsDetail.oldQuantity,
              "newQuantity": adjustmentsDetail.newQuantity,
            };
          }).toList();

          return {
            "ganId": adjustment.ganId,
            "sId": adjustment.staffId,
            "date": adjustment.date.toIso8601String(),
            "increasedQuantity": adjustment.increasedQuantity,
            "decreasedQuantity": adjustment.decreasedQuantity,
            "note": adjustment.note,
            "details": details,
          };
        }).toList();

        adjustments.sort((a, b) {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA);
        });

        _updateDisplayedAdjustments();
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (error) {
      print('Error fetching adjustments: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _updateDisplayedAdjustments() {
    int startIndex = (currentPage - 1) * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    displayedAdjustments = adjustments.sublist(
        startIndex, endIndex > adjustments.length ? adjustments.length : endIndex);
    notifyListeners();
  }

  void filterAdjustments(String query) {
    if (query.isEmpty) {
      _updateDisplayedAdjustments();
      return;
    }

    displayedAdjustments = adjustments.where((adjustment) {
      return adjustment["ganId"].toString().contains(query) ||
          adjustment["sId"].toString().contains(query);
    }).toList();

    notifyListeners();
  }


  void setRowsPerPage(int value) {
    rowsPerPage = value;
    currentPage = 1;
    _updateDisplayedAdjustments();
  }

  void goToPage(int page) {
    if (page > 0 && page <= totalPages) {
      currentPage = page;
      _updateDisplayedAdjustments();
    }
  }

  int get totalPages => (adjustments.length / rowsPerPage).ceil();
}
