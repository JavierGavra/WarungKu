class Product {
  final String id;
  final String nama;
  final int harga;
  final int stok;
  final String? image;
  final DateTime updatedAt;
  final bool isDeleted;
  final bool isLocal;

  Product({
    required this.id,
    required this.nama,
    required this.harga,
    required this.stok,
    this.image,
    required this.updatedAt,
    required this.isDeleted,
    required this.isLocal,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nama': nama,
    'harga': harga,
    'stok': stok,
    'image': image,
    'updated_at': updatedAt.toIso8601String(),
    'is_deleted': isDeleted ? 1 : 0,
    'is_local': isLocal ? 1 : 0,
  };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'],
    nama: map['nama'],
    harga: map['harga'],
    stok: map['stok'],
    image: map['image'],
    updatedAt: DateTime.parse(map['updated_at']),
    isDeleted: map['is_deleted'] == 1,
    isLocal: map['is_local'] == 1,
  );

  Product copyWith({
    String? id,
    String? nama,
    int? harga,
    int? stok,
    String? image,
    DateTime? updatedAt,
    bool? isDeleted,
    bool? isLocal,
  }) {
    return Product(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      harga: harga ?? this.harga,
      stok: stok ?? this.stok,
      image: image ?? this.image,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      isLocal: isLocal ?? this.isLocal,
    );
  }
}
