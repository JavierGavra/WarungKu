import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:warung_ku/features/product_catalog/models/product.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<void> upsertProduct(Product p) async {
    await supabase.from("products").upsert({
      'id': p.id,
      'nama': p.nama,
      'harga': p.harga,
      'stok': p.stok,
      'barcode': p.barcode,
      'image': p.image,
      'updated_at': p.updatedAt.toIso8601String(),
      'is_deleted': p.isDeleted,
    });
  }

  Future<List<Product>> getUpdatedProducts(DateTime lastSync) async {
    final data = await supabase
        .from("products")
        .select()
        .gte("updated_at", lastSync.toIso8601String());

    return data
        .map<Product>(
          (map) => Product(
            id: map['id'],
            nama: map['nama'],
            harga: map['harga'],
            stok: map['stok'],
            barcode: map['barcode'],
            image: map['image'],
            updatedAt: DateTime.parse(map['updated_at']),
            isDeleted: map['is_deleted'],
            isLocal: false,
          ),
        )
        .toList();
  }
}
