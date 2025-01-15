import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../shared/core/theme/colors_app.dart';
import 'new_role/new_role.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoleList(),
    );
  }
}

class RoleList extends StatefulWidget {
  const RoleList({Key? key}) : super(key: key);

  @override
  State<RoleList> createState() => _RoleListState();
}

class _RoleListState extends State<RoleList> {
  final List<Role> roles = [
    Role(roleName: 'Nhân viên bán hàng', roleCode: 'NV01', creationDate: '29/03/2024 06:15 CH', creator: 'museperfume'),
    Role(roleName: 'Nhân viên tư vấn', roleCode: 'TV01', creationDate: '05/03/2024 06:30 CH', creator: 'museperfume'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewRole()),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle_outline, size: 24),
                        SizedBox(width: 5),
                        Text('Tạo vai trò'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    return DataTable(
      columnSpacing: 200,
      headingRowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        return Colors.grey[200]!; // Use the appropriate color here
      }),
      columns: const [
        DataColumn(label: Text('VAI TRÒ', style: TextStyle(color: AppColors.textColor, fontSize: 18, fontWeight: FontWeight.bold))),
        DataColumn(label: Text('MÃ VAI TRÒ', style: TextStyle(color: AppColors.textColor, fontSize: 18, fontWeight: FontWeight.bold),)),
        DataColumn(label: Text('', style: TextStyle(color: AppColors.textColor, fontSize: 18, fontWeight: FontWeight.bold),)),
      ],
      rows: roles.map(
            (role) => DataRow(cells: [
          DataCell(Text(role.roleName, style: const TextStyle(color: Colors.blueAccent),),),
          DataCell(Text(role.roleCode)),
              DataCell(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outlined, color: Colors.red),
                    onPressed: () {
                      // Implement your delete functionality
                      if (kDebugMode) {
                        print('Delete ${role.roleName}');
                      }
                    },
                  ),
                ],
              )),
        ]),
      ).toList(),
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
