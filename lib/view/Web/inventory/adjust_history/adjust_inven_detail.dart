import 'package:flutter/material.dart';
import 'adjust_list_detail.dart';
import 'adjust_invent_bonus_detail.dart';
import '../../../../data/product_adjust.dart';
import '../../../../shared/core/theme/colors_app.dart';

void main() {
  runApp(AdjustInvenDetail());
}

class AdjustInvenDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InventoryScreen(),
    );
  }
}

class InventoryScreen extends StatefulWidget {
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState  extends State<InventoryScreen> {
  String warehouseChange = "Kho A";
  int increaseAmount = 0;
  int decreaseAmount = 0;

  void calculateAdjustments() {
    int increase = 0;
    int decrease = 0;

    for (var product in productDetails) {
      if (product.different > 0) {
        increase += product.different;
      } else if (product.different < 0) {
        decrease += product.different;
      }
    }
    setState(() {
      increaseAmount = increase;
      decreaseAmount = decrease;
    });
  }

  final List<ProductDetail> productDetails = [
    ProductDetail(
      productId: "P001",
      productName: "Prada Luna",
      size: "100",
      oldQuantity: 0,
      newQuantity: 2,
      different: 2
    ),
    ProductDetail(
      productId: "P002",
      productName: "Versace pourhomme",
      size: "100",
      oldQuantity: 5,
      newQuantity: 3,
      different: -2
    ),
    ProductDetail(
      productId: "P003",
      productName: "Ysl Y",
      size: "100",
      oldQuantity: 1,
      newQuantity: 2,
      different: 1
    ),
  ];

  @override
  void initState() {
    super.initState();
    calculateAdjustments();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mã phiếu kiểm kho: IA101028',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Trạng thái:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Đã cân bằng',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: AdjustListDetail(productDetails: productDetails),
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
              ),

            ],
          ),
        ),
      ),
    );
  }
}


