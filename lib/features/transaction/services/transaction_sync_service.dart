import 'package:supabase_flutter/supabase_flutter.dart';
import 'local_service.dart';

class TransactionSyncService {
  static final supabase = Supabase.instance.client;

  static Future<void> sync() async {
    final db = await LocalService.instance.database;

    // ambil transaksi yg belum diupload
    final trxList = await db.query("transactions", where: "is_local = 1");

    for (var trx in trxList) {
      final trxId = trx["id"];

      final items = await db.query(
        "transaction_items",
        where: "transaction_id = ?",
        whereArgs: [trxId],
      );

      await supabase.from("transactions").insert(trx);
      await supabase.from("transaction_items").insert(items);

      await db.update(
        "transactions",
        {"is_local": 0},
        where: "id = ?",
        whereArgs: [trxId],
      );
    }

    // upload stok produk
    final productList = await db.query("products", where: "is_local = 1");
    for (var p in productList) {
      await supabase.from("products").upsert({
        'id': 'id',
        'nama': 'nama',
        'harga': 'harga',
        'stok': 'stok',
        'barcode': 'barcode',
        'image': 'image',
        'updated_at': 'updated_at',
        'is_deleted': 'is_deleted',
      });
      await db.update(
        "products",
        {"is_local": 0},
        where: "id = ?",
        whereArgs: [p["id"]],
      );
    }
  }
}
