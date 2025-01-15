import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';
import 'set_role.dart';
import '/data/role.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: const NewRole(),
      ),
    );
  }
}

class NewRole extends StatelessWidget {
  const NewRole({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25), // Điều chỉnh padding cho button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Bo góc của button
                  ),
                  side: const BorderSide(color: Colors.blue, width: 1), // Đặt viền màu xanh lam
                ),
                onPressed: () {
                },
                child: const Text('Xong',),
              ),
            ),
            SizedBox(height: 15,),

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
                              child: const Text('Tên vai trò', style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(height: 7,),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Nhập tên vai trò ',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blueAccent,
                                      width: 2), // Màu viền khi focus
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
      
                      SizedBox(width: 30,),
      
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(bottom: 7),
                              child: const Text('Mã vai trò', style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(height: 7,),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Nhập mã vai trò',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blueAccent,
                                      width: 2), // Màu viền khi focus
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
                children: [
                  PermissionSetting(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


