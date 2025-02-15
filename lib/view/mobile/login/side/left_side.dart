import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/core/theme/colors_app.dart';
import '../../../../view/Web/dashboard_web.dart';
import '../../../../view_model/login.dart';

class LeftSide extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Xin chào, vui lòng nhập thông tin đăng nhập',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Consumer<LoginModel>(
                  builder: (context, loginModel, child) {
                    return ElevatedButton(
                      onPressed: loginModel.isLoading
                          ? null
                          : () async {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();

                        Map<String, dynamic>? staffData = (await loginModel.login(context, email, password)) as Map<String, dynamic>?;

                        if (staffData != null) {
                          context.go('/dashboard', extra: staffData);
                        }
                      },
                      child: loginModel.isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Đăng nhập"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
