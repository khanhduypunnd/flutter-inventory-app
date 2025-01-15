import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'new_promotion.dart';

class add_promotion extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  add_promotion({super.key, required this.navigatorKey});

  String _selectedPage = 'Khuyến mãi > Khuyến mãi mới > Tạo mã';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PromotionButton(
              icon: Icons.confirmation_number,
              title: 'Tạo Mã khuyến mãi',
              subtitle: 'Khách hàng sẽ nhận giảm giá khi nhập mã khuyến mãi cho đơn hàng',
              onTap: () {

                navigatorKey.currentState?.push(
                    PageRouteBuilder(
                        pageBuilder: (context, animation, secondanimation) => _buildPage('Khuyến mãi > Khuyến mãi mới > Tạo mã'),
                    transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                    ));
                // MaterialPageRoute(builder: (context) => _buildPage('Khuyến mãi > Khuyến mãi mới > Tạo mã'));
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPage(String page) {
    switch (page) {
      case 'Khuyến mãi > Khuyến mãi mới > Tạo mã':
        return NewPromotion();
      default:
        return Center(child: Text("Màn hình không tồn tại"));
    }
  }


}

class PromotionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const PromotionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.lightBlueAccent,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
