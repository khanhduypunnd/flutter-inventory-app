import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/core/theme/colors_app.dart';
import '../../../../../view_model/new_employee.dart';
import 'set_role.dart';

class NewRole extends StatefulWidget {
  const NewRole({super.key});

  @override
  NewRoleState createState() => NewRoleState();
}

class NewRoleState extends State<NewRole> {
  @override
  Widget build(BuildContext context) {
    final newEmployee = Provider.of<NewEmployee>(context);
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Tạo vai trò mới',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(bottom: 7),
                              child: const Text(
                                'Tên vai trò',
                                style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 7),
                            TextFormField(
                              controller: newEmployee.roleController,
                              decoration: InputDecoration(
                                hintText: 'Nhập tên vai trò ',
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  PermissionSetting(),
                ],
              ),
            )
          ],
        ),
    );
  }
}



