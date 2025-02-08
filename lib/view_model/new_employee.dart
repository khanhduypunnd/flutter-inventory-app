import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/employee.dart';

class NewEmployee with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  bool isAddingStaff = false;

  bool isLoading = false;

  String newStaffId = "S0001";

  List<int> rolePermissions = List.filled(12, 0);

  List<Staff> staffs =[];

  void toggleAddingStaff(bool value) {
    isAddingStaff = value;
    notifyListeners();
  }

  void updateRolePermission(int index, int value) {
    rolePermissions[index] = value;
    notifyListeners();
  }

  Future<void> fetchLatestStaffId() async {
    final String apiUrl =
        'https://dacntt1-api-server-5nhee8ay7-haonguyen9191s-projects.vercel.app/api/staffs';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> staffList = jsonDecode(response.body);

        if (staffList.isNotEmpty) {
          List<String> ids = staffList.map<String>((staff) => staff['id']).toList();

          ids.sort((a, b) => b.compareTo(a));

          String latestId = ids.first;

          newStaffId = generateNextStaffId(latestId);
        } else {
          newStaffId = "S0001";
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch staff list: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching staff ID: $error');
      }
    }

    notifyListeners();
  }

  String generateNextStaffId(String latestId) {
    final int currentNumber = int.parse(latestId.substring(1));
    final int nextNumber = currentNumber + 1;
    return "S${nextNumber.toString().padLeft(4, '0')}";
  }

  Future<void> sendStaff(BuildContext context) async {
    String apiUrl =
        'https://dacntt1-api-server-5nhee8ay7-haonguyen9191s-projects.vercel.app/api/staffs/register';

    Staff newStaff = Staff(
      sid: newStaffId,
      name: nameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      password: passwordController.text,
      role: roleController.text,
      roleDetail: List.from(rolePermissions),
    );

    try {

      isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newStaff.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('Staff sent successfully: ${response.body}');
        }

        Navigator.of(context).pop;

        clearFields();

        showCustomToast(context, 'Tạo nhân viên thành công');

        await fetchStaffs();

        await fetchLatestStaffId();
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
    } finally{
      isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> fetchStaffs() async{
    String api = 'https://dacntt1-api-server-5nhee8ay7-haonguyen9191s-projects.vercel.app/api/staffs';

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(api));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        staffs = data.map((item) => Staff.fromJson(item)).toList();

        notifyListeners();
      } else {
        if (kDebugMode) {
          print('Failed to fetch staff list: ${response.statusCode}');
        }
      }
    }catch (error) {
      if (kDebugMode) {
        print('Error fetching staff list: $error');
      }
    } finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteStaff(BuildContext context,String sid) async {
    final String apiUrl =
        'https://dacntt1-api-server-5nhee8ay7-haonguyen9191s-projects.vercel.app/api/staffs/$sid';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Staff deleted successfully: $sid');
        }

        staffs.removeWhere((staff) => staff.sid == sid);

        showCustomToast(context, 'Xóa nhân viên thành công');
        notifyListeners();
      } else {
        if (kDebugMode) {
          print('Failed to delete staff: ${response.statusCode}');
          print('Response: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error deleting staff: $error');
      }
    }
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context, String sid, Function onConfirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xoá'),
          content: const Text('Bạn có chắc chắn muốn xoá nhân viên này không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('Xoá', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }


  void clearFields() {
    nameController.clear();
    addressController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    roleController.clear();

    isAddingStaff = false;
    rolePermissions = List.filled(12, 0);

    notifyListeners();
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

