import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../shared/core/services/uriApi.dart';
import '../../../view_model/promotion/new_promotion.dart';
import '../../icon_pictures.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../data/promotion.dart';

class NewPromotion extends StatefulWidget {
  final Map<String, dynamic>? staffData;

  const NewPromotion({super.key, this.staffData});

  @override
  State<NewPromotion> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<NewPromotion> {
  @override
  Widget build(BuildContext context) {
    final newPromotionModel = Provider.of<NewPromotionModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed:()=> newPromotionModel.submitPromotion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text('Lưu', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Mã khuyến mãi',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: newPromotionModel.promotionCodeController,
                      decoration: InputDecoration(
                        hintText: 'Nhập mã khuyến mãi',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Mô tả',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: newPromotionModel.descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Nhập mô tả',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Expanded(
                          flex: 2,
                          child: Text('Thời gian bắt đầu'),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextButton(
                            onPressed: () => newPromotionModel.selectDateTime(context, true),
                            child: Text(
                              "${newPromotionModel.startDate!.toLocal()}".split('.')[0],
                              style: const TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Expanded(
                          flex: 2,
                          child: Text('Thời gian kết thúc'),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextButton(
                            onPressed: () => newPromotionModel.selectDateTime(context, false),
                            child: Text(
                              "${newPromotionModel.endDate!.toLocal()}".split('.')[0],
                              style: const TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
              _build_promotion_bill_percern(newPromotionModel),
          ],
        ),
      ),
    );
  }

  Widget _build_promotion_bill_percern(NewPromotionModel newPromotionModel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Giảm giá đơn hàng',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            const SizedBox(
              height: 10,
            ),
            const Text('Mức giảm', style: TextStyle(fontSize: 16)),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: newPromotionModel.valueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                          final intValue = int.tryParse(newValue.text) ?? 0;
                          if (intValue >= 0 && intValue <= 100) {
                            return newValue;
                          }
                          return oldValue;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text('%'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                    value: newPromotionModel.haslimit_promotion,
                    activeColor: Colors.blueAccent,
                    onChanged: (bool? value) {
                      setState(() {
                        newPromotionModel.haslimit_promotion = value!;
                      });
                    }),
                const Text('Giới hạn số tiền giảm tối đa'),
              ],
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: newPromotionModel.haslimit_promotion,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: newPromotionModel.valuelimitController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0đ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueAccent,
                              width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        TextInputFormatter.withFunction(
                              (oldValue, newValue) {
                            final intValue = int.tryParse(newValue.text) ?? 0;
                            if (intValue >= 0) {
                              return newValue;
                            }
                            return oldValue;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
