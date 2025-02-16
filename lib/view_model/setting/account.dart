import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/employee.dart';
import '../../shared/core/services/uriApi.dart';

class AccountModel extends ChangeNotifier {
  final ApiService uriAPIService = ApiService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController1 = TextEditingController();
  final TextEditingController newPassController2 = TextEditingController();

  Staff? staff;

  bool isLoading = false;

  void setStaffData(Map<String, dynamic> staffData) {
    usernameController.text = staffData['email'];
    nameController.text = staffData['name'];
    phoneController.text = staffData['phone'];
    positionController.text = staffData['role'];
    notifyListeners();
  }

  Future<void> sendStaff(
      BuildContext context, Map<String, dynamic> staffData) async {
    String apiUrl = uriAPIService.apiUrlStaffRegister;
    if (positionController.text.toLowerCase() == 'admin') {
      showCustomToast(context, 'Chức vụ không được là admin');
      notifyListeners();
      return;
    }

    Staff staff = Staff(
      sid: staffData['id'],
      name: nameController.text,
      email: usernameController.text,
      phoneNumber: phoneController.text,
      password: passwordController.text,
      role: positionController.text,
      roleDetail: staffData['role_detail'],
    );

    try {
      isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(staff.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('Staff sent successfully: ${response.body}');
        }

        showCustomToast(context, 'Cập nhật nhân viên thành công');
      } else {
        if (kDebugMode) {
          print('Failed to send staff data: ${response.statusCode}');
          print('Response: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error sending staff data: $error');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> fetchStaffById(BuildContext context, String staffId) async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse("${uriAPIService.apiUrlStaff}/$staffId");
      final response = await http.get(url);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        staff = Staff.fromJson(jsonData);

        notifyListeners();
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nhân viên không tồn tại')),
        );
      } else {
        throw Exception(
            'Lỗi khi tải thông tin nhân viên: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu: $error')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePass(BuildContext context, String staffId) async {
    isLoading = true;
    notifyListeners();

    try {
      await fetchStaffById(context, staffId);

      if (staff == null) {
        showCustomToast(context, 'Nhân viên không tồn tại');
        return;
      }

      final currentPass = currentPassController.text;
      final hashedPass = staff!.password;

      if (!BCrypt.checkpw(currentPass, hashedPass)) {
        showCustomToast(context, 'Mật khẩu hiện tại không đúng');
        return;
      }

      final newPass1 = newPassController1.text;
      final newPass2 = newPassController2.text;

      if (newPass1 != newPass2) {
        showCustomToast(context, 'Mật khẩu mới không khớp nhau');
        return;
      }

      Staff newPass = Staff(
          sid: staffId,
          name: staff!.name,
          email: staff!.email,
          phoneNumber: staff!.phoneNumber,
          password: newPassController1.text,
          role: staff!.role,
          roleDetail: staff!.roleDetail);

      final url = Uri.parse("${uriAPIService.apiUrlStaff}/$staffId");
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({newPass}),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        showCustomToast(context, 'Đổi mật khẩu thành công');
      } else {
        throw Exception('Lỗi khi cập nhật mật khẩu: ${response.statusCode}');
      }
    } catch (error) {
      showCustomToast(context, 'Lỗi khi đổi mật khẩu');
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
