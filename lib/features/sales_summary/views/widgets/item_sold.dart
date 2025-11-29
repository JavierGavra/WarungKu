import 'package:flutter/material.dart';

class ItemTerjualHariIniWidget extends StatelessWidget {
  final int totalItemTerjual;
  final String? produkTerlaris;

  const ItemTerjualHariIniWidget({
    super.key,
    required this.totalItemTerjual,
    this.produkTerlaris,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item Terjual Hari Ini',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              '$totalItemTerjual',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          if (produkTerlaris != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Produk terlaris: $produkTerlaris',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
        ],
      ),
    );
  }
}
