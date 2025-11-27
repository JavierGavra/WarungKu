import 'package:warung_ku/features/product_catalog/models/product.dart';
import 'local_service.dart';
import 'supabase_service.dart';

class ProductRepository {
  final _local = LocalService.instance;
  final _remote = SupabaseService();

  Future<void> addProduct(Product p) async {
    await _local.insertProduct(p);
  }

  Future<void> updateProduct(Product p) async {
    await _local.updateProduct(p);
  }

  Future<void> deleteProduct(String id) async {
    await _local.deleteProductLocal(id);
  }

  Future<List<Product>> getLocalProducts() async {
    return await _local.getLocalProducts();
  }

  /// Sync local → supabase
  Future<void> syncUp() async {
    final unsynced = await _local.getUnsyncedProducts();
    for (var p in unsynced) {
      await _remote.upsertProduct(p);
      final updated = p.copyWith(isLocal: false);
      await _local.updateProduct(updated);
    }
  }

  /// Sync supabase → local
  Future<void> syncDown(DateTime lastSync) async {
    final updatedRemote = await _remote.getUpdatedProducts(lastSync);

    for (var p in updatedRemote) {
      await _local.insertProduct(p);
    }
  }
}
