import 'package:flutter/material.dart';
import 'package:warung_ku/features/stock_alert/views/pages/stock_alert_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const StockAlertPage());
  }
}
