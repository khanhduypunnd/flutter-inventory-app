import 'package:flutter/material.dart';

class ImageUpload extends StatefulWidget {
  final Function(String) onAddFromURL;

  const ImageUpload({
    super.key,
    required this.onAddFromURL,
  });

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final TextEditingController _urlController = TextEditingController();

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
            controller: _urlController,
            decoration: InputDecoration(
              hintText: 'Nhập URL ảnh',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_urlController.text.isNotEmpty) {
                widget.onAddFromURL(_urlController.text);
              }
            },
            child: const Text(
              'Thêm từ URL',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
