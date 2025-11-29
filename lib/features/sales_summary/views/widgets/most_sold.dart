import 'package:flutter/material.dart';

class ProdukTerlarisWidget extends StatelessWidget {
  final String namaProduk;
  final int jumlahTerjual;
  final String? imageUrl;

  const ProdukTerlarisWidget({
    super.key,
    required this.namaProduk,
    required this.jumlahTerjual,
    this.imageUrl,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  )
                : Container(width: 56, height: 56, color: Colors.grey[300]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              namaProduk,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$jumlahTerjual',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
