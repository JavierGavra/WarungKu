import 'package:flutter/material.dart';
import 'package:warung_ku/features/product_catalog/views/product_catalog_page.dart';
import 'package:warung_ku/features/sales_summary/views/sales_summary_page.dart';
import 'package:warung_ku/features/stock_alert/views/pages/stock_alert_page.dart';
import 'package:warung_ku/features/transaction/views/transaction_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget buildMenu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.12),
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color, size: 34),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.primary,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(18),
            child: Column(
              children: [
                SafeArea(
                  left: false,
                  right: false,
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.store,
                            size: 32,
                            color: color.primaryContainer,
                          ),
                          Text(
                            "WarungKu",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: color.onPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Kelola produk, transaksi, dan persediaan dengan mudah.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: color.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // Quick Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _InfoCard(
                      title: "Total Produk",
                      value: "36",
                      icon: Icons.inventory_2_outlined,
                      iconColor: Colors.blue,
                    ),
                    _InfoCard(
                      title: "Transaksi Hari Ini",
                      value: "12",
                      icon: Icons.receipt_long_outlined,
                      iconColor: Colors.green,
                    ),
                    _InfoCard(
                      title: "Stok Tipis",
                      value: "5",
                      icon: Icons.warning_amber_outlined,
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: GridView(
                padding: const EdgeInsets.only(top: 6),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 1.15,
                ),
                children: [
                  buildMenu(
                    title: "Katalog Produk",
                    icon: Icons.inventory_2,
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProductCatalogPage(),
                      ),
                    ),
                  ),
                  buildMenu(
                    title: "Transaksi",
                    icon: Icons.point_of_sale,
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransactionPage(),
                      ),
                    ),
                  ),
                  buildMenu(
                    title: "Ringkasan Penjualan",
                    icon: Icons.bar_chart_rounded,
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SalesSummaryPage(
                          omzetHariIni:
                              1250000, // ganti dengan data nyata dari model atau API
                          perubahanOmzet: 5.2, // persentase perubahan
                          totalTransaksi: 12,
                          totalItemTerjual: 34,
                          produkTerlaris: 'Nasi Goreng Spesial',
                          jumlahTerlaris: 10,
                          gambarTerlaris:
                              'https://example.com/image.png', // optional
                        ),
                      ),
                    ),
                  ),
                  buildMenu(
                    title: "Peringatan Stok",
                    icon: Icons.warning_amber_rounded,
                    color: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StockAlertPage()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: color.secondaryContainer,
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Icon(icon, size: 32, color: iconColor),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color.onSecondaryContainer,
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
