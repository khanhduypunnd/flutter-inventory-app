import 'package:flutter/material.dart';
import '../../../../data/employee.dart';
import '../../../../shared/core/theme/colors_app.dart';
import 'new_employee/new_employee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EmployeeManagement(),
    );
  }
}

class EmployeeManagement extends StatefulWidget {
  const EmployeeManagement({Key? key}) : super(key: key);

  @override
  _EmployeeManagementState createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {
  final List<Employee> employees = [
    Employee(
      id: '1',
      name: 'John Doe',
      address: '123 Elm St',
      email: 'john.doe@example.com',
      phone: '123-456-7890',
      pass: 'password123',
      role: 'Manager',
    ),
    Employee(
      id: '2',
      name: 'Jane Smith',
      address: '456 Oak St',
      email: 'jane.smith@example.com',
      phone: '234-567-8901',
      pass: 'password124',
      role: 'Staff',
    ),
    Employee(
      id: '3',
      name: 'Bob Johnson',
      address: '789 Pine St',
      email: 'bob.johnson@example.com',
      phone: '345-678-9012',
      pass: 'password125',
      role: 'Admin',
    ),
    Employee(
      id: '4',
      name: 'Alice Brown',
      address: '101 Maple St',
      email: 'alice.brown@example.com',
      phone: '456-789-0123',
      pass: 'password126',
      role: 'Staff',
    ),
    Employee(
      id: '5',
      name: 'Charlie Davis',
      address: '123 Spruce St',
      email: 'charlie.davis@example.com',
      phone: '567-890-1234',
      pass: 'password127',
      role: 'Supervisor',
    ),
    Employee(
      id: '6',
      name: 'Diane Evans',
      address: '456 Birch St',
      email: 'diane.evans@example.com',
      phone: '678-901-2345',
      pass: 'password128',
      role: 'Staff',
    ),
    Employee(
      id: '7',
      name: 'Frank Green',
      address: '789 Cedar St',
      email: 'frank.green@example.com',
      phone: '789-012-3456',
      pass: 'password129',
      role: 'Manager',
    ),
    Employee(
      id: '8',
      name: 'Grace Hill',
      address: '101 Elm St',
      email: 'grace.hill@example.com',
      phone: '890-123-4567',
      pass: 'password130',
      role: 'Staff',
    ),
    Employee(
      id: '9',
      name: 'Henry Adams',
      address: '123 Oak St',
      email: 'henry.adams@example.com',
      phone: '901-234-5678',
      pass: 'password131',
      role: 'Admin',
    ),
    Employee(
      id: '10',
      name: 'Irene Baker',
      address: '456 Pine St',
      email: 'irene.baker@example.com',
      phone: '012-345-6789',
      pass: 'password132',
      role: 'Staff',
    ),
  ];

  late double maxWidth;

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text('M'),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text('baotram.nguyencgoc0906@gmail.com'),
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
                                  'Đã tạo ${employees.length} tài khoản nhân viên',
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
                          ...employees.map((e) => ListTile(
                            title: Text(e.name),
                            subtitle: Row(
                              children: [
                                const Icon(Icons.mail_outline),
                                const SizedBox(width: 3),
                                Text(e.email),
                              ],
                            ),
                            trailing: const Icon(Icons.delete_outline),
                            onTap: () {
                              // Handle your onTap here
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


// class Employee {
//   final String name;
//   final String email;
//
//   Employee({required this.name, required this.email});
// }
