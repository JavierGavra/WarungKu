import 'package:flutter/material.dart';
import '../../models/sales_aggregate.dart';

class DailyChart extends StatelessWidget {
  final List<SalesAggregate> data;

  const DailyChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Row(
            children: [
              Text('${e.period.day}/${e.period.month}'),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 12,
                  color: Colors.blue,
                  width: e.total,
                ),
              ),
              const SizedBox(width: 12),
              Text('Rp${e.total.toInt()}'),
            ],
          ),
        );
      }).toList(),
    );
  }
}
