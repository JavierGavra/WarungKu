import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:warung_ku/core/constraint/constraint.dart';
import 'package:warung_ku/features/home/views/home_page.dart';
import 'package:warung_ku/features/product_catalog/services/product_sync_service.dart';
import 'package:warung_ku/features/transaction/services/transaction_sync_service.dart';
// import 'package:warung_ku/features/home/views/main_menu_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isOnline = true;
  Timer? syncTimer;

  @override
  void initState() {
    super.initState();

    // 🔄 Cek status internet
    InternetConnection().onStatusChange.listen(
      (status) => setState(() {
        isOnline = status == InternetStatus.connected;
      }),
    );

    // 🔁 Jalankan background auto-sync tiap 1 menit
    syncTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      if (isOnline) {
        await TransactionSyncService.sync();
        await ProductSyncService().sync();
      }
    });
  }

  @override
  void dispose() {
    syncTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const HomePage(),
    );
  }
}
