import 'package:flutter/material.dart';
import '../../../../shared/core/theme/colors_app.dart';

class AdjustInventBonusDetail extends StatelessWidget {
  final String warehouseChange;
  final int increaseAmount;
  final int decreaseAmount;

  const AdjustInventBonusDetail({
    Key? key,
    required this.warehouseChange,
    required this.increaseAmount,
    required this.decreaseAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Số lượng lệch tăng", style: TextStyle(color: AppColors.titleColor),),
              Text("$increaseAmount"),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Số lượng lệch giảm", style: TextStyle(color: AppColors.titleColor)),
              Text("$decreaseAmount"),
            ],
          ),
        ],
      ),
    );
  }
}
