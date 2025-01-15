import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  // final String percentage;

  const InfoCard({
    Key? key,
    required this.title,
    required this.value,
    // required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Row(
            //   children: [
            //     if (percentage != '--') ...[
            //       double.parse(percentage) < 0.0
            //           ? Icon(Icons.arrow_drop_down, color: Colors.red)
            //           : Icon(Icons.arrow_drop_up, color: Colors.green),
            //       SizedBox(width: 5),
            //       Text(
            //         '${double.parse(percentage).toStringAsFixed(2)}%',
            //         style: TextStyle(
            //           color: double.parse(percentage) < 0.0 ? Colors.red : Colors.green,
            //           fontSize: 14,
            //         ),
            //       ),
            //     ] else
            //       Text(
            //         '--',
            //         style: TextStyle(color: Colors.grey, fontSize: 14),
            //       ),
            //   ],
            // )


          ],
        ),
      ),
    );
  }
}
