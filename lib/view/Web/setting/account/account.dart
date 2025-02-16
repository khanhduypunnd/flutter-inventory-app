import 'package:dacntt1_mobile_admin/view_model/setting/account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/core/theme/colors_app.dart';
import 'change_pass/change_pass.dart';

class Account extends StatefulWidget {
  final Map<String, dynamic>? staffData;

  const Account({super.key, this.staffData});

  @override
  State<Account> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<Account> {
  late double maxWidth;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;

    final accountModel = Provider.of<AccountModel>(context, listen: false);
    if (widget.staffData != null) {
      accountModel.setStaffData(widget.staffData!);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isChange = maxWidth < 700;

    final accountModel = Provider.of<AccountModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: isChange
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tài khoản',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor),
                          ),
                          const SizedBox(height: 15),
                          const Text('Tên đăng nhập'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: accountModel.usernameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            enabled: false,
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blueAccent,
                              side: const BorderSide(
                                  color: Colors.blue, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text('Đổi mật khẩu'),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tài khoản',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Tên đăng nhập'),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller:
                                          accountModel.usernameController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      enabled: false,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ChangePasswordDialog(
                                    staffId:
                                        widget.staffData!['id'].toString()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blueAccent,
                              side: const BorderSide(
                                  color: Colors.blueAccent, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text('Đổi mật khẩu'),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: isChange
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thông tin cá nhân',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor),
                          ),
                          const SizedBox(height: 15),
                          const Text('Họ và tên'),
                          const SizedBox(height: 5),
                          TextFormField(
                            cursorColor: Colors.blueAccent,
                            controller: accountModel.nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blueAccent, width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text('Số điện thoại'),
                          const SizedBox(height: 5),
                          TextFormField(
                            cursorColor: Colors.blueAccent,
                            controller: accountModel.phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blueAccent, width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thông tin cá nhân',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Họ và tên'),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      cursorColor: Colors.blueAccent,
                                      controller: accountModel.nameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blueAccent,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Số điện thoại'),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    cursorColor: Colors.blueAccent,
                                    controller: accountModel.phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blueAccent, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chức vụ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor),
                    ),
                    const SizedBox(height: 15),
                    const Text('Chức vụ'),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: accountModel.positionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
