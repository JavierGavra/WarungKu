class Product {
  final String id;
  final String nama;
  final int harga;
  final int stok;
  final String barcode;
  final String? image;

  Product({
    required this.id,
    required this.nama,
    required this.harga,
    required this.stok,
    required this.barcode,
    this.image,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      nama: map['nama'],
      harga: map['harga'],
      stok: map['stok'],
      barcode: map['barcode'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nama": nama,
      "harga": harga,
      "stok": stok,
      "barcode": barcode,
      "image": image,
      "updated_at": DateTime.now().toIso8601String(),
      "is_deleted": 0,
      "is_local": 1,
    };
  }
}