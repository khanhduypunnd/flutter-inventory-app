import 'package:flutter/material.dart';

class ImageUpload extends StatefulWidget {
  final TextEditingController urlController;

  ImageUpload({
    super.key,
    required this.urlController,
  });

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
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
          TextField(
            controller: widget.urlController,
            decoration: const InputDecoration(
              hintText: 'Nhập URL ảnh',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
