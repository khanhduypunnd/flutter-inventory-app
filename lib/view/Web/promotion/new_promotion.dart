import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../icon_pictures.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../data/promotion.dart';

class NewPromotion extends StatefulWidget {
  const NewPromotion({super.key});

  @override
  State<NewPromotion> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<NewPromotion> {
  final _promotionCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _valuelimitController = TextEditingController();
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  bool _hasEndDate = false;
  bool _haslimit_promotion = false;
  String? _selectedType;
  int _currentId = 1;

  String _generateId() {
    return _currentId.toString().padLeft(6, '0');
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate! : _endDate!,
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
              TimeOfDay.fromDateTime(isStart ? _startDate! : _endDate!),
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
          setState(() {
            if (isStart) {
              _startDate = DateTime(
                  date.year, date.month, date.day, time.hour, time.minute);
            } else {
              _endDate = DateTime(
                  date.year, date.month, date.day, time.hour, time.minute);
            }
          });
        }
      }
    }
  }

  bool _validateForm() {
    if (_promotionCodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mã khuyến mãi không được để trống!')),
      );
      return false;
    }

    if (_valueController.text.trim().isEmpty ||
        double.tryParse(_valueController.text.trim()) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mức giảm không hợp lệ!')),
      );
      return false;
    }

    return true;
  }

  void _submitPromotion() async {
    if (!_validateForm()) return;
    try {
      final value = double.tryParse(_valueController.text.trim()) ?? 0.0;

      final promotionData = {
        'gCId': _generateId(),
        'code': _promotionCodeController.text,
        'description': _descriptionController.text,
        'value': double.tryParse(_valueController.text) ?? 0.0,
        'value_limit': _haslimit_promotion
            ? double.tryParse(_valuelimitController.text.trim()) ?? 0.0
            : 0.0,
        'beginning': _startDate!.toUtc().toIso8601String(),
        'expiration': _endDate?.toUtc().toIso8601String(),
      };

      if (kDebugMode) {
        print('Dữ liệu JSON: ${json.encode(promotionData)}');
      }

      final url = Uri.parse('https://dacntt1-api-server-4rtx90o6z-haonguyen9191s-projects.vercel.app/api/giftCodes');
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
      if (kDebugMode) {
        print('Lỗi khi gửi dữ liệu: $e');
      }
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
    _promotionCodeController.clear();
    _descriptionController.clear();
    _valueController.clear();
    _valuelimitController.clear();
    setState(() {
      _selectedType = null;
      _hasEndDate = false;
      _haslimit_promotion = false;
      _startDate = DateTime.now();
      _endDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: _submitPromotion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text('Lưu', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Mã khuyến mãi',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _promotionCodeController,
                      decoration: InputDecoration(
                        hintText: 'Nhập mã khuyến mãi',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Mô tả',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Nhập mô tả',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Expanded(
                          flex: 2,
                          child: Text('Thời gian bắt đầu'),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextButton(
                            onPressed: () => _selectDateTime(context, true),
                            child: Text(
                              "${_startDate!.toLocal()}".split('.')[0],
                              style: const TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Expanded(
                          flex: 2,
                          child: Text('Thời gian kết thúc'),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextButton(
                            onPressed: () => _selectDateTime(context, false),
                            child: Text(
                              "${_endDate!.toLocal()}".split('.')[0],
                              style: const TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
              _build_promotion_bill_percern(),
          ],
        ),
      ),
    );
  }

  Widget _build_promotion_bill_percern() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Giảm giá đơn hàng',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            const SizedBox(
              height: 10,
            ),
            const Text('Mức giảm', style: TextStyle(fontSize: 16)),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _valueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                          final intValue = int.tryParse(newValue.text) ?? 0;
                          if (intValue >= 0 && intValue <= 100) {
                            return newValue;
                          }
                          return oldValue;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text('%'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                    value: _haslimit_promotion,
                    activeColor: Colors.blueAccent,
                    onChanged: (bool? value) {
                      setState(() {
                        _haslimit_promotion = value!;
                      });
                    }),
                const Text('Giới hạn số tiền giảm tối đa'),
              ],
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: _haslimit_promotion,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _valuelimitController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0đ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueAccent,
                              width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        TextInputFormatter.withFunction(
                              (oldValue, newValue) {
                            final intValue = int.tryParse(newValue.text) ?? 0;
                            if (intValue >= 0) {
                              return newValue;
                            }
                            return oldValue;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
