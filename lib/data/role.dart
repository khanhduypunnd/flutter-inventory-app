class Role {
  final String id;
  final String name;
  final int order;
  final int list_product;
  final int new_product;
  final int list_customer;
  final int inventory_detail;
  final int adjust_inventory;
  final int adjust_history;
  final int list_promotion;
  final int new_promotion;
  final int report;
  final int setting;

  Role({
    required this.id,
    required this.name,
    required this.order,
    required this.list_product,
    required this.new_product,
    required this.list_customer,
    required this.inventory_detail,
    required this.adjust_inventory,
    required this.adjust_history,
    required this.list_promotion,
    required this.new_promotion,
    required this.report,
    required this.setting,
  });
}