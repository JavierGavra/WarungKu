import 'product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductSyncService {
  final repo = ProductRepository();

  Future<void> sync() async {
    final prefs = await SharedPreferences.getInstance();

    final lastSyncStr = prefs.getString("last_sync");
    final lastSync = lastSyncStr != null
        ? DateTime.parse(lastSyncStr)
        : DateTime.fromMillisecondsSinceEpoch(0);

    // Step 1: upload local changes
    await repo.syncUp();

    // Step 2: download remote updates
    await repo.syncDown(lastSync);

    // Step 3: update last sync timestamp
    await prefs.setString(
        "last_sync", DateTime.now().toIso8601String());
  }
}
