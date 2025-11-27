import 'package:flutter/material.dart';
import 'package:warung_ku/features/product_catalog/models/product.dart';
import 'package:warung_ku/features/product_catalog/services/product_repository.dart';
import 'package:uuid/uuid.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final repo = ProductRepository();

  late TextEditingController nama;
  late TextEditingController harga;
  late TextEditingController stok;

  @override
  void initState() {
    super.initState();
    nama = TextEditingController(text: widget.product?.nama ?? "");
    harga = TextEditingController(
        text: widget.product?.harga.toString() ?? "");
    stok = TextEditingController(
        text: widget.product?.stok.toString() ?? "");
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();

    final product = Product(
      id: widget.product?.id ?? const Uuid().v4(),
      nama: nama.text,
      harga: int.parse(harga.text),
      stok: int.parse(stok.text),
      updatedAt: now,
      isDeleted: false,
      isLocal: true, // perubahan dari device
      image: null,
    );

    if (widget.product == null) {
      await repo.addProduct(product);
    } else {
      await repo.updateProduct(product);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(widget.product == null
                ? "Tambah Produk"
                : "Edit Produk"),
            TextFormField(
              controller: nama,
              decoration: const InputDecoration(labelText: "Nama Produk"),
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),
            TextFormField(
              controller: harga,
              decoration: const InputDecoration(labelText: "Harga"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: stok,
              decoration: const InputDecoration(labelText: "Stok"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: save, child: Text("Simpan"))
          ]),
        ),
      ),
    );
  }
}
