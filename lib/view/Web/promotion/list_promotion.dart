import 'package:flutter/material.dart';
import 'dart:math';
import '../../../shared/core/services/uriApi.dart';
import '../../../shared/core/theme/colors_app.dart';
import '../../../data/promotion.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListPromotion extends StatefulWidget {
  @override
  State<ListPromotion> createState() => _ListPromotionState();
}

class _ListPromotionState extends State<ListPromotion> {
  final ApiService uriAPIService = ApiService();

  int rowsPerPage = 20;
  int currentPage = 1;
  int totalPromotions = 0;
  List<Map<String, dynamic>> promotions = [];
  bool isLoading = false;
  late double maxWidth = 0.0;

  // Checkbox selection states
  List<bool> selectedRows = [];
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    _fetchPromotions();
  }

  Future<void> _fetchPromotions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(uriAPIService.apiUrlGiftCode);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          promotions = jsonData.map((data) {
            final promotion = Promotion.fromJson(data);
            return {
              "id": promotion.id,
              "code": promotion.code,
              "description": promotion.description,
              "value": promotion.value.toString(),
              "value_limit": promotion.valueLimit.toString(),
              "beginning": promotion.beginning.toIso8601String(),
              "expiration": promotion.expiration.toIso8601String() ?? '',
            };
          }).toList();
          totalPromotions = promotions.length;
          selectedRows = List<bool>.filled(promotions.length, false);
        });
      } else {
        throw Exception('Failed to fetch promotions: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching promotions: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterPromotions(String query) {
    setState(() {
      promotions = promotions.where((promotion) {
        final id = promotion["id"].toLowerCase();
        final description = promotion["description"].toLowerCase();
        return id.contains(query.toLowerCase()) ||
            description.contains(query.toLowerCase());
      }).toList();
      totalPromotions = promotions.length;
    });
  }

  void _updateRowsPerPage(int value) {
    setState(() {
      rowsPerPage = value;
      currentPage = 1;
    });
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      selectedRows = List<bool>.filled(promotions.length, selectAll);
    });
  }

  void _toggleRowSelection(int index, bool? value) {
    setState(() {
      selectedRows[index] = value ?? false;
      selectAll = selectedRows.every((isSelected) => isSelected);
    });
  }

  Future<void> _deleteSelectedRows() async {
    setState(() {
      isLoading = true;
    });

    try {
      final selectedIds = promotions
          .asMap()
          .entries
          .where((entry) => selectedRows[entry.key])
          .map((entry) => entry.value["id"])
          .toList();

      for (String id in selectedIds) {
        final url = Uri.parse('${uriAPIService.apiUrlGiftCode}/$id');
        final response = await http.delete(url);

        if (response.statusCode != 200) {
          throw Exception('Failed to delete promotion with ID $id');
        }
      }

      setState(() {
        promotions = promotions
            .asMap()
            .entries
            .where((entry) => !selectedRows[entry.key])
            .map((entry) => entry.value)
            .toList();
        selectedRows = List<bool>.filled(promotions.length, false);
        selectAll = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa các mục được chọn.')),
      );
    } catch (error) {
      print('Error deleting promotions: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa dữ liệu: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showCustomToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalPromotions / rowsPerPage).ceil();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 50, right: 50, bottom: 30, top: 50),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: "Tìm kiếm khuyến mãi...",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _filterPromotions(value);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: selectedRows.contains(true)
                                ? () {
                                    _deleteSelectedRows();
                                    showCustomToast(context, 'Xóa thành công!');
                                  }
                                : null,
                            child: const Text("Xóa"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: maxWidth),
                                child: DataTable(
                                  columnSpacing: 20.0,
                                  columns: [
                                    DataColumn(
                                      label: Checkbox(
                                        activeColor: Colors.blueAccent,
                                        value: selectAll,
                                        onChanged: _toggleSelectAll,
                                      ),
                                    ),
                                    const DataColumn(label: Text('Mã')),
                                    const DataColumn(label: Text('Mô tả')),
                                    const DataColumn(label: Text('Giá trị')),
                                    const DataColumn(label: Text('Giới hạn')),
                                    const DataColumn(label: Text('Bắt đầu')),
                                    const DataColumn(label: Text('Kết thúc')),
                                  ],
                                  rows: promotions.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final promotion = entry.value;
                                    return DataRow(cells: [
                                      DataCell(Checkbox(
                                        activeColor: Colors.blueAccent,
                                        value: selectedRows[index],
                                        onChanged: (value) =>
                                            _toggleRowSelection(index, value),
                                      )),
                                      DataCell(Text(promotion["code"])),
                                      DataCell(Text(promotion["description"])),
                                      DataCell(Text('${promotion["value"]} %')),
                                      DataCell(Text(promotion["value_limit"])),
                                      DataCell(Text(promotion["beginning"])),
                                      DataCell(Text(promotion["expiration"])),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PopupMenuButton<int>(
                              onSelected: _updateRowsPerPage,
                              itemBuilder: (BuildContext context) {
                                return [
                                  const PopupMenuItem<int>(
                                    value: 10,
                                    child: Text("Hiển thị 10"),
                                  ),
                                  const PopupMenuItem<int>(
                                    value: 20,
                                    child: Text("Hiển thị 20"),
                                  ),
                                  const PopupMenuItem<int>(
                                    value: 50,
                                    child: Text("Hiển thị 50"),
                                  ),
                                ];
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Text("Hiển thị $rowsPerPage",
                                        style: const TextStyle(fontSize: 16)),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.first_page),
                                  onPressed: currentPage > 1
                                      ? () {
                                          setState(() {
                                            currentPage = 1;
                                          });
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: currentPage > 1
                                      ? () {
                                          setState(() {
                                            currentPage--;
                                          });
                                        }
                                      : null,
                                ),
                                Text("Trang $currentPage/$totalPages"),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: currentPage < totalPages
                                      ? () {
                                          setState(() {
                                            currentPage++;
                                          });
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.last_page),
                                  onPressed: currentPage < totalPages
                                      ? () {
                                          setState(() {
                                            currentPage = totalPages;
                                          });
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
