import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../view_model/new_employee.dart';

class PermissionSetting extends StatefulWidget {
  const PermissionSetting({Key? key}) : super(key: key);

  @override
  State<PermissionSetting> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionSetting> {
  @override
  Widget build(BuildContext context) {
    final newEmployee = Provider.of<NewEmployee>(context);

    List<String> permissionTitles = [
      'Bán hàng',
      'Quản lý đơn hàng',
      'Quản lý sản phẩm',
      'Thêm sản phẩm',
      'Quản lý khách hàng',
      'Quản lý tồn kho',
      'Điều chỉnh kho',
      'Lịch sử điều chỉnh',
      'Quản lý khuyến mãi',
      'Tạo khuyến mãi',
      'Báo cáo',
      'Cấu hình'
    ];

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: List.generate(permissionTitles.length, (index) {
            return Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(permissionTitles[index],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Flexible(
                          child: RadioListTile<int>(
                            activeColor: Colors.blueAccent,
                            title: const Text('Đọc và Ghi'),
                            value: 0,
                            groupValue: newEmployee.rolePermissions[index],
                            onChanged: (int? value) {
                              newEmployee.updateRolePermission(index, value!);
                            },
                          ),
                        ),
                        Flexible(
                          child: RadioListTile<int>(
                            activeColor: Colors.blueAccent,
                            title: const Text('Chỉ Đọc'),
                            value: 1,
                            groupValue: newEmployee.rolePermissions[index],
                            onChanged: (int? value) {
                              newEmployee.updateRolePermission(index, value!);
                            },
                          ),
                        ),
                        Flexible(
                          child: RadioListTile<int>(
                            activeColor: Colors.blueAccent,
                            title: const Text('Không Có Quyền'),
                            value: 2,
                            groupValue: newEmployee.rolePermissions[index],
                            onChanged: (int? value) {
                              newEmployee.updateRolePermission(index, value!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
