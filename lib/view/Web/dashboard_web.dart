import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../view_model/login/login.dart';
import 'drawer/drawer.dart';
import '../../shared/core/theme/colors_app.dart';

class InventoryWeb extends StatefulWidget {
  final Widget child;
  final Map<String, dynamic>? staffData;

  final GlobalKey<NavigatorState> navigatorKey;
  const InventoryWeb(
      {super.key,
      required this.navigatorKey,
      required this.child,
      this.staffData});

  @override
  _InventoryWebState createState() => _InventoryWebState();
}

class _InventoryWebState extends State<InventoryWeb> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedPage = '';
  late double maxWidth;
  bool _isDrawerOpen = true;

  final Map<String, bool> _expandedTiles = {};
  Map<String, dynamic>? staffData;
  List<int>? roleDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedPage = 'Tổng quan';
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;

    final extra = GoRouterState.of(context).extra;
    if (extra != null && extra is Map<String, dynamic>) {
      staffData = extra;
      roleDetail = List<int>.from(extra['role_detail'] ?? []);
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = maxWidth > 800;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Hype Inventory",
          style: TextStyle(
              fontSize: 18,
              color: AppColors.titleColor,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.backgroundColor,
        leading: isScreenWide
            ? null
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  final scaffoldState = _scaffoldKey.currentState;
                  if (scaffoldState != null) {
                    if (scaffoldState.isDrawerOpen) {
                      scaffoldState.closeDrawer();
                    } else {
                      scaffoldState.openDrawer();
                    }
                  }
                  setState(() {});
                },
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              final loginModel =
                  Provider.of<LoginModel>(context, listen: false);
              loginModel.logout(context);
            },
          ),
        ],
      ),
      drawer: isScreenWide
          ? null
          : CustomDrawer(
              selectedPage: _selectedPage,
              onPageSelected: (route) {
                setState(() {
                  _selectedPage = route;
                });
                context.go(route, extra: staffData);
              },
              context: context,
              roleDetail: roleDetail,
            ),
      body: Row(
        children: [
          if (isScreenWide)
            Container(
              width: 200,
              color: AppColors.backgroundColor,
              child: _buildDrawer(isScreenWide),
            ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }

  final Map<String, String> _pageTitles = {
    '/dashboard': "Tổng quan",
    '/sale': "Bán hàng",
    '/orderhistory': "Tất cả đơn hàng",
    '/onlineorders': "Đơn hàng website",
    '/salesreport': "Báo cáo bán hàng",
    '/products': "Danh sách sản phẩm",
    '/new_products': "Thêm sản phẩm mới",
    '/customers': "Khách hàng",
    '/adjust_overview': "Chi tiết tồn kho",
    '/new_adjust': "Phiếu điều chỉnh",
    '/adjusts': "Lịch sử điều chỉnh",
    '/promotions': "Tất cả khuyến mãi",
    '/new_promotion': "Khuyến mãi mới",
    '/reports': "Bảng phân tích",
    '/setting': "Cấu hình",
  };

  Widget _buildDrawer(bool isScreenWide) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: _selectedPage == 'Tổng quan'
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: _selectedPage == 'Tổng quan'
                      ? [
                          const BoxShadow(
                            color: Colors.black45,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.dashboard_outlined,
                    color: _selectedPage == 'Tổng quan'
                        ? Colors.blueAccent
                        : Colors.black,
                  ),
                  title: Text(
                    'Tổng quan',
                    style: TextStyle(
                      color: _selectedPage == 'Tổng quan'
                          ? Colors.black
                          : Colors.black,
                      fontWeight: _selectedPage == 'Tổng quan'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedPage = 'Tổng quan';
                    });
                    if (!isScreenWide) {
                      Navigator.pop(context);
                    }
                    context.go('/dashboard', extra: staffData);
                  },
                ),
              ),
              //Don hang
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Icon(
                    Icons.shopping_cart_outlined,
                    color: _selectedPage.contains('Đơn hàng')
                        ? Colors.blueAccent
                        : Colors.black,
                  ),
                  title: Text(
                    'Đơn hàng',
                    style: TextStyle(
                      color: _selectedPage.contains('Đơn hàng')
                          ? Colors.black
                          : Colors.black,
                      fontWeight: _selectedPage == 'Đơn hàng'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  initiallyExpanded: _selectedPage.contains('Đơn hàng'),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _expandedTiles['Đơn hàng'] = expanded;
                    });
                  },
                  children: [
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[1] != 2)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          decoration: BoxDecoration(
                            color: _selectedPage == 'Đơn hàng > Tất cả đơn hàng'
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow:
                                _selectedPage == 'Đơn hàng > Tất cả đơn hàng'
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 2,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : [],
                          ),
                          child: ListTile(
                            leading: const Visibility(
                              visible: false,
                              child: Icon(Icons.pending),
                            ),
                            title: Text(
                              'Tất cả đơn hàng',
                              style: TextStyle(
                                color: _selectedPage ==
                                        'Đơn hàng > Tất cả đơn hàng'
                                    ? Colors.black
                                    : Colors.black54,
                                fontWeight: _selectedPage ==
                                        'Đơn hàng > Tất cả đơn hàng'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedPage = 'Đơn hàng > Tất cả đơn hàng';
                              });
                              if (isScreenWide) {
                                setState(() {
                                  _expandedTiles['Đơn hàng'] = false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                              context.go('/orders', extra: staffData);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // San pham

              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Icon(
                    Icons.sell_outlined,
                    color: _selectedPage.contains('Sản phẩm')
                        ? Colors.blueAccent
                        : Colors.black,
                  ),
                  title: Text(
                    'Sản phẩm',
                    style: TextStyle(
                      color: _selectedPage.contains('Sản phẩm')
                          ? Colors.black
                          : Colors.black,
                    ),
                  ),
                  initiallyExpanded: _selectedPage.contains('Sản phẩm'),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _expandedTiles['Sản phẩm'] = expanded;
                    });
                  },
                  children: [
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[2] != 2)
                      ClipRRect(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          child: ListTile(
                            leading: const Visibility(
                              visible: false,
                              child: Icon(Icons.inventory),
                            ),
                            title: Text(
                              'Tất cả sản phẩm',
                              style: TextStyle(
                                color: _selectedPage ==
                                        'Sản phẩm > Tất cả sản phẩm'
                                    ? Colors.black
                                    : Colors.black54,
                                fontWeight: _selectedPage ==
                                        'Sản phẩm > Tất cả sản phẩm'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedPage = 'Sản phẩm > Tất cả sản phẩm';
                              });
                              if (isScreenWide) {
                                setState(() {
                                  _expandedTiles['Sản phẩm > Tất cả sản phẩm'] =
                                      false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                              context.go('/products', extra: staffData);
                            },
                          ),
                        ),
                      ),
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[3] != 2)
                      ClipRRect(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          child: ListTile(
                            leading: const Visibility(
                              visible: false,
                              child: Icon(Icons.add),
                            ),
                            title: Text(
                              'Sản phẩm mới',
                              style: TextStyle(
                                color:
                                    _selectedPage == 'Sản phẩm > Sản phẩm mới'
                                        ? Colors.black
                                        : Colors.black54,
                                fontWeight:
                                    _selectedPage == 'Sản phẩm > Sản phẩm mới'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedPage = 'Sản phẩm > Sản phẩm mới';
                              });
                              if (isScreenWide) {
                                setState(() {
                                  _isDrawerOpen = false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                              context.go('/new_products', extra: staffData);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (roleDetail == null ||
                  roleDetail!.isEmpty ||
                  roleDetail?[4] != 2)
                Container(
                  decoration: BoxDecoration(
                    color: _selectedPage == 'Khách hàng'
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: _selectedPage == 'Khách hàng'
                        ? [
                            const BoxShadow(
                              color: Colors.black45,
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            )
                          ]
                        : [],
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.people_alt_outlined,
                      color: _selectedPage == 'Khách hàng'
                          ? Colors.blueAccent
                          : Colors.black,
                    ),
                    title: Text(
                      'Khách hàng',
                      style: TextStyle(
                        color: _selectedPage == 'Khách hàng'
                            ? Colors.black
                            : Colors.black,
                        fontWeight: _selectedPage == 'Khách hàng'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedPage = 'Khách hàng';
                      });
                      if (isScreenWide) {
                        setState(() {
                          _isDrawerOpen = false;
                        });
                      } else {
                        Navigator.pop(context);
                      }
                      context.go('/customers', extra: staffData);
                    },
                  ),
                ),

              //Nhap va xuat
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Icon(
                    Icons.inventory_2_outlined,
                    color: _selectedPage.contains('Quản lý tồn kho')
                        ? Colors.blueAccent
                        : Colors.black,
                  ),
                  title: Text(
                    'Quản lý tồn kho',
                    style: TextStyle(
                      color: _selectedPage.contains('Quản lý tồn kho')
                          ? Colors.black
                          : Colors.black,
                    ),
                  ),
                  initiallyExpanded: _selectedPage.contains('Quản lý tồn kho'),
                  children: [
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[5] != 2)
                      ClipRRect(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          child: ListTile(
                            leading: const Visibility(
                              visible: false,
                              child: Icon(Icons.add),
                            ),
                            title: Text(
                              'Chi tiết tồn kho',
                              style: TextStyle(
                                color: _selectedPage ==
                                        'Quản lý tồn kho > Chi tiết tồn kho'
                                    ? Colors.black
                                    : Colors.black54,
                                fontWeight: _selectedPage ==
                                        'Quản lý tồn kho > Chi tiết tồn kho'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedPage =
                                    'Quản lý tồn kho > Chi tiết tồn kho';
                              });
                              if (isScreenWide) {
                                setState(() {
                                  _isDrawerOpen = false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                              context.go('/adjust_overview', extra: staffData);
                            },
                          ),
                        ),
                      ),
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[6] != 2)
                      ClipRRect(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          child: ListTile(
                            leading: const Visibility(
                              visible: false,
                              child: Icon(Icons.add),
                            ),
                            title: Text(
                              'Phiếu điều chỉnh',
                              style: TextStyle(
                                color: _selectedPage ==
                                        'Quản lý tồn kho > Phiếu điều chỉnh'
                                    ? Colors.black
                                    : Colors.black54,
                                fontWeight: _selectedPage ==
                                        'Quản lý tồn kho > Phiếu điều chỉnh'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedPage =
                                    'Quản lý tồn kho > Phiếu điều chỉnh';
                              });
                              if (isScreenWide) {
                                setState(() {
                                  _isDrawerOpen = false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                              context.go('/new_adjust', extra: staffData);
                            },
                          ),
                        ),
                      ),
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[7] != 2)
                      ClipRRect(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          child: ListTile(
                            leading: const Visibility(
                              visible: false,
                              child: Icon(Icons.add),
                            ),
                            title: Text(
                              'Lịch sử',
                              style: TextStyle(
                                color:
                                    _selectedPage == 'Quản lý tồn kho > Lịch sử'
                                        ? Colors.black
                                        : Colors.black54,
                                fontWeight:
                                    _selectedPage == 'Quản lý tồn kho > Lịch sử'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedPage = 'Quản lý tồn kho > Lịch sử';
                              });
                              if (isScreenWide) {
                                setState(() {
                                  _isDrawerOpen = false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                              context.go('/adjusts', extra: staffData);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              //Khuyen mai
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Icon(
                    Icons.card_giftcard,
                    color: _selectedPage.contains('Khuyến mãi')
                        ? Colors.blueAccent
                        : Colors.black,
                  ),
                  title: Text(
                    'Khuyến mãi',
                    style: TextStyle(
                      color: _selectedPage.contains('Khuyến mãi')
                          ? Colors.black
                          : Colors.black,
                    ),
                  ),
                  initiallyExpanded: _selectedPage.contains('Khuyến mãi'),
                  children: [
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[8] != 2)
                      ClipRRect(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          child: ListTile(
                            leading: const Visibility(
                              visible: false,
                              child: Icon(Icons.add),
                            ),
                            title: Text(
                              'Tất cả khuyến mãi',
                              style: TextStyle(
                                color: _selectedPage ==
                                        'Khuyến mãi > Tất cả khuyến mãi'
                                    ? Colors.black
                                    : Colors.black54,
                                fontWeight: _selectedPage ==
                                        'Khuyến mãi > Tất cả khuyến mãi'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedPage =
                                    'Khuyến mãi > Tất cả khuyến mãi';
                              });
                              if (isScreenWide) {
                                setState(() {
                                  _isDrawerOpen = false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                              context.go('/promotions', extra: staffData);
                            },
                          ),
                        ),
                      ),
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[9] != 2)
                      ClipRRect(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          child: ListTile(
                            leading: const Visibility(
                              visible: false,
                              child: Icon(Icons.inventory),
                            ),
                            title: Text(
                              'Khuyến mãi mới',
                              style: TextStyle(
                                color: _selectedPage ==
                                        'Khuyến mãi > Khuyến mãi mới'
                                    ? Colors.black
                                    : Colors.black54,
                                fontWeight: _selectedPage ==
                                        'Khuyến mãi > Khuyến mãi mới'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedPage = 'Khuyến mãi > Khuyến mãi mới';
                              });
                              if (isScreenWide) {
                                setState(() {
                                  _isDrawerOpen = false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                              context.go('/new_promotion', extra: staffData);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              //Bao cao
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Icon(
                    Icons.insert_chart_outlined,
                    color: _selectedPage.contains('Báo cáo')
                        ? Colors.blueAccent
                        : Colors.black,
                  ),
                  title: Text(
                    'Báo cáo',
                    style: TextStyle(
                      color: _selectedPage.contains('Báo cáo')
                          ? Colors.black
                          : Colors.black,
                    ),
                  ),
                  initiallyExpanded: _selectedPage.contains('Báo cáo'),
                  children: [
                    if (roleDetail == null ||
                        roleDetail!.isEmpty ||
                        roleDetail?[10] != 2)
                      ClipRRect(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          child: ListTile(
                            leading: const Visibility(
                              visible: false,
                              child: Icon(Icons.add),
                            ),
                            title: Text(
                              'Bảng phân tích',
                              style: TextStyle(
                                color:
                                    _selectedPage == 'Báo cáo > Bảng phân tích'
                                        ? Colors.black
                                        : Colors.black54,
                                fontWeight:
                                    _selectedPage == 'Báo cáo > Bảng phân tích'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedPage = 'Báo cáo > Bảng phân tích';
                              });
                              if (isScreenWide) {
                                setState(() {
                                  _isDrawerOpen = false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                              context.go('/reports', extra: staffData);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            color:
                _selectedPage == 'Cấu hình' ? Colors.blueAccent : Colors.black,
          ),
          title: Text(
            'Cấu hình',
            style: TextStyle(
              color: _selectedPage == 'Cấu hình'
                  ? Colors.blueAccent
                  : Colors.black,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedPage = 'Cấu hình';
            });
            if (isScreenWide) {
              setState(() {
                _isDrawerOpen = false;
              });
            } else {
              Navigator.pop(context);
            }
            context.go('/setting', extra: staffData);
          },
        ),
      ],
    );
  }
}
