import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../view_model/setting/account.dart';

class ChangePasswordDialog extends StatelessWidget {
  final String staffId;
  const ChangePasswordDialog({Key? key, required this.staffId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountModel = Provider.of<AccountModel>(context);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Thay đổi mật khẩu của bạn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Current password
              const Text(
                'Nhập mật khẩu hiện tại',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: accountModel.currentPassController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Mật khẩu hiện tại',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // New password
              const Text(
                'Nhập mật khẩu mới',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: accountModel.newPassController1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Mật khẩu mới',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: accountModel.newPassController2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Xác nhận mật khẩu mới',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      side: const BorderSide(
                        color: Colors.red,
                          width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Hủy'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: accountModel.isLoading
                        ? null
                        : () {
                      accountModel.changePass(context, staffId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Cập nhật'),
                  ),
                ],
              ),

              if (accountModel.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3), // Màu overlay
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
