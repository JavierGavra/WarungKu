import '../models/sales_record.dart';

class SalesAggregate {
  final double omzetHariIni;
  final int totalTransaksi;
  final int totalItemTerjual;
  final int totalItem;

  SalesAggregate({
    required this.omzetHariIni,
    required this.totalTransaksi,
    required this.totalItemTerjual,
    required this.totalItem,
  });

  factory SalesAggregate.fromRecords(List<SalesRecord> records) {
    final now = DateTime.now();
    final todayKey = DateTime(now.year, now.month, now.day);

    double omzetToday = 0;
    int transaksiCount = records.length;
    int itemTerjual = 0;
    final uniqueItems = <String>{};

    for (var r in records) {
      final recKey = DateTime(r.date.year, r.date.month, r.date.day);

      if (recKey == todayKey) {
        omzetToday += r.totalPrice;
      }

      itemTerjual += r.quantity;
      uniqueItems.add(r.productId);
    }

    return SalesAggregate(
      omzetHariIni: omzetToday,
      totalTransaksi: transaksiCount,
      totalItemTerjual: itemTerjual,
      totalItem: uniqueItems.length,
    );
  }
}
