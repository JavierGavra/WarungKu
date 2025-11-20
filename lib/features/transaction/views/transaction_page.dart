import 'package:flutter/material.dart';
import 'package:warung_ku/features/transaction/models/product.dart';
import 'scanner_page.dart'; // Import file scanner baru

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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (result == null) return;

    final scannedCode = result.toString();

    // Cari produk berdasarkan barcode
    final Product? found = productList.firstWhere(
      (p) => p.barcode == scannedCode,
      orElse: () => Product(id: -1, name: "", price: 0, barcode: ""),
    );

    if (found!.id == -1) {
      // Tidak ditemukan
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Produk Tidak Ditemukan"),
          content: Text("Barcode: $scannedCode tidak terdaftar."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Produk ditemukan → tambahkan qty 1 (atau tambah qty jika sudah ada)
    setState(() {
      if (cart.containsKey(found)) {
        cart[found] = cart[found]! + 1;
      } else {
        cart[found] = 1;
      }
    });
  }

  // ─────────────────────────────────────
  // Tombol tambah produk manual (modal)
  // ─────────────────────────────────────
  void openAddProductDialog() {
    Product? selectedProduct;
    int qty = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Tambah Produk",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<Product>(
                    decoration: const InputDecoration(
                      labelText: "Pilih Produk",
                      border: OutlineInputBorder(),
                    ),
                    items: productList.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text("${p.name} - Rp ${p.price}"),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setModal(() => selectedProduct = value),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Quantity", style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (qty > 1) setModal(() => qty--);
                            },
                          ),
                          Text("$qty", style: const TextStyle(fontSize: 18)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => setModal(() => qty++),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: selectedProduct == null
                        ? null
                        : () {
                            setState(() => cart[selectedProduct!] = qty);
                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "Tambahkan",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─────────────────────────────────────
  // UI
  // ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaksi Penjualan"),
        backgroundColor: Colors.blueAccent,
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // FAB scan barcode
          FloatingActionButton(
            heroTag: "scan_barcode",
            backgroundColor: Colors.deepPurple,
            onPressed: scanBarcode,
            child: const Icon(Icons.qr_code_scanner),
          ),
          const SizedBox(height: 12),

          // FAB tambah produk manual
          FloatingActionButton.extended(
            heroTag: "add_product",
            onPressed: openAddProductDialog,
            label: const Text("Tambah Produk"),
            icon: const Icon(Icons.add_shopping_cart),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada produk dipilih",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView(
                    children: cart.entries.map((entry) {
                      final p = entry.key;
                      final qty = entry.value;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(p.name),
                          subtitle: Text("Rp ${p.price} x $qty"),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Rp ${p.price * qty}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => removeFromCart(p),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),

          // Total
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: const Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rp $totalPrice",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
