import 'package:flutter/material.dart';
import 'package:warung_ku/features/stock_alert/models/stock_alert_model.dart';

class StockAlertPage extends StatelessWidget {
  const StockAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<StockAlertModel> alerts = [
      StockAlertModel(productName: "Indomie Goreng", stock: 3, minStock: 5),
      StockAlertModel(productName: "Beras Premium", stock: 1, minStock: 10),
      StockAlertModel(productName: "Kopi ABC", stock: 8, minStock: 5),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Alert"),
      ),
      body: ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          final isLow = alert.stock <= alert.minStock;

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(
                isLow ? Icons.warning : Icons.check_circle,
                color: isLow ? Colors.red : Colors.green,
              ),
              title: Text(alert.productName),
              subtitle: Text("Stock: ${alert.stock} • Minimal: ${alert.minStock}"),
              trailing: isLow
                  ? const Text(
                      "LOW STOCK",
                      style: TextStyle(color: Colors.red),
                    )
                  : const Text(
                      "OK",
                      style: TextStyle(color: Colors.green),
                    ),
            ),
          );
        },
      ),
    );
  }
}
