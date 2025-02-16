import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/core/services/uriApi.dart';

class NewPromotionModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();

  final TextEditingController promotionCodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController valuelimitController = TextEditingController();
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  bool hasEndDate = false;
  bool haslimit_promotion = false;
  String? selectedType;
  int currentId = 1;

  String _generateId() {
    return currentId.toString().padLeft(6, '0');
  }

  Future<void> selectDateTime(BuildContext context, bool isStart) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate! : endDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blueAccent,
            hintColor: Colors.blueAccent,
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      if (context.mounted) {
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(isStart ? startDate! : endDate!),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.blueAccent,
                colorScheme: const ColorScheme.light(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          },
        );

        if (time != null) {
          if (isStart) {
            startDate = DateTime(
                date.year, date.month, date.day, time.hour, time.minute);
          } else {
            endDate = DateTime(
                date.year, date.month, date.day, time.hour, time.minute);
          }
        }
      }
    }
    notifyListeners();
  }

  bool validateForm(BuildContext context) {
    if (promotionCodeController.text.trim().isEmpty) {
      showCustomToast(context, 'Mã khuyến mãi không được để trống!');
      notifyListeners();
      return false;
    }

    if (valueController.text.trim().isEmpty ||
        double.tryParse(valueController.text.trim()) == null) {
      showCustomToast(context, 'Mức giảm không hợp lệ!');
      notifyListeners();
      return false;
    }

    return true;
  }

  Future<void> submitPromotion(BuildContext context) async {
    if (!validateForm(context)) return;
    try {
      final value = double.tryParse(valueController.text.trim()) ?? 0.0;

      final promotionData = {
        'gCId': _generateId(),
        'code': promotionCodeController.text,
        'description': descriptionController.text,
        'value': double.tryParse(valueController.text) ?? 0.0,
        'value_limit': haslimit_promotion
            ? double.tryParse(valuelimitController.text.trim()) ?? 0.0
            : 0.0,
        'beginning': startDate!.toUtc().toIso8601String(),
        'expiration': endDate?.toUtc().toIso8601String(),
      };

      final url = Uri.parse(uriAPIService.apiUrlGiftCode);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(promotionData),
      );

      if (response.statusCode == 201) {
        showCustomToast(context, 'Tạo khuyến mãi thành công!');
        _clearForm();
      } else {
        final errorMessage = response.body.isNotEmpty
            ? json.decode(response.body)['message']
            : 'Lỗi không xác định';
        showCustomToast(context, 'Lỗi: $errorMessage');
      }
    } catch (e) {
      showCustomToast(context, 'Có lỗi xảy ra: $e');
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

  void _clearForm() {
    promotionCodeController.clear();
    descriptionController.clear();
    valueController.clear();
    valuelimitController.clear();
    selectedType = null;
    hasEndDate = false;
    haslimit_promotion = false;
    startDate = DateTime.now();
    endDate = DateTime.now();
    notifyListeners();
  }
}
