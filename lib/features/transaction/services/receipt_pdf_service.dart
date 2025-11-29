import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import '../models/product.dart';

class ReceiptPdfService {
  static Future<Uint8List> generate({
    required Map<Product, int> cart,
    required int total,
    required String transactionId,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "WARUNGKU",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text("STRUK PEMBELIAN"),
            pw.SizedBox(height: 8),
            pw.Text("ID Transaksi : $transactionId"),
            pw.Divider(),

            ...cart.entries.map(
              (e) => pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("${e.key.nama} x ${e.value}"),
                  pw.Text("Rp ${e.key.harga * e.value}"),
                ],
              ),
            ),

            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "TOTAL: Rp $total",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text("Terima kasih telah berbelanja :D"),
          ],
        ),
      ),
    );

    return pdf.save();
  }
}
