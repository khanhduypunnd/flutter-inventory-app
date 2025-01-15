import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PermissionSetting(),
      ),
    );
  }
}

class PermissionSetting extends StatefulWidget {
  @override
  State<PermissionSetting> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionSetting> {
  List<Permission> permissions = [];

  @override
  void initState() {
    super.initState();
    permissions = [
      Permission(title: 'Quản lý đơn hàng', groupValue: 1, onChange: (value) => _handleRadioValueChange(0, value)),
      Permission(title: 'Quản lý sản phẩm', groupValue: 1, onChange: (value) => _handleRadioValueChange(1, value)),
      Permission(title: 'Thêm sản phẩm', groupValue: 1, onChange: (value) => _handleRadioValueChange(2, value)),
      Permission(title: 'Quản lý khách hàng', groupValue: 1, onChange: (value) => _handleRadioValueChange(3, value)),
      Permission(title: 'Quản lý tồn kho', groupValue: 1, onChange: (value) => _handleRadioValueChange(4, value)),
      Permission(title: 'Điều chỉnh kho', groupValue: 1, onChange: (value) => _handleRadioValueChange(5, value)),
      Permission(title: 'Lịch sử điều chỉnh', groupValue: 1, onChange: (value) => _handleRadioValueChange(6, value)),
      Permission(title: 'Quản lý khuyến mãi', groupValue: 1, onChange: (value) => _handleRadioValueChange(7, value)),
      Permission(title: 'Tạo khuyến mãi', groupValue: 1, onChange: (value) => _handleRadioValueChange(8, value)),
      Permission(title: 'Báo cáo', groupValue: 1, onChange: (value) => _handleRadioValueChange(9, value)),
      Permission(title: 'Cấu hình', groupValue: 1, onChange: (value) => _handleRadioValueChange(10, value)),
    ];
  }

  void _handleRadioValueChange(int index, int? value) {
    setState(() {
      permissions[index].groupValue = value ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          children: permissions.map((permission) => buildPermissionCard(permission)).toList(),
        ),
      ),
    );
  }

  Widget buildPermissionCard(Permission permission) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(permission.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Flexible(
                  child: RadioListTile<int>(
                    activeColor: Colors.blueAccent,
                    title: Text('Đọc và Ghi'),
                    value: 0,
                    groupValue: permission.groupValue,
                    onChanged: (int? value) {
                      permission.onChange(value);
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<int>(
                    activeColor: Colors.blueAccent,
                    title: Text('Chỉ Đọc'),
                    value: 1,
                    groupValue: permission.groupValue,
                    onChanged: (int? value) {
                      permission.onChange(value);
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<int>(
                    activeColor: Colors.blueAccent,
                    title: Text('Không Có Quyền'),
                    value: 2,
                    groupValue: permission.groupValue,
                    onChanged: (int? value) {
                      permission.onChange(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class Permission {
  String title;
  int groupValue;
  Function(int?) onChange;

  Permission({
    required this.title,
    required this.groupValue,
    required this.onChange,
  });
}
