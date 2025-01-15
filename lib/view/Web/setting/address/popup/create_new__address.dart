import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';

void showAddAddressPopup(BuildContext context) {
  // Dữ liệu tỉnh thành và quận huyện
  final List<String> provinces = [
    'Hà Nội',
    'Hồ Chí Minh',
    'Đà Nẵng',
    'Cần Thơ',
    'An Giang',
    'Bà Rịa - Vũng Tàu',
    'Bắc Giang',
    'Bắc Kạn',
    'Bến Tre',
    'Bình Dương',
    'Bình Định',
    'Bình Phước',
    'Bình Thuận',
    'Cao Bằng',
    'Cà Mau',
    'Đắk Lắk',
    'Đắk Nông',
    'Điện Biên',
    'Đồng Nai',
    'Đồng Tháp',
    'Gia Lai',
    'Hà Giang',
    'Hải Dương',
    'Hải Phòng',
    'Hậu Giang',
    'Hòa Bình',
    'Hưng Yên',
    'Khánh Hòa',
    'Kiên Giang',
    'Kon Tum',
    'Lai Châu',
    'Lâm Đồng',
    'Lạng Sơn',
    'Long An',
    'Nam Định',
    'Nghệ An',
    'Ninh Bình',
    'Ninh Thuận',
    'Phú Thọ',
    'Phú Yên',
    'Quảng Bình',
    'Quảng Nam',
    'Quảng Ngãi',
    'Quảng Ninh',
    'Quảng Trị',
    'Sóc Trăng',
    'Sơn La',
    'Tây Ninh',
    'Thái Bình',
    'Thái Nguyên',
    'Thanh Hóa',
    'Thừa Thiên Huế',
    'Tiền Giang',
    'Trà Vinh',
    'Tuyên Quang',
    'Vĩnh Long',
    'Vĩnh Phúc',
    'Yên Bái',
    'Hưng Yên',
    'Bắc Ninh',
    'Bình Thuận',
    'Bắc Giang',
    'Phú Yên'
  ];

  final Map<String, List<String>> districts = {
    'Hà Nội': [
      'Ba Đình', 'Hoàn Kiếm', 'Tây Hồ', 'Long Biên', 'Cầu Giấy', 'Đống Đa', 'Hai Bà Trưng', 'Hoàng Mai', 'Thanh Xuân', 'Nam Từ Liêm', 'Bắc Từ Liêm', 'Sóc Sơn', 'Đông Anh', 'Gia Lâm', 'Mê Linh', 'Sơn Tây', 'Phúc Thọ', 'Thạch Thất', 'Quốc Oai', 'Chương Mỹ', 'Thanh Oai', 'Thường Tín', 'Phú Xuyên', 'Ứng Hòa', 'Mỹ Đức',
    ],
    'Hồ Chí Minh': [
      'Quận 1', 'Quận 2', 'Quận 3', 'Quận 4', 'Quận 5', 'Quận 6', 'Quận 7', 'Quận 8', 'Quận 9', 'Quận 10', 'Quận 11', 'Quận 12', 'Thủ Đức', 'Bình Tân', 'Bình Thạnh', 'Gò Vấp', 'Phú Nhuận', 'Tân Bình', 'Tân Phú', 'Cần Giờ', 'Củ Chi', 'Hóc Môn', 'Bình Chánh', 'Nhà Bè',
    ],
    'Đà Nẵng': [
      'Hải Châu', 'Liên Chiểu', 'Thanh Khê', 'Cẩm Lệ', 'Sơn Trà', 'Ngũ Hành Sơn', 'Hoà Vang',
    ],
    'Cần Thơ': [
      'Ninh Kiều', 'Cái Răng', 'Phong Điền', 'Thốt Nốt', 'Vĩnh Thạnh', 'Cờ Đỏ', 'Kiên Giang', 'Ba Láng', 'Ô Môn', 'Hóc Môn',
    ],
    'An Giang': [
      'Long Xuyên', 'Châu Đốc', 'Tân Châu', 'Châu Phú', 'Chợ Mới', 'Phú Tân', 'Tịnh Biên', 'Tri Tôn', 'Thới Lai', 'An Phú',
    ],
    'Bà Rịa - Vũng Tàu': [
      'Vũng Tàu', 'Bà Rịa', 'Long Điền', 'Đất Đỏ', 'Châu Đức', 'Xuyên Mộc', 'Tân Thành',
    ],
    'Bắc Giang': [
      'Bắc Giang', 'Lục Ngạn', 'Lục Nam', 'Sơn Động', 'Yên Thế', 'Tân Yên', 'Việt Yên', 'Hiệp Hòa', 'Lạng Giang', 'Bắc Sơn',
    ],
    'Bắc Kạn': [
      'Bắc Kạn', 'Chợ Đồn', 'Chợ Mới', 'Na Rì', 'Pác Nặm', 'Ba Bể', 'Ngân Sơn', 'Bạch Thông', 'Nà Phặc',
    ],
    'Bến Tre': [
      'Bến Tre', 'Châu Thành', 'Giồng Trôm', 'Mỏ Cày Nam', 'Mỏ Cày Bắc', 'Ba Tri', 'Thạnh Phú', 'Chợ Lách', 'Dai Loc',
    ],
    'Bình Dương': [
      'Thủ Dầu Một', 'Dĩ An', 'Thuận An', 'Bến Cát', 'Tân Uyên', 'Bàu Bàng', 'Phú Giáo', 'Dầu Tiếng',
    ],
    'Bình Định': [
      'Quy Nhơn', 'An Nhơn', 'Tuy Phước', 'Hoài Nhơn', 'Phù Cát', 'Phù Mỹ', 'Vân Canh', 'Tăng Bạt Hổ', 'Hoài Ân', 'Kim Sơn',
    ],
    'Bình Phước': [
      'Đồng Xoài', 'Bù Đăng', 'Bù Gia Mập', 'Chơn Thành', 'Phú Riềng', 'Lộc Ninh', 'Bù Đốp',
    ],
    'Bình Thuận': [
      'Phan Thiết', 'La Gi', 'Tánh Linh', 'Đức Linh', 'Hàm Tân', 'Hàm Thuận Bắc', 'Hàm Thuận Nam', 'Phú Quý', 'Tân Thuận',
    ],
    'Cao Bằng': [
      'Cao Bằng', 'Nguyên Bình', 'Thạch An', 'Bảo Lạc', 'Bảo Lâm', 'Hòa An', 'Trùng Khánh', 'Quảng Uyên', 'Phục Hòa', 'Hạ Lang',
    ],
    'Cà Mau': [
      'Cà Mau', 'Năm Căn', 'Phú Tân', 'U Minh', 'Thới Bình', 'Trần Văn Thời', 'Cái Nước', 'Đầm Dơi', 'Ngọc Hiển',
    ],
    'Đắk Lắk': [
      'Buôn Ma Thuột', 'Bù Gia Mập', 'Cư M’gar', 'Ea H’leo', 'Krông Ana', 'Krông Bông', 'Krông Buk', 'Krông Năng', 'M’Drắk', 'Lắk', 'Ea Kar',
    ],
    'Đắk Nông': [
      'Gia Nghĩa', 'Cư Jút', 'Đắk Mil', 'Đắk R’lấp', 'Đắk Song', 'Krông Nô', 'Tân Biên', 'Vô Dưới',
    ],
    'Điện Biên': [
      'Điện Biên Phủ', 'Mường Lay', 'Tỏa Tịnh', 'Tuần Giáo', 'Mường Nhé', 'Mường Chà', 'Nậm Pồ', 'Điện Biên Đông',
    ],
    'Đồng Nai': [
      'Biên Hòa', 'Long Khánh', 'Vĩnh Cửu', 'Tân Phú', 'Định Quán', 'Cẩm Mỹ', 'Trảng Bom', 'Nhơn Trạch', 'Thống Nhất', 'Long Thành', 'Xuân Lộc',
    ],
    'Đồng Tháp': [
      'Cao Lãnh', 'Sa Đéc', 'Hồng Ngự', 'Tam Nông', 'Tân Hồng', 'Lấp Vò', 'Thanh Bình', 'Châu Thành',
    ],
    'Gia Lai': [
      'Pleiku', 'An Khê', 'Chư Păh', 'Chư Sê', 'Kbang', 'Krông Pa', 'Ia Grai', 'Ia Pa', 'Đăk Đoa', 'Mang Yang',
    ],
    'Hà Giang': [
      'Hà Giang', 'Quản Bạ', 'Yên Minh', 'Vị Xuyên', 'Bắc Mê', 'Hàm Yên', 'Mèo Vạc', 'Hoàng Su Phì', 'Đồng Văn',
    ],
    'Hải Dương': [
      'Hải Dương', 'Chí Linh', 'Kinh Môn', 'Nam Sách', 'Thanh Miện', 'Tứ Kỳ', 'Gia Lộc', 'Kim Thành', 'Bình Giang', 'Ninh Giang', 'Thanh Hà', 'Cẩm Giàng', 'Sao Đỏ',
    ],
    'Hải Phòng': [
      'Hải Phòng', 'An Dương', 'An Lão', 'Bạch Long Vĩ', 'Cát Hải', 'Đồ Sơn', 'Dương Kinh', 'Hồng Bàng', 'Kiến An', 'Lê Chân', 'Ngô Quyền', 'Tràng Cát', 'Tiên Lãng', 'Vĩnh Bảo', 'Bình Định',
    ],
    'Hậu Giang': [
      'Vị Thanh', 'Ngã Bảy', 'Long Mỹ', 'Châu Thành', 'Vị Thủy', 'Phụng Hiệp', 'Châu Thành A', 'Kế Sách',
    ],
    'Hòa Bình': [
      'Hòa Bình', 'Kim Bôi', 'Lương Sơn', 'Tân Lạc', 'Lạc Sơn', 'Lạc Thủy', 'Yên Thủy', 'Mai Châu',
    ],
    'Hưng Yên': [
      'Hưng Yên', 'Văn Lâm', 'Văn Giang', 'Tiên Lữ', 'Khoái Châu', 'Kim Động', 'Phù Cừ', 'Mỹ Hào', 'Ân Thi', 'Yên Mỹ',
    ],
    'Khánh Hòa': [
      'Nha Trang', 'Cam Ranh', 'Diên Khánh', 'Khánh Vĩnh', 'Vạn Ninh', 'Ninh Hòa', 'Cam Lâm', 'Trường Sa',
    ],
    'Kiên Giang': [
      'Rạch Giá', 'Hà Tiên', 'An Biên', 'An Minh', 'Châu Thành', 'Giồng Riềng', 'Gò Quao', 'Tân Hiệp', 'Vĩnh Thuận', 'U Minh Thượng', 'Kiên Hải',
    ],
    'Kon Tum': [
      'Kon Tum', 'Đăk Hà', 'Đăk Glei', 'Sa Thầy', 'Ngọc Hồi', 'Tu Mơ Rông', 'Ia H’Drai',
    ],
    'Lai Châu': [
      'Lai Châu', 'Tam Đường', 'Mường Tè', 'Sìn Hồ', 'Phong Thổ', 'Tân Uyên', 'Nậm Nhùn',
    ],
    'Lâm Đồng': [
      'Đà Lạt', 'Bảo Lộc', 'Đơn Dương', 'Di Linh', 'Lâm Hà', 'Đạ Huoai', 'Đạ Tẻh', 'Cát Tiên', 'Bảo Lâm',
    ],
    'Lạng Sơn': [
      'Lạng Sơn', 'Cao Lộc', 'Văn Lãng', 'Đình Lập', 'Bắc Sơn', 'Hữu Lũng', 'Chi Lăng', 'An Lão', 'Bắc Giang',
    ],
    'Long An': [
      'Tân An', 'Bến Lức', 'Châu Thành', 'Cần Giuộc', 'Cần Đước', 'Thủ Thừa', 'Tân Trụ', 'Đức Hòa', 'Đức Huệ',
    ],
    'Nam Định': [
      'Nam Định', 'Mỹ Lộc', 'Vụ Bản', 'Ý Yên', 'Gia Viễn', 'Kim Sơn', 'Trực Ninh', 'Hải Hậu', 'Nghĩa Hưng',
    ],
    'Nghệ An': [
      'Vinh', 'Cửa Lò', 'Nghi Lộc', 'Hưng Nguyên', 'Thanh Chương', 'Đô Lương', 'Quỳnh Lưu', 'Quỳ Hợp', 'Con Cuông', 'Tương Dương', 'Kỳ Sơn',
    ],
    'Ninh Bình': [
      'Ninh Bình', 'Tam Điệp', 'Gia Viễn', 'Hoa Lư', 'Yên Mô', 'Kim Sơn', 'Nho Quan', 'Đức Hòa',
    ],
    'Ninh Thuận': [
      'Phan Rang-Tháp Chàm', 'Bác Ái', 'Ninh Sơn', 'Ninh Hải', 'Thuận Bắc', 'Thuận Nam',
    ],
    'Phú Thọ': [
      'Việt Trì', 'Phú Thọ', 'Thanh Sơn', 'Thanh Thủy', 'Cẩm Khê', 'Lâm Thao', 'Đoan Hùng', 'Tam Nông', 'Tân Sơn', 'Hạ Hòa',
    ],
  };


  String? selectedProvince = 'Hồ Chí Minh';
  String? selectedDistrict = 'Quận 1';
  String address = '';
  String detailedAddress = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Thêm địa chỉ'),
        content: SingleChildScrollView(
          child: Container(
            height: 400,
            width: 600,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tên địa điểm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.titleColor),),
                const SizedBox(height: 10,),
                TextFormField(
                  onChanged: (value) {
                    address = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10), // Giữ padding giống
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Chọn tỉnh thành', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.titleColor)),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0), // Padding cho Dropdown
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey, width: 2), // Đặt viền cho dropdown
                            ),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              underline: Container(),
                              value: selectedProvince,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                selectedProvince = newValue;
                                selectedDistrict = districts[selectedProvince]?.first;
                                (context as Element).markNeedsBuild();
                              },
                              items: provinces.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Chọn quận/huyện', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.titleColor)),
                          const SizedBox(height: 5,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0), // Padding cho Dropdown
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey, width: 2), // Đặt viền cho dropdown
                            ),
                            child: DropdownButton<String>(
                              underline: Container(),
                              dropdownColor: Colors.white,
                              value: selectedDistrict,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                selectedDistrict = newValue;
                                (context as Element).markNeedsBuild();
                              },
                              items: districts[selectedProvince]!
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),


                const Text(' Địa chỉ chi tiết ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.titleColor),),
                const SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    detailedAddress = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10), // Giữ padding giống
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Nút hủy
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Hủy'),
          ),
          // Nút lưu
          TextButton(
            onPressed: () {
              // Lưu hoặc xử lý thông tin tại đây
              print('Địa điểm: $address');
              print('Tỉnh/Thành phố: $selectedProvince');
              print('Quận/Huyện: $selectedDistrict');
              print('Địa chỉ chi tiết: $detailedAddress');
              Navigator.of(context).pop();
            },
            child: const Text('Lưu'),
          ),
        ],
      );
    },
  );
}
