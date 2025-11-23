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

  @override
  String toString() {
    return "Product($id, $name, $price, $barcode)";
  }

  static List<Product> get dummyProductList => [
    Product(
      id: 1,
      name: "Indomie Goreng",
      price: 3500,
      barcode: "8992716651457",
    ),
    Product(id: 2, name: "Aqua 600ml", price: 4500, barcode: "8886008101053"),
    Product(
      id: 3,
      name: "Teh Pucuk Harum 350ml",
      price: 5000,
      barcode: "8998866100214",
    ),
    Product(
      id: 4,
      name: "Kopi Kapal Api Special",
      price: 2000,
      barcode: "8991002102018",
    ),
    Product(
      id: 5,
      name: "SilverQueen 65g",
      price: 14000,
      barcode: "8991002101332",
    ),
    Product(
      id: 6,
      name: "Tolak Angin Cair",
      price: 3500,
      barcode: "8992802017201",
    ),
    Product(
      id: 7,
      name: "Susu Ultra Milk Coklat 250ml",
      price: 6500,
      barcode: "8998009011043",
    ),
    Product(
      id: 8,
      name: "Beng-Beng Wafer",
      price: 2000,
      barcode: "8996001301014",
    ),
    Product(
      id: 9,
      name: "Chitato Sapi Panggang 68g",
      price: 11500,
      barcode: "8999999045001",
    ),
    Product(
      id: 10,
      name: "Pocari Sweat 500ml",
      price: 9000,
      barcode: "8997035564034",
    ),
    Product(
      id: 11,
      name: "Good Day Cappuccino",
      price: 1500,
      barcode: "8994493107015",
    ),
    Product(
      id: 12,
      name: "Sprite 390ml",
      price: 5500,
      barcode: "8992759255408",
    ),
    Product(
      id: 13,
      name: "Sari Roti Tawar",
      price: 15000,
      barcode: "8997220160017",
    ),
    Product(id: 14, name: "Gulaku 1kg", price: 17000, barcode: "8997026800012"),
    Product(
      id: 15,
      name: "Minyak Goreng Bimoli 1L",
      price: 15500,
      barcode: "8997225211011",
    ),
    Product(
      id: 16,
      name: "Beras Maknyuss 5kg",
      price: 62000,
      barcode: "8993702000017",
    ),
    Product(
      id: 17,
      name: "Mie Sedaap Ayam Bawang",
      price: 3000,
      barcode: "8998866601742",
    ),
    Product(
      id: 18,
      name: "Garam Cap Kapal 500g",
      price: 4000,
      barcode: "8997007751234",
    ),
    Product(
      id: 19,
      name: "Soffel 13Lt",
      price: 13000,
      barcode: "8992772915007",
    ),
    Product(
      id: 20,
      name: "Baygon Spray Lemon 600ml",
      price: 29000,
      barcode: "8998899001239",
    ),
  ];
}
