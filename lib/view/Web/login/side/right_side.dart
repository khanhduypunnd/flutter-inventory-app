import 'package:flutter/material.dart';
import '../../../icon_pictures.dart';
import '../../../../shared/core/theme/colors_app.dart';

class RightSide extends StatelessWidget {
  const RightSide({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.tabbarColor,
            ),
            child: Center(
              child: Image.asset(logo_app.logo_size500)
            ),
          ),
        ),
      ),
    );
  }
}
