class Transaction {
  final String id;
  final DateTime createdAt;
  final int totalAmount;
  // Menyimpan daftar produk yang dibeli dalam format JSON
  final String itemsJson;
  bool isLocal;

  Transaction({
    required this.id,
    required this.createdAt,
    required this.totalAmount,
    required this.itemsJson,
    this.isLocal = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'total_amount': totalAmount,
      'items_json': itemsJson,
      'is_local': isLocal ? 1 : 0,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      totalAmount: map['total_amount'],
      itemsJson: map['items_json'],
      isLocal: map['is_local'] == 1,
    );
  }
}