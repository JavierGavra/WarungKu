import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';

class LocalService {
  static final LocalService instance = LocalService._init();
  static Database? _db;

  LocalService._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB("warungku.db");
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        nama TEXT NOT NULL,
        harga INTEGER NOT NULL,
        stok INTEGER NOT NULL,
        barcode TEXT NOT NULL,
        image TEXT,
        updated_at TEXT NOT NULL,
        is_deleted INTEGER NOT NULL DEFAULT 0,
        is_local INTEGER NOT NULL DEFAULT 1
      );
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        total INTEGER NOT NULL,
        date TEXT NOT NULL,
        is_local INTEGER NOT NULL DEFAULT 1
      );
    ''');

    await db.execute('''
      CREATE TABLE transaction_items (
        id TEXT PRIMARY KEY,
        transaction_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        qty INTEGER NOT NULL,
        subtotal INTEGER NOT NULL,
        FOREIGN KEY (transaction_id) REFERENCES transactions(id),
        FOREIGN KEY (product_id) REFERENCES products(id)
      );
    ''');
  }

  // ===================== PRODUCTS =====================

  Future<List<Product>> getLocalProducts() async {
    final db = await database;
    final data = await db.query(
      "products",
      where: "is_deleted = 0",
      orderBy: "updated_at DESC",
    );
    return data.map((e) => Product.fromMap(e)).toList();
  }

  Future<void> updateProductStock(Product p, int qty) async {
    final db = await database;
    await db.update(
      "products",
      {
        "stok": p.stok - qty,
        "updated_at": DateTime.now().toIso8601String(),
        "is_local": 1,
      },
      where: "id = ?",
      whereArgs: [p.id],
    );
  }

  // ===================== TRANSACTIONS =====================

  Future<void> createTransaction({
    required Map<Product, int> cart,
  }) async {
    final db = await database;
    final trxId = const Uuid().v4();
    int total = 0;

    for (var entry in cart.entries) {
      total += entry.key.harga * entry.value;
    }

    await db.insert("transactions", {
      "id": trxId,
      "total": total,
      "date": DateTime.now().toIso8601String(),
      "is_local": 1,
    });

    for (var entry in cart.entries) {
      final p = entry.key;
      final qty = entry.value;

      await db.insert("transaction_items", {
        "id": const Uuid().v4(),
        "transaction_id": trxId,
        "product_id": p.id,
        "qty": qty,
        "subtotal": p.harga * qty,
      });

      await updateProductStock(p, qty);
    }
  }
}
