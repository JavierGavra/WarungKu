class Product {
  final int id;
  final String name;
  final int price;
  final String barcode; // Tambahkan barcode dummy

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.barcode,
  });

  static List<Product> get dummyProductList => List.generate(
    20,
    (i) => Product(
      id: i,
      name: "Produk ${i + 1}",
      price: (i + 1) * 1500,
      barcode: "0000${i + 1}", // barcode dummy
    ),
  );
}
