class ProductDetail {
  final String productId;
  final String productName;
  final String size;
  final int oldQuantity;
  final int newQuantity;
  final int different;

  ProductDetail({
    required this.productId,
    required this.productName,
    required this.size,
    required this.oldQuantity,
    required this.newQuantity,
    required this.different,
  });
}