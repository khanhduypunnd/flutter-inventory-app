import 'package:flutter/material.dart';
import 'popup/create_new__address.dart';
import '../../../../shared/core/theme/colors_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Address(),
    );
  }
}

class Address extends StatelessWidget {
  const Address({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Địa chỉ và kho hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Địa chỉ và kho hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.titleColor)
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showAddAddressPopup(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      children: [
                        Icon(Icons.add_circle_outline, color: Colors.white,),
                        SizedBox(width: 10,),
                        Text('Thêm địa chỉ', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),

                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Địa điểm hoạt động', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.titleColor)
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Địa điểm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.subtitleColor),)),
                  DataColumn(label: Text('Địa chỉ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.subtitleColor),)),
                  DataColumn(label: Text('Quận/Huyện', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.subtitleColor),)),
                  DataColumn(label: Text('Tỉnh/Thành', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.subtitleColor),)),
                ],
                rows: [
                  const DataRow(cells: [
                    DataCell(Text('Địa điểm mặc định')),
                    DataCell(Text('45 Trần Hưng Đạo')),
                    DataCell(Text('Quận 1')),
                    DataCell(Text('Hồ Chí Minh')),
                  ]),
                  const DataRow(cells: [
                    DataCell(Text('Kho tổng')),
                    DataCell(Text('Chung cư Mizuki')),
                    DataCell(Text('Huyện Bình Chánh')),
                    DataCell(Text('Hồ Chí Minh')),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Mặc định',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
