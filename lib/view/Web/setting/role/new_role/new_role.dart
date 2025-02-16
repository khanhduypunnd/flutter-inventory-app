import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/core/theme/colors_app.dart';
import '../../../../../view_model/setting/new_employee.dart';
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
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PermissionSetting(),
                ],
              ),
            )
          ],
        ),
    );
  }
}



