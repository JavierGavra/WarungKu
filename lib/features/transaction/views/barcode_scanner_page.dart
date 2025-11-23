import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:warung_ku/features/transaction/models/product.dart';

class BarcodeScannerPage extends StatefulWidget {
  final List<Product> productList;

  const BarcodeScannerPage({super.key, required this.productList});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool isScanning = true;

  void onDetect(BarcodeCapture capture) {
    if (!isScanning) return;
    isScanning = false;

    final barcode = capture.barcodes.first.rawValue ?? "";
    print("Scanned Barcode: $barcode");

    // Cari produk berdasarkan barcode
    final Product foundProduct = widget.productList.firstWhere(
      (p) => p.barcode == barcode,
      orElse: () => Product(id: -1, name: "", price: 0, barcode: ""),
    );

    if (foundProduct.id == -1) {
      // Produk tidak ditemukan
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Produk Tidak Ditemukan"),
          content: Text("Barcode: $barcode tidak terdaftar."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // tutup dialog
                isScanning = true; // lanjut scan lagi
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Produk ditemukan → kembali ke TransactionPage
      Navigator.pop(context, foundProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Barcode")),
      body: MobileScanner(onDetect: onDetect),
    );
  }
}
