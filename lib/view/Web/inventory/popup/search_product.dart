import 'package:flutter/material.dart';
import '../../../../data/product.dart';
import '../../../../shared/core/theme/colors_app.dart';

class SearchResultsDialog extends StatefulWidget {
  final List<Product> searchResults;
  final Function(Product, List<String>) onSelect;
  final List<Product> selectedProducts;

  const SearchResultsDialog({
    Key? key,
    required this.searchResults,
    required this.onSelect,
    required this.selectedProducts,
  }) : super(key: key);

  @override
  _SearchResultsDialogState createState() => _SearchResultsDialogState();
}

class _SearchResultsDialogState extends State<SearchResultsDialog> {
  List<Product> selectedProducts = [];
  Map<String, Map<int, bool>> selectedSizes = {};

  @override
  void initState() {
    super.initState();
    for (var product in widget.searchResults) {
      selectedSizes[product.id] = {};
      for (var i = 0; i < product.sizes.length; i++) {
        selectedSizes[product.id]![i] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.searchResults.length,
                itemBuilder: (context, productIndex) {
                  final product = widget.searchResults[productIndex];
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  color: AppColors.titleColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: product.sizes.length,
                            itemBuilder: (context, sizeIndex) {
                              final size = product.sizes[sizeIndex];

                              final isDisabled = widget.selectedProducts.any(
                                    (selectedProduct) =>
                                selectedProduct.id == product.id &&
                                    selectedProduct.sizes.contains(size),
                              );

                              return Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.blueAccent,
                                    value: selectedSizes[product.id]?[sizeIndex] ?? false,
                                    onChanged: isDisabled
                                        ? null
                                        : (bool? value) {
                                      setState(() {
                                        selectedSizes[product.id]?[sizeIndex] = value ?? false;
                                      });
                                    },
                                  ),
                                  Text(size),
                                  const Spacer(),
                                  Text("${product.quantities[sizeIndex]} tồn kho"),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                final Map<Product, List<String>> selectedData = {};
                for (var product in widget.searchResults) {
                  final selectedSizesList = selectedSizes[product.id]!.entries
                      .where((entry) => entry.value)
                      .map((entry) => product.sizes[entry.key])
                      .toList();

                  if (selectedSizesList.isNotEmpty) {
                    selectedData[product] = selectedSizesList;
                  }
                }

                if (selectedData.isNotEmpty) {
                  for (var entry in selectedData.entries) {
                    widget.onSelect(entry.key, entry.value);
                  }
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng chọn ít nhất một sản phẩm!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }
}
