import 'package:flutter/material.dart';

class ImageUpload extends StatelessWidget {
  final Function onAddImage;
  final Function onAddFromURL;

  const ImageUpload({
    super.key,
    required this.onAddImage,
    required this.onAddFromURL,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          const BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Icon(
            Icons.image,
            size: 50,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => onAddImage(),
            child: const Text('Thêm ảnh', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () => onAddFromURL(),
            child: const Text(
              'Thêm từ URL (Hình ảnh/Video)',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
