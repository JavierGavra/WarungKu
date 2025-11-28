import 'package:flutter/material.dart';
import '../services/local_service.dart';
import '../models/product.dart';
import 'widgets/add_product_dialog.dart';
import 'barcode_scanner_page.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Product> productList = [];
  Map<Product, int> cart = {};

  bool isOnline = true;

  int get total {
    int t = 0;
    cart.forEach((p, qty) => t += p.harga * qty);
    return t;
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    productList = await LocalService.instance.getLocalProducts();
    setState(() {});
  }

  void addToCart(Product p) {
    setState(() {
      cart[p] = (cart[p] ?? 0) + 1;
    });
  }

  void removeFromCart(Product p) {
    setState(() => cart.remove(p));
  }

  Future<void> buy() async {
    if (cart.isEmpty) return;

    await LocalService.instance.createTransaction(cart: cart);
    await loadProducts();
    setState(() => cart.clear());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Transaksi berhasil")));
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaksi Penjualan"),
        backgroundColor: color.primary,
        foregroundColor: color.onPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(
              isOnline ? Icons.cloud_done : Icons.cloud_off,
              color: isOnline ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text("Belum ada produk dipilih"))
                : ListView(
                    children: cart.entries.map((entry) {
                      final p = entry.key;
                      final qty = entry.value;

                      return Card(
                        child: ListTile(
                          title: Text(p.nama),
                          subtitle: Text("Rp ${p.harga} x $qty"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Rp ${p.harga * qty}"),
                              IconButton(
                                icon: Icon(Icons.delete, color: color.error),
                                onPressed: () => removeFromCart(p),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          FloatingActionButton.extended(
            heroTag: "add_product",
            label: const Text("Tambah Produk"),
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {
              addProductDialog(
                context: context,
                productList: productList,
                onAdd: (product, qty) => setState(() => cart[product] = qty),
              );
            },
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "scan_barcode",
            backgroundColor: color.tertiaryContainer,
            foregroundColor: color.onTertiaryContainer,
            onPressed: () async {
              final scanned = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BarcodeScannerPage(productList: productList),
                ),
              );
              if (scanned != null) addToCart(scanned);
            },
            child: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),

      // 🔥 Tombol Beli
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: color.primary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: color.tertiary, blurRadius: 5)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Total", style: TextStyle(color: color.onPrimary)),
                        SizedBox(height: 1),
                        Text(
                          "Rp $total",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: color.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_forward_rounded),
                      iconAlignment: IconAlignment.start,
                      label: Text("Bayar"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
