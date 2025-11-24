import 'package:flutter/material.dart';
import '../models/sales_aggregate.dart';
import '../models/sales_record.dart';
import '../views/widgets/daily_chart.dart';
import '../views/widgets/date_filter_bar.dart';
import '../views/widgets/total_chart.dart';
import '../views/widgets/weekly_chart.dart';

class SalesSummaryPage extends StatefulWidget {
  const SalesSummaryPage({super.key});

  @override
  State<SalesSummaryPage> createState() => _SalesSummaryPageState();
}

class _SalesSummaryPageState extends State<SalesSummaryPage> {
  String mode = 'daily';

  final List<SalesRecord> dummy = [
    SalesRecord(id: '1', date: DateTime(2025, 1, 1), amount: 20000),
    SalesRecord(id: '2', date: DateTime(2025, 1, 1), amount: 30000),
    SalesRecord(id: '3', date: DateTime(2025, 1, 2), amount: 50000),
    SalesRecord(id: '4', date: DateTime(2025, 1, 3), amount: 40000),
    SalesRecord(id: '5', date: DateTime(2025, 1, 8), amount: 60000),
  ];

  List<SalesAggregate> daily() {
    final Map<String, double> groups = {};
    for (var r in dummy) {
      final key = '${r.date.year}-${r.date.month}-${r.date.day}';
      groups[key] = (groups[key] ?? 0) + r.amount;
    }
    return groups.entries.map((e) {
      final p = e.key.split('-');
      return SalesAggregate(
        period: DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2])),
        total: e.value,
      );
    }).toList()..sort((a, b) => a.period.compareTo(b.period));
  }

  List<SalesAggregate> weekly() {
    final Map<int, double> groups = {};
    for (var r in dummy) {
      final w = weekOfYear(r.date);
      groups[w] = (groups[w] ?? 0) + r.amount;
    }
    return groups.entries
        .map(
          (e) => SalesAggregate(
            period: DateTime(2025, 1, 1).add(Duration(days: (e.key - 1) * 7)),
            total: e.value,
          ),
        )
        .toList()
      ..sort((a, b) => a.period.compareTo(b.period));
  }

  int weekOfYear(DateTime d) {
    final first = DateTime(d.year, 1, 1);
    final diff = d.difference(first).inDays;
    return (diff / 7).floor() + 1;
  }

  double total() => dummy.fold(0, (x, y) => x + y.amount);

  @override
  Widget build(BuildContext context) {
    final dailyData = daily();
    final weeklyData = weekly();

    return Scaffold(
      appBar: AppBar(title: const Text('Sales Summary')),
      body: ListView(
        children: [
          TotalCard(total: total()),
          DateFilterBar(
            selected: mode,
            onSelect: (v) => setState(() => mode = v),
          ),
          const SizedBox(height: 20),
          if (mode == 'daily') DailyChart(data: dailyData),
          if (mode == 'weekly') WeeklyChart(data: weeklyData),
        ],
      ),
    );
  }
}
