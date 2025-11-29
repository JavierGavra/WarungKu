import 'package:flutter/material.dart';
import '../views/widgets/daily.dart';
import '../views/widgets/item_sold.dart';
import '../views/widgets/most_sold.dart';
import '../views/widgets/total_transaction.dart';

class SalesSummaryPage extends StatelessWidget {
  final double omzetHariIni;
  final double perubahanOmzet;
  final int totalTransaksi;
  final int totalItemTerjual;
  final String produkTerlaris;
  final int jumlahTerlaris;
  final String? gambarTerlaris;

  const SalesSummaryPage({
    super.key,
    required this.omzetHariIni,
    required this.perubahanOmzet,
    required this.totalTransaksi,
    required this.totalItemTerjual,
    required this.produkTerlaris,
    required this.jumlahTerlaris,
    this.gambarTerlaris,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Penjualan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OmzetHariIniWidget(
              omzetHariIni: omzetHariIni,
              perubahanPersen: perubahanOmzet,
            ),
            const SizedBox(height: 16),
            TotalTransaksiWidget(totalTransaksi: totalTransaksi),
            const SizedBox(height: 16),
            ItemTerjualHariIniWidget(
              totalItemTerjual: totalItemTerjual,
              produkTerlaris: produkTerlaris,
            ),
            const SizedBox(height: 16),
            ProdukTerlarisWidget(
              namaProduk: produkTerlaris,
              jumlahTerjual: jumlahTerlaris,
              imageUrl: gambarTerlaris,
            ),
          ],
        ),
      ),
    );
  }
}
