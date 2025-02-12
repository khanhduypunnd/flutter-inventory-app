import 'package:flutter/material.dart';
import '../../../shared/core/services/uriApi.dart';

class ListFilter extends StatefulWidget {
  @override
  _ListFilterState createState() => _ListFilterState();
}

class _ListFilterState extends State<ListFilter> {
  final ApiService uriAPIService = ApiService();

  String? selectedKho;
  String? selectedLoaiSanPham;
  String? selectedNhaCungCap;

  List<String> khoList = ['Kho 1', 'Kho 2', 'Kho 3', 'Kho 4'];
  List<String> loaiSanPhamList = ['Nước hoa Nam', 'Nước hoa Nữ', 'Unisex', 'Giftset'];
  List<String> nhaCungCapList = ['Nhà cung cấp 1', 'Nhà cung cấp 2', 'Nhà cung cấp 3'];


  void _onFilterChange() {
    print('Kho: $selectedKho, Loại sản phẩm: $selectedLoaiSanPham, Nhà cung cấp: $selectedNhaCungCap');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết tồn kho'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            Text(
              'Hiển thị tất cả chi tiết tồn kho theo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Dropdown lọc Kho
            Row(
              children: [
                Text('Kho: ', style: TextStyle(fontSize: 16)),
                DropdownButton<String>(
                  value: selectedKho,
                  hint: Text('Chọn kho'),
                  items: khoList.map((String kho) {
                    return DropdownMenuItem<String>(
                      value: kho,
                      child: Text(kho),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedKho = newValue;
                      _onFilterChange(); // Thực hiện khi thay đổi lựa chọn
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),

            // Dropdown lọc Loại sản phẩm
            Row(
              children: [
                Text('Loại sản phẩm: ', style: TextStyle(fontSize: 16)),
                DropdownButton<String>(
                  value: selectedLoaiSanPham,
                  hint: Text('Chọn loại sản phẩm'),
                  items: loaiSanPhamList.map((String loai) {
                    return DropdownMenuItem<String>(
                      value: loai,
                      child: Text(loai),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLoaiSanPham = newValue;
                      _onFilterChange(); // Thực hiện khi thay đổi lựa chọn
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),

            // Dropdown lọc Nhà cung cấp
            Row(
              children: [
                Text('Nhà cung cấp: ', style: TextStyle(fontSize: 16)),
                DropdownButton<String>(
                  value: selectedNhaCungCap,
                  hint: Text('Chọn nhà cung cấp'),
                  items: nhaCungCapList.map((String nhaCungCap) {
                    return DropdownMenuItem<String>(
                      value: nhaCungCap,
                      child: Text(nhaCungCap),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedNhaCungCap = newValue;
                      _onFilterChange(); // Thực hiện khi thay đổi lựa chọn
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Nút thêm điều kiện lọc
            ElevatedButton(
              onPressed: _onFilterChange,
              child: Text('Thêm điều kiện lọc'),
            ),
          ],
        ),
      ),
    );
  }
}
