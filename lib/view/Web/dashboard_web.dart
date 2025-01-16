import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dashboard/dashboard.dart';
import 'order/list_order.dart';
import 'product/list_product/list_product.dart';
import 'product/new_product/new_product.dart';
import 'customer/list_customer/list_customer.dart';
import 'inventory/inventory_overall/inventory_details.dart';
import 'inventory/adjust_inventory/adjust_inventory.dart';
import 'inventory/adjust_history/adjust_inventory_history.dart';
import 'promotion/new_promotion.dart';
import 'promotion/list_promotion.dart';
import 'report/analysis.dart';
import 'setting/setting_screen.dart';
import 'drawer.dart';
import '../../shared/core/theme/colors_app.dart';

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: DashboardWeb(
        navigatorKey: navigatorKey,
      ),
    );
  }
}

class DashboardWeb extends StatefulWidget {
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> navigatorKey;
  const DashboardWeb({super.key, required this.navigatorKey});

  @override
  _DashboardWebState createState() => _DashboardWebState();
}

class _DashboardWebState extends State<DashboardWeb> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedPage = '';
  late double maxWidth;
  bool _isDrawerOpen = true;

  final Map<String, bool> _expandedTiles = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedPage = 'Tổng quan';
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    bool isScreenWide =  maxWidth > 800;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text( _selectedPage.isEmpty ? "Tổng quan" : _selectedPage,),
        backgroundColor: AppColors.backgroundColor,
        leading: isScreenWide
            ? null
            :
            IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  final scaffoldState = _scaffoldKey.currentState;
                  if (scaffoldState != null) {
                    if (scaffoldState.isDrawerOpen) {
                      scaffoldState.closeDrawer();
                    } else {
                      scaffoldState.openDrawer();
                    }
                  } else {
                    print("Scaffold state is null");
                  }
                  setState(() {
                    //
                  });
                },
              ),
      ),
      drawer: isScreenWide ? null : Drawer(
        child: Container(
          color: Colors.white,
          child: _buildDrawer(isScreenWide),
        ),
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
            child: Navigator(
              key: widget.navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (context) => _buildPage(_selectedPage),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
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
                          leading: const Visibility(visible: false, child: Icon(Icons.pending),
                          ),
                          title: Text(
                            'Tất cả đơn hàng',
                            style: TextStyle(
                              color:
                                  _selectedPage == 'Đơn hàng > Tất cả đơn hàng' ? Colors.black : Colors.black54,
                              fontWeight:
                                  _selectedPage == 'Đơn hàng > Tất cả đơn hàng' ? FontWeight.bold : FontWeight.normal,
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
                              color:
                                  _selectedPage == 'Sản phẩm > Tất cả sản phẩm'
                                      ? Colors.black
                                      : Colors.black54,
                              fontWeight:
                                  _selectedPage == 'Sản phẩm > Tất cả sản phẩm'
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
                                _expandedTiles['Sản phẩm > Tất cả sản phẩm'] = false;
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ),
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
                              color: _selectedPage == 'Sản phẩm > Sản phẩm mới'
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
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
                          },
                        ),
                      ),
                    ),
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
                          },
                        ),
                      ),
                    ),
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
                              _selectedPage = 'Khuyến mãi > Tất cả khuyến mãi';
                            });
                            if (isScreenWide) {
                              setState(() {
                                _isDrawerOpen = false;
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ),
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
                              color:
                                  _selectedPage == 'Khuyến mãi > Khuyến mãi mới'
                                      ? Colors.black
                                      : Colors.black54,
                              fontWeight:
                                  _selectedPage == 'Khuyến mãi > Khuyến mãi mới'
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
                              color: _selectedPage == 'Báo cáo > Bảng phân tích'
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
          },
        ),
      ],
    );
  }

  // void _onPageSelected(String page) {
  //   Navigator.pop(context);
  //   if (kDebugMode) {
  //     print("Đang chọn trang: $page");
  //   }
  //   setState(() {
  //     _selectedPage = page;
  //   });
  //   widget.navigatorKey.currentState!.pushAndRemoveUntil(
  //     MaterialPageRoute(builder: (context) => _buildPage(page)),
  //     (Route<dynamic> route) =>
  //         false,
  //   );
  // }

  void _onPageSelected(String page) {

    if (MediaQuery.of(context).size.width > 800) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return _buildPage(page);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    } else {
      setState(() {
        _selectedPage = page;
      });
      Navigator.pop(context);
    }
  }

  Widget _buildPage(String page) {

    switch (page) {
      case 'Tổng quan':
        return DashboardPage();
      case 'Đơn hàng > Tất cả đơn hàng':
        return ListOrder();
      case 'Sản phẩm > Tất cả sản phẩm':
        return ListProduct();
      case 'Sản phẩm > Sản phẩm mới':
        return const NewProduct();
      case 'Khách hàng':
        return CustomerList();
      case 'Quản lý tồn kho > Chi tiết tồn kho':
        return InventoryOverall();
      case 'Quản lý tồn kho > Phiếu điều chỉnh':
        return AdjustInventory();
      case 'Quản lý tồn kho > Lịch sử':
        return AdjustInventoryHistory();
      case 'Khuyến mãi > Tất cả khuyến mãi':
        return ListPromotion();
      case 'Khuyến mãi > Khuyến mãi mới':
        return NewPromotion();
      case 'Báo cáo > Bảng phân tích':
        return const Analysis();
      case 'Cấu hình':
        return const SettingScreenetting();
      default:
        return const Center(child: Text("Màn hình không tồn tại"));
    }
  }
}
