import 'package:flutter/material.dart';
import '../../../icon_pictures.dart';
import '../../../../shared/core/theme/colors_app.dart';

class Payment extends StatefulWidget {
  @override
  State<Payment> createState() => _MyAppState();
}

class _MyAppState extends State<Payment> {
  List<String> selectedPayments = []; // Danh sách các phương thức thanh toán đã chọn
  List<String> allPayments = [
    'Tiền mặt',
    'Chuyển khoản qua ngân hàng',
    'Momo',
    'Visa/Master',
    'ZaloPay',
    'VNPAY'
  ];

  // Một Map để ánh xạ tên payment tới các logo hình ảnh tương ứng
  Map<String, String> paymentImages = {
    'Tiền mặt': logo_payment.cash,
    'Chuyển khoản qua ngân hàng': logo_payment.bank,
    'Momo': logo_payment.momo,
    'Visa/Master': logo_payment.visa_master,
    'ZaloPay': logo_payment.zalopay,
    'VNPAY': logo_payment.vnpay,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Phương thức thanh toán đang chọn:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: selectedPayments
                            .map((payment) => Chip(
                          label: Text(payment),
                          avatar: Image.asset(
                            paymentImages[payment] ?? logo_payment.help,
                            width: 50,
                            height: 50,
                          ),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              selectedPayments.remove(payment);
                            });
                          },
                          backgroundColor: AppColors.backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.3),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Chọn phương thức thanh toán', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allPayments.length,
                  itemBuilder: (context, index) {
                    String payment = allPayments[index];
                    bool isSelected = selectedPayments.contains(payment);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: Colors.white, // Màu nền của Card
                      elevation: 5, // Đổ bóng cho Card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Bo góc Card
                      ),
                      shadowColor: Colors.black.withOpacity(0.2), // Màu bóng đổ
                      child: ListTile(
                        leading: Image.asset(
                          paymentImages[payment] ?? 'assets/help.png', // Hiển thị logo tương ứng
                          width: 40,
                          height: 40,
                        ),
                        title: Text(payment),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? Colors.red : AppColors.backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                color: AppColors.subtitleColor,
                                width: isSelected ? 0 : 1,
                              )
                            ),
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(0.3),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          ),
                          onPressed: () {
                            setState(() {
                              if (isSelected) {
                                selectedPayments.remove(payment);
                              } else {
                                selectedPayments.add(payment);
                              }
                            });
                          },
                          child: Text(isSelected ? 'Xóa' : 'Thêm', style: TextStyle(color: isSelected ? Colors.white : Colors.blueAccent),),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
