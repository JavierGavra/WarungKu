import 'package:flutter/material.dart';

class DateFilterBar extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const DateFilterBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('Harian'),
          selected: selected == 'daily',
          onSelected: (_) => onSelect('daily'),
        ),
        const SizedBox(width: 12),
        ChoiceChip(
          label: const Text('Mingguan'),
          selected: selected == 'weekly',
          onSelected: (_) => onSelect('weekly'),
        ),
      ],
    );
  }
}
