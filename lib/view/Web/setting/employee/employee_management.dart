import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/employee.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../../../../view_model/new_employee.dart';
import 'new_employee/new_employee.dart';

class EmployeeManagement extends StatefulWidget {
  const EmployeeManagement({Key? key}) : super(key: key);

  @override
  _EmployeeManagementState createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NewEmployee>(context, listen: false).fetchStaffs();
    });
  }

  late double maxWidth;

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;

    final staffModel = Provider.of<NewEmployee>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Chủ cửa hàng',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tài khoản toàn quyền truy cập cửa hàng của bạn',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text('M'),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${staffModel.admin[0].name}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text('${staffModel.admin[0].email}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Danh sách nhân viên',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.people_alt_outlined),
                                const SizedBox(width: 8),
                                Text(
                                  'Đã tạo ${staffModel.staffs.length} tài khoản nhân viên',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AddMemberDialog(),
                                    );
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.add_circle_outline),
                                      SizedBox(width: 5,),
                                      Text('Thêm nhân viên'),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text(
                              'Danh sách nhân viên',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...staffModel.staffs.map((e) => ListTile(
                            title: Row(
                              children: [
                                Text(e.name),
                                const SizedBox(width: 10,),
                                Text(e.role, style: const TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(Icons.mail_outline),
                                const SizedBox(width: 3),
                                Text(e.email),
                              ],
                            ),
                            trailing: const Icon(Icons.delete_outline),
                            onTap: () {
                              staffModel.showDeleteConfirmationDialog(context, e.sid, ()=> staffModel.deleteStaff(context,e.sid));
                              },
                          )).toList(),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

