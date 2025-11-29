class StockAlertModel {
  final String productName;
  final int stock;
  final int minStock;

  StockAlertModel({
    required this.productName,
    required this.stock,
    required this.minStock,
  });

  bool get isLowStock => stock <= minStock;
}
