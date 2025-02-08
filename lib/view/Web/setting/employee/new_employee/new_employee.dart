import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/core/theme/colors_app.dart';
import '../../../../../view_model/new_employee.dart';
import '../../role/new_role/new_role.dart';

class AddMemberDialog extends StatefulWidget {
  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {

  @override
  Widget build(BuildContext context) {
    final newEmployee = Provider.of<NewEmployee>(context);
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thêm thành viên mới',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: newEmployee.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Họ tên',
                    hintText: 'Nhập họ tên',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                    focusColor: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newEmployee.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Nhập địa chỉ email',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: newEmployee.addressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ',
                    hintText: 'Nhập địa chỉ',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newEmployee.phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    hintText: 'Nhập số điện thoại',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: newEmployee.passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    hintText: 'Nhập mật khẩu',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                if (!newEmployee.isAddingStaff)
                  TextFormField(
                    controller: newEmployee.roleController,
                    decoration: const InputDecoration(
                      labelText: 'Chức vụ',
                      hintText: 'Nhập chức vụ',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2.0),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thêm thành viên mới',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.blueAccent,
                      value: newEmployee.isAddingStaff,
                      onChanged: (value) {
                        setState(() {
                          newEmployee.isAddingStaff = value!;
                        });
                      },
                    ),
                    const Text(
                      'Thêm nhân viên mới',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (newEmployee.isAddingStaff) NewRole(),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text('Hủy'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: newEmployee.isLoading
                          ? null
                          : () {
                        newEmployee.sendStaff(context);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text('Lưu'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
