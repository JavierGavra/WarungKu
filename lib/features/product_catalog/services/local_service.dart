import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:warung_ku/features/product_catalog/models/product.dart';

class LocalService {
  static final LocalService instance = LocalService._init();
  static Database? _db;

  LocalService._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('warungku.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
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
      )
    ''');
  }

  Future<void> insertProduct(Product p) async {
    final db = await instance.database;
    await db.insert(
      "products",
      p.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getLocalProducts() async {
    final db = await instance.database;
    final data = await db.query(
      "products",
      where: "is_deleted = 0",
      orderBy: "updated_at DESC",
    );
    return data.map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Product>> getUnsyncedProducts() async {
    final db = await instance.database;
    final data = await db.query("products", where: "is_local = 1");
    return data.map((e) => Product.fromMap(e)).toList();
  }

  Future<void> updateProduct(Product p) async {
    final db = await instance.database;
    await db.update("products", p.toMap(), where: "id = ?", whereArgs: [p.id]);
  }

  Future<void> deleteProductLocal(String id) async {
    final db = await instance.database;
    await db.update(
      "products",
      {"is_deleted": 1, "is_local": 1},
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
