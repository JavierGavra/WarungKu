import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:warung_ku/features/product_catalog/models/product.dart';
import 'package:warung_ku/features/product_catalog/services/product_repository.dart';
import 'package:warung_ku/features/product_catalog/services/product_sync_service.dart';
import 'package:warung_ku/features/product_catalog/views/product_form_page.dart';

class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  final repo = ProductRepository();
  final sync = ProductSyncService();

  List<Product> products = [];
  bool isOnline = false;
  StreamSubscription? connectionSub;

  @override
  void initState() {
    super.initState();
    loadProducts();
    checkConnection();
  }

  @override
  void dispose() {
    connectionSub?.cancel();
    super.dispose();
  }

  void checkConnection() async {
    final connectivity = Connectivity();

    // cek status saat init
    var result = await connectivity.checkConnectivity();
    updateStatus(result);

    // listen perubahan status jaringan
    connectionSub = connectivity.onConnectivityChanged.listen(updateStatus);
  }

  void updateStatus(List<ConnectivityResult> result) async {
    final wasOffline = !isOnline;

    setState(() {
      isOnline = result.single != ConnectivityResult.none;
    });

    // jika sebelumnya offline lalu sekarang online → langsung sync
    if (wasOffline && isOnline) {
      await sync.sync();
      await loadProducts();
    }
  }

  Future<void> loadProducts() async {
    products = await repo.getLocalProducts();
    setState(() {});
  }

  Future<void> handleRefresh() async {
    if (isOnline) {
      await sync.sync();
    }
    await loadProducts();
  }

  Future<void> openForm([Product? product]) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProductFormPage(product: product),
    );

    if (result == true) {
      loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Catalog"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(
              isOnline ? Icons.cloud_done : Icons.cloud_off,
              color: isOnline ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        child: products.isEmpty
            ? ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 300),
                  Center(child: Text("Belum ada produk")),
                ],
              )
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, i) {
                  final p = products[i];
                  return ListTile(
                    title: Text(p.nama),
                    subtitle: Text("Rp ${p.harga} | Stok: ${p.stok}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => openForm(p),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            repo.deleteProduct(p.id);
                            loadProducts();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
