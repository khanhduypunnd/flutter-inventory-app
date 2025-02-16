import 'package:flutter/material.dart';
import '../../../../../shared/core/theme/colors_app.dart';

class GeneralInfo extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController supplierController;
  final String? selectedAttribute;
  final TextEditingController notesController;
  final TextEditingController origin;
  final TextEditingController desController;
  final TextEditingController usageController;
  final List<String> attributeOptions;
  final Function(String?) onAttributeChanged;

  const GeneralInfo({
    super.key,
    required this.nameController,
    required this.supplierController,
    required this.selectedAttribute,
    required this.notesController,
    required this.origin,
    required this.desController,
    required this.usageController,
    required this.attributeOptions,
    required this.onAttributeChanged,
  });

  @override
  _GeneralInfoState createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  late double maxWidth, maxHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    bool isWarning = maxWidth > 700;
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
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 10),
                child: const Text(
                  'Tên sản phẩm',
                  style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: widget.nameController,
                decoration: InputDecoration(
                  hintText: 'Nhập tên sản phẩm',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              isWarning
                  ? Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'Nhà cung cấp',
                            style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          controller: widget.supplierController,
                          decoration: InputDecoration(
                            hintText: 'Nhập nhà cung cấp',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'Loại sản phẩm',
                            style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          value: widget.selectedAttribute,
                          items: widget.attributeOptions
                              .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                              .toList(),
                          onChanged: widget.onAttributeChanged,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  : Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: 10),
                    child: const Text(
                      'Nhà cung cấp',
                      style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    controller: widget.supplierController,
                    decoration: InputDecoration(
                      hintText: 'Nhập nhà cung cấp',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: 10),
                    child: const Text(
                      'Loại sản phẩm',
                      style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: widget.selectedAttribute,
                    items: widget.attributeOptions
                        .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                        .toList(),
                    onChanged: widget.onAttributeChanged,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 10),
            child: const Text('Phiên bản',
                style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold)),
          ),
          TextFormField(
            controller: widget.usageController,
            decoration: InputDecoration(
              hintText: 'Eau de Toilette, Eau de Parfum,...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 10),
            child: const Text('Xuất xứ',
                style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold)),
          ),
          TextFormField(
            controller: widget.origin,
            decoration: InputDecoration(
              hintText: 'Nhập xuất xứ',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 10),
            child: const Text('Nhóm hương',
                style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold)),
          ),
          TextFormField(
            controller: widget.notesController,
            decoration: InputDecoration(
              hintText: 'Nhập nhóm hương sản phẩm',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 10),
            child: const Text('Mô tả sản phẩm',
                style: TextStyle(fontSize: 15, color: AppColors.subtitleColor, fontWeight: FontWeight.bold)),
          ),
          TextFormField(
            controller: widget.desController,
            decoration: InputDecoration(
              hintText: 'Mô tả sản phẩm',
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            maxLines: 4,
          ),

        ],
      ),
    );
  }
}
