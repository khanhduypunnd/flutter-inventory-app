import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../shared/core/theme/colors_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: RoleList(),
      ),
    );
  }
}

class RoleList extends StatelessWidget {
  final List<Role> roles = [
    Role(roleName: 'Nhân viên bán hàng', roleCode: 'NV01', creationDate: '29/03/2024 06:15 CH', creator: 'museperfume'),
    Role(roleName: 'Nhân viên tư vấn', roleCode: 'TV01', creationDate: '05/03/2024 06:30 CH', creator: 'museperfume'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.backgroundColor,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
              child: buildDataTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 50,
        headingRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.grey[200]!;
          },
        ),
        columns: const [
          DataColumn(
            label: Text(
              'VAI TRÒ',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'MÃ VAI TRÒ',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              '',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        rows: roles.map(
              (role) => DataRow(cells: [
            DataCell(
              Text(
                role.roleName,
                style: const TextStyle(color: Colors.blueAccent),
              ),
            ),
            DataCell(Text(role.roleCode)),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outlined, color: Colors.red),
                    onPressed: () {
                      // Xử lý khi nhấn xóa
                      if (kDebugMode) {
                        print('Delete ${role.roleName}');
                      }
                    },
                  ),
                ],
              ),
            ),
          ]),
        ).toList(),
      ),
    );
  }
}

class Role {
  final String roleName;
  final String roleCode;
  final String creationDate;
  final String creator;

  Role({
    required this.roleName,
    required this.roleCode,
    required this.creationDate,
    required this.creator,
  });
}
