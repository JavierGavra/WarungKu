class SalesRecord {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final DateTime date;

  SalesRecord({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.date,
  });

  double get totalPrice => unitPrice * quantity;

  factory SalesRecord.fromJson(Map<String, dynamic> json) {
    return SalesRecord(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}
