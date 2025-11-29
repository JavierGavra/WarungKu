import 'package:flutter/material.dart';
import 'package:warung_ku/features/transaction/models/product.dart';

Future<void> addProductDialog({
  required BuildContext context,
  required List<Product> productList,
  required Function(Product product, int qty) onAdd,
}) async {
  Product? selectedProduct;
  int qty = 1;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModal) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                      child: Text("${p.nama} - Rp ${p.harga}"),
                    );
                  }).toList(),
                  onChanged: (value) => setModal(() => selectedProduct = value),
                ),
                const SizedBox(height: 6),
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
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: selectedProduct == null
                      ? null
                      : () {
                          onAdd(selectedProduct!, qty);
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
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      );
    },
  );
}
