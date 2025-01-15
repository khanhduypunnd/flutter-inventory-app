import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';

class CustomerContactInfo extends StatelessWidget {
  final String phoneNumber;
  final String email;
  final String birthDate;
  final String address;

  const CustomerContactInfo({
    Key? key,
    required this.phoneNumber,
    required this.email,
    required this.birthDate,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin liên hệ', style: TextStyle(color: AppColors.titleColor, fontWeight: FontWeight.bold, fontSize: 20),),
          SizedBox(height: 20,),
          Text('Số điện thoại: $phoneNumber'),
          const SizedBox(height: 8),
          Text('Email: $email'),
          const SizedBox(height: 8),
          Text('Ngày sinh: $birthDate'),
          const SizedBox(height: 8),
          Text('Địa chỉ: $address'),
        ],
      ),
    );
  }
}