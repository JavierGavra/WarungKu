import 'package:flutter/material.dart';
import 'package:warung_ku/features/transaction/models/product.dart';
import 'package:warung_ku/features/transaction/views/widgets/add_product_dialog.dart';
import 'barcode_scanner_page.dart'; // Import file scanner baru

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final List<Product> productList = Product.dummyProductList;
  final Map<Product, int> cart = {};

  int get totalPrice {
    int total = 0;
    cart.forEach((product, qty) {
      total += product.price * qty;
    });
    return total;
  }

  void removeFromCart(Product p) {
    setState(() => cart.remove(p));
  }

  // ─────────────────────────────────────
  // 🔍 SCAN BARCODE → cari produk → masukkan ke keranjang
  // ─────────────────────────────────────
  Future<void> scanBarcode() async {
    final Product? scannedProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeScannerPage(productList: productList),
      ),
    );

    if (scannedProduct == null) return;

    setState(() {
      if (cart.containsKey(scannedProduct)) {
        cart[scannedProduct] = cart[scannedProduct]! + 1;
      } else {
        cart[scannedProduct] = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaksi Penjualan"),
        backgroundColor: color.primary,
        foregroundColor: color.onPrimary,
      ),

      body: Column(
        children: [
          // Total
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color.secondaryContainer,
              border: Border(bottom: BorderSide(color: color.outline)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: color.onPrimaryContainer,
                  ),
                ),
                Text(
                  "Rp $totalPrice",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color.primary,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text("Belum ada produk dipilih"))
                : ListView(
                    children: cart.entries.map((entry) {
                      final p = entry.key;
                      final qty = entry.value;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 2,
                                children: [
                                  Text(
                                    p.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Rp ${p.price} x $qty",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                "Rp ${p.price * qty}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(width: 2, color: color.outline),
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
          // FAB tambah produk manual
          FloatingActionButton.extended(
            heroTag: "add_product",
            onPressed: () {
              addProductDialog(
                context: context,
                productList: productList,
                onAdd: (product, qty) {
                  setState(() {
                    cart[product] = qty;
                  });
                },
              );
            },
            label: const Text("Tambah Produk"),
            icon: const Icon(Icons.add_shopping_cart),
          ),
          const SizedBox(height: 12),

          // FAB scan barcode
          FloatingActionButton(
            heroTag: "scan_barcode",
            backgroundColor: color.tertiaryContainer,
            foregroundColor: color.onTertiaryContainer,
            onPressed: scanBarcode,
            child: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
    );
  }
}
