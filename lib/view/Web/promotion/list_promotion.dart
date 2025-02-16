import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/core/theme/colors_app.dart';
import '../../../view_model/promotion/list_promotion.dart';

class ListPromotion extends StatefulWidget {
  final Map<String, dynamic>? staffData;

  const ListPromotion({super.key, this.staffData});

  @override
  State<ListPromotion> createState() => _ListPromotionState();
}

class _ListPromotionState extends State<ListPromotion> {
  late double maxWidth = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      Provider.of<ListPromotionModel>(context, listen: false)
          .fetchPromotions(context);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    final listPromotionModel = Provider.of<ListPromotionModel>(context);

    int totalPages =
        (listPromotionModel.totalPromotions / listPromotionModel.rowsPerPage)
            .ceil();

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
                                listPromotionModel.filterPromotions(value);
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
                            onPressed:
                                listPromotionModel.selectedRows.contains(true)
                                    ? () {
                                        listPromotionModel
                                            .deleteSelectedRows(context);
                                      }
                                    : null,
                            child: const Text("Xóa"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: listPromotionModel.isLoading
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
                                        value: listPromotionModel.selectAll,
                                        onChanged:
                                            listPromotionModel.toggleSelectAll,
                                      ),
                                    ),
                                    const DataColumn(label: Text('Mã')),
                                    const DataColumn(label: Text('Mô tả')),
                                    const DataColumn(label: Text('Giá trị')),
                                    const DataColumn(label: Text('Giới hạn')),
                                    const DataColumn(label: Text('Bắt đầu')),
                                    const DataColumn(label: Text('Kết thúc')),
                                  ],
                                  rows: listPromotionModel.promotions
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final promotion = entry.value;
                                    return DataRow(cells: [
                                      DataCell(Checkbox(
                                        activeColor: Colors.blueAccent,
                                        value: listPromotionModel
                                            .selectedRows[index],
                                        onChanged: (value) => listPromotionModel
                                            .toggleRowSelection(index, value),
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
                              color: Colors.white,
                              onSelected: listPromotionModel.updateRowsPerPage,
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
                                    Text(
                                        "Hiển thị ${listPromotionModel.rowsPerPage}",
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
                                  onPressed: listPromotionModel.currentPage > 1
                                      ? () {
                                          setState(() {
                                            listPromotionModel.currentPage = 1;
                                          });
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: listPromotionModel.currentPage > 1
                                      ? () {
                                          setState(() {
                                            listPromotionModel.currentPage--;
                                          });
                                        }
                                      : null,
                                ),
                                Text(
                                    "Trang ${listPromotionModel.currentPage}/$totalPages"),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: listPromotionModel.currentPage <
                                          totalPages
                                      ? () {
                                          setState(() {
                                            listPromotionModel.currentPage++;
                                          });
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.last_page),
                                  onPressed: listPromotionModel.currentPage <
                                          totalPages
                                      ? () {
                                          setState(() {
                                            listPromotionModel.currentPage =
                                                totalPages;
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
