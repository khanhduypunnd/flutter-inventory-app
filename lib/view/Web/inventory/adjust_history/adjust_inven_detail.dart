import 'package:flutter/material.dart';
import '../../../../shared/core/services/uriApi.dart';
import 'adjust_list_detail.dart';
import 'adjust_invent_bonus_detail.dart';
import '../../../../data/product_adjust.dart';
import '../../../../shared/core/theme/colors_app.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';

class AdjustInvenDetail extends StatelessWidget {
  final Map<String, dynamic> ganData;
  final List<Map<String, dynamic>> ganDetails;

  const AdjustInvenDetail({
    Key? key,
    required this.ganData,
    required this.ganDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InventoryScreen(
        ganData: ganData,
        ganDetails: ganDetails,
      ),
    );
  }
}

class InventoryScreen extends StatefulWidget {
  final Map<String, dynamic> ganData;
  final List<Map<String, dynamic>> ganDetails;

  const InventoryScreen({
    Key? key,
    required this.ganData,
    required this.ganDetails,
  }) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final ApiService uriAPIService = ApiService();

  late String warehouseChange;
  late int increaseAmount;
  late int decreaseAmount;
  Map<String, String> productNames = {};
  bool isLoading = false;
  late double maxWidth;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchProducts();
    });

    warehouseChange = widget.ganData['note'] ?? '';
    increaseAmount = 0;
    decreaseAmount = 0;

    // Tính toán số lượng tăng và giảm
    for (var product in widget.ganDetails) {
      final int oldQuantity = product['oldQuantity'] ?? 0;
      final int newQuantity = product['newQuantity'] ?? 0;

      if (newQuantity > oldQuantity) {
        increaseAmount += (newQuantity - oldQuantity);
      } else if (newQuantity < oldQuantity) {
        decreaseAmount += (oldQuantity - newQuantity);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(uriAPIService.apiUrlProduct);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        if (mounted) {
          setState(() {
            productNames = {
              for (var product in jsonData)
                product['id']: product['name'] // Map productId -> productName
            };
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error fetching products: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải sản phẩm: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isChange = maxWidth > 1000;

    final List<ProductDetail> productDetails = widget.ganDetails.map<ProductDetail>((detail) {
      final productName = productNames[detail['pid']] ?? 'Unknown Product';
      return ProductDetail(
        productId: detail['pid'],
        productName: productName,
        size: detail['size'].join(", "),
        oldQuantity: detail['oldQuantity'],
        newQuantity: detail['newQuantity'],
        different: detail['newQuantity'] - detail['oldQuantity'],
      );
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mã phiếu kiểm kho: ${widget.ganData['ganId']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Ghi chú: $warehouseChange',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 16),
              isChange
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: AdjustListDetail(
                      productDetails: productDetails,
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    flex: 1,
                    child: AdjustInventBonusDetail(
                      warehouseChange: warehouseChange,
                      increaseAmount: increaseAmount,
                      decreaseAmount: decreaseAmount,
                    ),
                  ),
                ],
              )
                  : Column(
                children: [
                  AdjustListDetail(productDetails: productDetails),
                  SizedBox(height: 20),
                  AdjustInventBonusDetail(
                    warehouseChange: warehouseChange,
                    increaseAmount: increaseAmount,
                    decreaseAmount: decreaseAmount,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
