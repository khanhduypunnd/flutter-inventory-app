import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';

class GeneralInfo extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController supplierController;
  final String? initialSelectedAttribute; // Giá trị ban đầu
  final TextEditingController notesController;
  final TextEditingController desController;

  const GeneralInfo({
    super.key,
    required this.nameController,
    required this.supplierController,
    required this.initialSelectedAttribute,
    required this.notesController,
    required this.desController,
  });

  @override
  _GeneralInfoState createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  String? selectedAttribute; // Trạng thái cho thuộc tính được chọn

  // Di chuyển attributeOptions vào đây
  final List<String> attributeOptions = ['Nam', 'Nữ', 'Giftset', 'Unisex', 'Mini size'];

  @override
  void initState() {
    super.initState();
    selectedAttribute = widget.initialSelectedAttribute;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Thông tin chung',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.titleColor),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.nameController,
            decoration: InputDecoration(
              hintText: 'Nhập tên sản phẩm',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.supplierController,
                  decoration: InputDecoration(
                    hintText: 'Nhập nhà cung cấp',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedAttribute, // Sử dụng trạng thái local
                  items: attributeOptions
                      .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAttribute = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

